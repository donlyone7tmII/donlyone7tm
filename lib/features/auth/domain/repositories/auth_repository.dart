import 'package:dartz/dartz.dart';
import 'package:subscription_manager/core/error/failures.dart';
import 'package:subscription_manager/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Failure, Unit>> signUpWithEmailAndPassword(String email, String password);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String fullName);
}
