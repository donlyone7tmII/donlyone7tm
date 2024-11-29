import 'package:dartz/dartz.dart';
import 'package:subscription_manager/features/subscription/domain/entities/subscription.dart';
import 'package:subscription_manager/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:subscription_manager/core/error/failures.dart'; 

class GetSubscriptions {
  final SubscriptionRepository repository;

  GetSubscriptions(this.repository);

  Future<Either<Failure, List<Subscription>>> call() async {
    return await repository.getSubscriptions();
  }
}
