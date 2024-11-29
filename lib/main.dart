import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_manager/core/services/injection_container.dart';
import 'package:subscription_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:subscription_manager/features/auth/presentation/view/auth_screen.dart';
import 'package:subscription_manager/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:subscription_manager/features/subscription/presentation/view_all_subscriptions_page.dart';
import 'package:subscription_manager/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/subscription/presentation/add_edit_subscription_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  // Method to toggle the theme
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthCubit>()),
        BlocProvider(create: (_) => serviceLocator<SubscriptionCubit>()),
      ],
      child: MaterialApp(
        title: 'Subscription Manager',
        theme: GlobalThemeData.lightThemeData,
        darkTheme: GlobalThemeData.darkThemeData,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: AuthGate(
          toggleTheme: _toggleTheme,
          isDarkMode: _isDarkMode,
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  final VoidCallback toggleTheme;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          context
              .read<SubscriptionCubit>()
              .fetchSubscriptions(); // Fetch subscriptions after login
          return MyHomePage(
            toggleTheme: toggleTheme,
            isDarkMode: isDarkMode,
          );
        } else if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return AuthScreen(
            toggleTheme: toggleTheme,
            isDarkMode: isDarkMode,
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  final VoidCallback toggleTheme;
  final bool isDarkMode;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOutUser();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ViewAllSubscriptionsPage(
            onTap: (selectedSubscription) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditSubscriptionPage(
                      subscription: selectedSubscription),
                ),
              ).then((_) {
                if (context.mounted) {
                  context.read<SubscriptionCubit>().fetchSubscriptions();
                }
              });
            },
            onDelete: (subscriptionId) {
              context
                  .read<SubscriptionCubit>()
                  .removeSubscription(subscriptionId);
            },
          ),
          const AddEditSubscriptionPage(
            subscription: null,
          ),
          const Center(child: Text('User Profile Page - Placeholder')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
