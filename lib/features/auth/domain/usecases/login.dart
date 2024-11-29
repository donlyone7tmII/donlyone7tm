
import 'package:dartz/dartz.dart';
import 'package:subscription_manager/core/error/failures.dart';
import 'package:subscription_manager/features/auth/domain/entities/user.dart';
import 'package:subscription_manager/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<Failure, User>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
