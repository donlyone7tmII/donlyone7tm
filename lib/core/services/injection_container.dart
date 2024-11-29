import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:subscription_manager/features/auth/domain/usecases/login.dart';
import 'package:subscription_manager/features/auth/domain/usecases/logout.dart';
import 'package:subscription_manager/features/auth/domain/usecases/register.dart';
import 'package:subscription_manager/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:subscription_manager/features/subscription/domain/usecases/update_subscription.dart';
import 'package:subscription_manager/features/subscription/presentation/cubit/subscription_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/is_logged_in.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/subscription/data/datasources/firebase_remote_data_source.dart';
import '../../features/subscription/data/datasources/subscription_remote_data_source.dart';
import '../../features/subscription/data/repositories/subscription_repository_impl.dart';
import '../../features/subscription/domain/usecases/add_subscription.dart';
import '../../features/subscription/domain/usecases/delete_subscription.dart';
import '../../features/subscription/domain/usecases/get_subscription.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Presentation Layer
  serviceLocator.registerFactory(() => SubscriptionCubit(
    getSubscriptions: serviceLocator(), addSubscription: serviceLocator(), updateSubscription: serviceLocator(), deleteSubscription: serviceLocator()));

  // Domain LAYER
  serviceLocator.registerLazySingleton(() => AddSubscription(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateSubscription(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetSubscriptions(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteSubscription(serviceLocator()));

  // Data Layer

  serviceLocator.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => FirebaseSubscriptionRemoteDataSource(serviceLocator()));
    serviceLocator.registerLazySingleton(
    () => FirebaseFirestore.instance); 

//----------------------------------------------------------------------------------------------//
// Feature 2 - AUTH
    // Presentation Layer
  serviceLocator.registerFactory(() => AuthCubit(
    getCurrentUser: serviceLocator(), login: serviceLocator(), logout: serviceLocator(), register: serviceLocator()));

  // Domain LAYER
  serviceLocator.registerLazySingleton(() => IsLoggedInUseCase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => LoginUseCase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => LogoutUseCase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => RegisterUseCase(repository: serviceLocator()));

  // Data Layer

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSource(serviceLocator()));   
}