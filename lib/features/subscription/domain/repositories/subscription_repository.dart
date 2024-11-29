import 'package:dartz/dartz.dart';
import 'package:subscription_manager/core/error/failures.dart';
import 'package:subscription_manager/features/subscription/domain/entities/subscription.dart';


abstract class SubscriptionRepository {
  Future<Either<Failure, List<Subscription>>> getSubscriptions();
  Future<Either<Failure, void>> addSubscription(Subscription subscription);
  Future<Either<Failure, void>> updateSubscription(Subscription subscription);
  Future<Either<Failure, void>> deleteSubscription(String id);
}
