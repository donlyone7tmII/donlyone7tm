import 'package:dartz/dartz.dart';
import 'package:subscription_manager/core/error/exceptions.dart';
import 'package:subscription_manager/core/error/failures.dart';
import 'package:subscription_manager/features/subscription/domain/entities/subscription.dart';
import 'package:subscription_manager/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:subscription_manager/features/subscription/data/datasources/subscription_remote_data_source.dart';

class SubscriptionRepositoryImplementation implements SubscriptionRepository {
  final SubscriptionRemoteDataSource _dataSource;

  const SubscriptionRepositoryImplementation(this._dataSource);

  @override
  Future<Either<Failure, List<Subscription>>> getSubscriptions() async {
    try {
      return Right(await _dataSource.getSubscriptions()); 
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString())); 
    }
  }

  @override
  Future<Either<Failure, void>> addSubscription(Subscription subscription) async {
    try {
      return Right(await _dataSource.addSubscription(subscription));
    } on APIException catch (e) {
      return Left(ServerFailure(message: e.toString())); // Handle errors
    }
  }

  @override
  Future<Either<Failure, void>> updateSubscription(Subscription subscription) async {
    try {
      return Right(await _dataSource.updateSubscription(subscription)); 
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString())); // Handle errors
    }
  }

  @override
  Future<Either<Failure, void>> deleteSubscription(String id) async {
    try {
      return Right(await _dataSource.deleteSubscription(id)); // Return a successful response
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString())); // Handle errors
    }
  }
}
