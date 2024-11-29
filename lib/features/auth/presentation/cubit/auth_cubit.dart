import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/is_logged_in.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsLoggedInUseCase getCurrentUser;
  final LoginUseCase login;
  final LogoutUseCase logout;
  final RegisterUseCase register;

  AuthCubit({
    required this.getCurrentUser,
    required this.login,
    required this.logout,
    required this.register,
  }) : super(AuthInitial());

  // Helper to convert failures to user-friendly messages
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error occurred. Please try again later.';
    } else if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else if (failure is APIFailure) {
      return 'Authentication error. Code: ${failure.statusCode}';
    }
    return 'An unexpected error occurred'; // Ensure this line is present
  }

  // Check if user is already signed in
  Future<void> fetchCurrentUser() async {
    emit(AuthLoading());
    final result = await getCurrentUser();
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user)), // Emit AuthAuthenticated with user
    );
  }

  // Sign in with email and password
  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    final result = await login(email, password);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user)), // Emit AuthAuthenticated with user
    );
  }

  // Sign out
  Future<void> signOutUser() async {
    emit(AuthLoading());
    final result = await logout();
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(AuthUnauthenticated()), // Emit unauthenticated state
    );
  }

  // Sign up with email and password
  Future<void> signUp(String email, String password, String fullName) async {
    emit(AuthLoading());
    final result = await register(email, password, fullName);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user)), // Emit AuthAuthenticated with user
    );
  }
}