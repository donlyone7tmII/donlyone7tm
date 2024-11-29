import 'package:subscription_manager/features/auth/data/models/auth_model.dart';
import 'package:subscription_manager/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<List<User>> getCurrentUser();

  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String fullName);
}
