import 'package:dartz/dartz.dart';

import 'package:subscription_manager/core/error/failures.dart';

import 'package:subscription_manager/features/auth/domain/entities/user.dart';

import '../repositories/auth_repository.dart';

class IsLoggedInUseCase {
  final AuthRepository repository;

  IsLoggedInUseCase({required this.repository});

  Future<Either<Failure, User>> call() async {
    final user = await repository.getCurrentUser();
    return user;
  }
}
