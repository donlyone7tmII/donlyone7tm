import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_manager/core/services/injection_container.dart';
import 'package:subscription_manager/features/subscription/presentation/add_edit_subscription_page.dart';
import '../domain/entities/subscription.dart';
import 'cubit/subscription_cubit.dart';
import 'view_subscription_row.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: ViewSubscriptionPage(
        subscription: Subscription(
          id: '1218372638',
          name: 'Lizza Mae Molejon',
          status: 'Active',
          startDate: DateTime(2024, 11, 17, 11, 48),
          endDate: DateTime(2025, 11, 17, 11, 48),
          price: 1499.00,
          description: 'Lizza Mae Subscribed 1499.00 pesos in Canva Pro',
        ),
      ),
    ),
  ));
}

class ViewSubscriptionPage extends StatefulWidget {
  final Subscription subscription;

  const ViewSubscriptionPage({
    super.key,
    required this.subscription,
  });

  @override
  State<ViewSubscriptionPage> createState() => _ViewSubscriptionPageState();
}

class _ViewSubscriptionPageState extends State<ViewSubscriptionPage> {
  late Subscription _currentSubscription;

  @override
  void initState() {
    super.initState();
    _currentSubscription = widget.subscription; // Initialize with the passed subscription
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionDeleted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Subscription has been Deleted");  // Pop with a result
        } else if (state is SubscriptionError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentSubscription.name),
          actions: [
            IconButton(
              onPressed: () async {
                final updatedSubscription = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => serviceLocator<SubscriptionCubit>(),
                      child: AddEditSubscriptionPage(
                        subscription: _currentSubscription,
                      ),
                    ),
                  ),
                );

                if (updatedSubscription is Subscription) {
                  setState(() {
                    _currentSubscription = updatedSubscription;
                  });
                }
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                const snackBar = SnackBar(
                  content: Text("Deleting Subscription......."),
                  duration: Duration(seconds: 9),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                context.read<SubscriptionCubit>().removeSubscription(widget.subscription.id);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            LabelValueRow(
              label: 'id',
              value: _currentSubscription.id,
            ),
            LabelValueRow(
              label: 'name',
              value: _currentSubscription.name,
            ),
            LabelValueRow(
              label: 'status',
              value: _currentSubscription.status,
            ),
            LabelValueRow(
              label: 'Start Date',
              value: _currentSubscription.startDate,
            ),
            LabelValueRow(
              label: 'End Date',
              value: _currentSubscription.endDate,
            ),
            LabelValueRow(
              label: 'Price',
              value: _currentSubscription.price,
            ),
            LabelValueRow(
              label: 'Description',
              value: _currentSubscription.description,
            ),
          ],
        ),
      ),
    );
  }
}
