import 'package:dartz/dartz.dart';

import 'package:subscription_manager/core/error/failures.dart';

import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.signOut();
  }
}
