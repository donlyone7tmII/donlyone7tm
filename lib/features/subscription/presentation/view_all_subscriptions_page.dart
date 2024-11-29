import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_manager/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:subscription_manager/features/subscription/presentation/add_edit_subscription_page.dart';
import 'package:subscription_manager/core/widgets/loading_state_shimmer_list.dart';
import 'package:subscription_manager/core/widgets/empty_state_list.dart';
import 'package:subscription_manager/core/widgets/error_state_list.dart';
import '../../../core/services/injection_container.dart';
import 'view_subscription_page.dart';

class ViewAllSubscriptionsPage extends StatefulWidget {
  final Function(dynamic selectedSubscription) onTap;
  final Function(dynamic subscriptionId) onDelete;

  const ViewAllSubscriptionsPage({
    super.key,
    required this.onTap,
    required this.onDelete,
  });

  @override
  ViewAllSubscriptionsPageState createState() =>
      ViewAllSubscriptionsPageState();
}

class ViewAllSubscriptionsPageState extends State<ViewAllSubscriptionsPage> {
  @override
  void initState() {
    super.initState();
    _fetchSubscriptions();
  }

  Future<void> _fetchSubscriptions() async {
    final subscriptionCubit = context.read<SubscriptionCubit>();
    await subscriptionCubit.fetchSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscriptions'),
      ),
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const LoadingStateShimmerList();
          } else if (state is SubscriptionLoaded) {
            if (state.subscriptions.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'images/empty.png',
                title: 'No subscriptions yet',
                description: "Tap '+' below to add a new Subscription",
              );
            }
            return ListView.builder(
              itemCount: state.subscriptions.length,
              itemBuilder: (context, index) {
                final subscription = state.subscriptions[index];

                return Card(
                  child: ListTile(
                    title: Text(subscription.name),
                    subtitle: Text('Ends on: ${subscription.endDate.toLocal()}'),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => serviceLocator<SubscriptionCubit>(),
                            child: ViewSubscriptionPage(
                              subscription: subscription,
                            ),
                          ),
                        ),
                      );

                      // If a result is returned, refresh subscriptions list
                      if (context.mounted) {
                        if (result != null && result is String) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result)),
                          );
                          _fetchSubscriptions(); // Refresh the list
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Something went wrong!')),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is SubscriptionError) {
            return ErrorStateList(
              imageAssetName: 'images/error.png',
              errorMessage: state.message,
              onRetry: _fetchSubscriptions,
            );
          }
          return const Center(child: Text('No subscriptions available.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => serviceLocator<SubscriptionCubit>(),
                child: const AddEditSubscriptionPage(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
