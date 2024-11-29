import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_manager/features/auth/presentation/cubit/auth_cubit.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user; // Assuming user has firstName and lastName
          final displayName = user.displayName;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  'Welcome! $displayName',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 30),

                // Account Section
                Text(
                  'Account Options',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),

                // Accounts Button
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Account'),
                  onTap: () {
                    // Navigate to account settings or profile page
                    // For example: Navigator.push(context, MaterialPageRoute(builder: (_) => AccountSettingsPage()));
                  },
                ),
                const Divider(),

                // Settings Button
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // Navigate to settings page
                    // For example: Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()));
                  },
                ),
                const Divider(),

                // Logout Button
                ElevatedButton(
                  onPressed: () {
                    authCubit.signOutUser();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        } else if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('Not authenticated.'));
        }
      },
    );
  }
}
