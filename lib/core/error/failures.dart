import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message; 

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server failure'});

  @override
  List<Object?> get props => [message];
}


class APIFailure extends Failure {
  final int statusCode;

  const APIFailure({
    required super.message,
    required this.statusCode,
  }); 

  @override
  List<Object> get props => [message, statusCode]; 
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class GeneralFailure extends Failure {
  const GeneralFailure({required super.message});
}