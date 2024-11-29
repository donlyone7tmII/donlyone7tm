import 'package:subscription_manager/features/subscription/domain/entities/subscription.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<Subscription>> getSubscriptions();
  Future<void> addSubscription(Subscription subscription);
  Future<void> updateSubscription(Subscription subscription);
  Future<void> deleteSubscription(String id);
}