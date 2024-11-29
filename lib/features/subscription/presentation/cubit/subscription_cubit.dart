import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/usecases/add_subscription.dart';
import '../../domain/usecases/delete_subscription.dart';
import '../../domain/usecases/get_subscription.dart';
import '../../domain/usecases/update_subscription.dart';

part 'subscription_state.dart';

const String noInternetErrorMessage = "Sync Has been Failed!: your Subscription payment will Be saved on your Device and will Sync Automatically when you are back online!";

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final GetSubscriptions getSubscriptions;
  final AddSubscription addSubscription;
  final UpdateSubscription updateSubscription;
  final DeleteSubscription deleteSubscription;

  SubscriptionCubit({
    required this.getSubscriptions,
    required this.addSubscription,
    required this.updateSubscription,
    required this.deleteSubscription,
  }) : super(SubscriptionInitial());

  Future<void> fetchSubscriptions() async {
    emit(SubscriptionLoading()); // Emit loading state

    try {
      // Fetch subscriptions
      final result = await getSubscriptions().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException("Request Timed out!"),
      );

      result.fold(
        (failure) {
          emit(SubscriptionError(_mapFailureToMessage(failure)));
        },
        (subscriptions) {
          if (subscriptions.isEmpty) {
            emit(const SubscriptionError('No subscriptions available.'));
          } else {
            emit(SubscriptionLoaded(subscriptions)); // Emit state with loaded subscriptions
          }
        },
      );
    } catch (e) {
      emit(SubscriptionError('Failed to fetch subscriptions: $e'));
    }
  }

  Future<void> createSubscription(Subscription subscription) async {
    emit(SubscriptionLoading());

    try {
      await FirebaseFirestore.instance.collection('subscriptions').add({
        'id': subscription.id,
        'name': subscription.name,
        'status': subscription.status,
        'startDate': subscription.startDate.toIso8601String(),
        'endDate': subscription.endDate.toIso8601String(),
        'price': subscription.price,
        'description': subscription.description,
      });

      emit(SubscriptionAdded(subscription));
    } catch (error) {
      emit(SubscriptionError('Failed to add subscription: $error'));
    }
  }

  Future<void> modifySubscription(Subscription subscription) async {
    emit(SubscriptionLoading());

    try {
      await FirebaseFirestore.instance.collection('subscriptions')
          .doc(subscription.id)
          .update({
        'name': subscription.name,
        'status': subscription.status,
        'startDate': subscription.startDate.toIso8601String(),
        'endDate': subscription.endDate.toIso8601String(),
        'price': subscription.price,
        'description': subscription.description,
      });

      emit(SubscriptionUpdated(subscription));
    } catch (error) {
      emit(SubscriptionError('Failed to update subscription: $error'));
    }
  }

  Future<void> removeSubscription(String id) async {
    emit(SubscriptionLoading());

    try {
      final result = await deleteSubscription(id).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException("Request Timed out!"),
      );
      result.fold(
        (failure) => emit(SubscriptionError(_mapFailureToMessage(failure))),
        (_) {
          emit(SubscriptionDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(const SubscriptionError('Failed to delete subscription'));
    } catch (e) {
      emit(SubscriptionError('Failed to delete subscription: $e'));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error occurred. Please try again later.';
    } else if (failure is APIFailure) {
      return 'API error: ${failure.message} (Status code: ${failure.statusCode})';
    } else if (failure is CacheFailure) {
      return 'Cache error: ${failure.message}. Please check your local storage.';
    } else if (failure is NetworkFailure) {
      return 'Network error: ${failure.message}. Please check your internet connection.';
    } else if (failure is GeneralFailure) {
      return 'An error occurred: ${failure.message}';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
