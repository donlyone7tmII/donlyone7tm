import 'package:dartz/dartz.dart';
import 'package:subscription_manager/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:subscription_manager/core/error/failures.dart'; 

class DeleteSubscription {
  final SubscriptionRepository repository;

  DeleteSubscription(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteSubscription(id);
  }
}
