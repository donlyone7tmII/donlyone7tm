part of 'subscription_cubit.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();
  
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<Subscription> subscriptions;
  
  const SubscriptionLoaded(this.subscriptions);
  
  @override
  List<Object?> get props => [subscriptions];
}

class SubscriptionAdded extends SubscriptionState {
  const SubscriptionAdded(Subscription subscription);
}

class SubscriptionDeleted extends SubscriptionState {}

class SubscriptionUpdated extends SubscriptionState {
  final Subscription newSubscription;

  const SubscriptionUpdated(this.newSubscription);

  @override
  List<Object> get props => [newSubscription];
}

class SubscriptionError extends SubscriptionState {
  final String message;
  
  const SubscriptionError(this.message);
  
  @override
  List<Object?> get props => [message];
}