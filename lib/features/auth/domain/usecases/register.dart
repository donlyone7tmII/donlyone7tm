import 'package:dartz/dartz.dart';
import 'package:subscription_manager/core/error/failures.dart';
import 'package:subscription_manager/features/auth/domain/entities/user.dart';
import 'package:subscription_manager/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, User>> call(String email, String password, String fullName) async {
    return await repository.register(email, password, fullName);
  }
}
