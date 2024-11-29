import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
   final String uid;
  final String? displayName;
  final String? photoURL;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.uid,
    this.displayName,
    this.photoURL,
  });

  @override
  List<Object?> get props => [id, email, name];
}
