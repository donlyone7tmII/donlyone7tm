import 'package:dartz/dartz.dart';
import 'package:subscription_manager/features/subscription/domain/entities/subscription.dart';
import 'package:subscription_manager/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:subscription_manager/core/error/failures.dart'; 

class AddSubscription {
  final SubscriptionRepository repository;

  AddSubscription(this.repository);

  Future<Either<Failure, void>> call(Subscription subscription) async {
    return await repository.addSubscription(subscription);
  }
}
