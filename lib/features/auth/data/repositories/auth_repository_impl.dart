import 'package:dartz/dartz.dart';
import 'package:subscription_manager/core/error/exceptions.dart';
import 'package:subscription_manager/core/error/failures.dart';
import 'package:subscription_manager/features/auth/domain/entities/user.dart';
import 'package:subscription_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:subscription_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import '../models/auth_model.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  const AuthRepositoryImplementation(this._dataSource);

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await _dataSource.getCurrentUser();
      return Right(user as User);
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _dataSource.signInWithEmailAndPassword(email, password);
      return const Right(unit);
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _dataSource.signUpWithEmailAndPassword(email, password);
      return const Right(unit);
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(unit);
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
Future<Either<Failure, UserModel>> login(String email, String password) async {
  try {
    final user = await _dataSource.login(email, password);
    return Right(user);
  } on APIException catch (e) {
    return Left(APIFailure(message: e.message, statusCode: e.statusCode));
  } on Exception catch (e) {
    return Left(GeneralFailure(message: e.toString()));
  }
}

@override
Future<Either<Failure, UserModel>> register(String email, String password, String fullName) async {
  try {
    final user = await _dataSource.register(email, password, fullName);
    return Right(user);
  } on APIException catch (e) {
    return Left(APIFailure(message: e.message, statusCode: e.statusCode));
  } on Exception catch (e) {
    return Left(GeneralFailure(message: e.toString()));
  }
}

}
