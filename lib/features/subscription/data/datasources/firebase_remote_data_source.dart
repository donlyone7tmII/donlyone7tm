import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subscription_manager/core/error/exceptions.dart';
import 'package:subscription_manager/features/subscription/domain/entities/subscription.dart';
import 'package:subscription_manager/features/subscription/data/models/subscription_model.dart';
import 'package:subscription_manager/features/subscription/data/datasources/subscription_remote_data_source.dart';

class FirebaseSubscriptionRemoteDataSource implements SubscriptionRemoteDataSource {
  final FirebaseFirestore _firestore;

  FirebaseSubscriptionRemoteDataSource(this._firestore);

  @override
  Future<void> addSubscription(Subscription subscription) async {
    try {
      final subscriptionDocRef = _firestore.collection('subscriptions').doc();
      final subscriptionModel = SubscriptionModel(
        id: subscriptionDocRef.id,
        name: subscription.name,
        startDate: subscription.startDate,
        endDate: subscription.endDate,
        price: subscription.price,
        description: subscription.description,
        status: subscription.status,
      );
      await subscriptionDocRef.set(subscriptionModel.toMap());
    } on FirebaseException catch (e) {
      // Handle FirebaseException with appropriate status code
      int statusCode = _mapFirebaseExceptionToStatusCode(e.code);
      throw APIException(message: e.message ?? 'Unknown error has occurred', statusCode: statusCode);
    } on APIException {
      rethrow;
    } catch (e) {
      // General error handling
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }

  int _mapFirebaseExceptionToStatusCode(String errorCode) {
    // Map common Firebase exception codes to integer status codes
    switch (errorCode) {
      case 'unavailable':
        return 503; // Service Unavailable
      case 'deadline-exceeded':
        return 504; // Gateway Timeout
      case 'not-found':
        return 404; // Not Found
      case 'already-exists':
        return 409; // Conflict
      case 'permission-denied':
        return 403; // Forbidden
      default:
        return 500; // Internal Server Error
    }
  }

  @override
  Future<void> deleteSubscription(String name) async {
    try {
      await _firestore.collection('subscriptions').doc(name).delete();
    } on FirebaseException catch (e) {
      // Handle FirebaseException with appropriate status code
      int statusCode = _mapFirebaseExceptionToStatusCode(e.code);
      throw APIException(message: e.message ?? 'Failed to delete subscription', statusCode: statusCode);
    } on APIException {
      rethrow;
    } catch (e) {
      // General error handling
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<Subscription>> getSubscriptions() async {
    try {
      final querySnapshot = await _firestore.collection('subscriptions').get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Subscription(
          id: data["id"] ?? '', // Default to empty string if null
          name: data["name"] ?? 'Unnamed Subscription', // Default name
          status: data["status"] ?? 'Inactive', // Default status
          startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          description: data["description"] ?? '', // Default to empty string
        );
      }).toList();
    } on FirebaseException catch (e) {
      // Handle FirebaseException with appropriate status code
      int statusCode = _mapFirebaseExceptionToStatusCode(e.code);
      throw APIException(message: e.message ?? 'Failed to fetch subscriptions', statusCode: statusCode);
    } on APIException {
      rethrow;
    } catch (e) {
      // General error handling
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    try {
      final subscriptionModel = SubscriptionModel(
        id: subscription.id,
        name: subscription.name,
        startDate: subscription.startDate,
        endDate: subscription.endDate,
        price: subscription.price,
        description: subscription.description,
        status: subscription.status,
      );
      await _firestore.collection('subscriptions').doc(subscriptionModel.id).update(subscriptionModel.toMap());
    } on FirebaseException catch (e) {
      int statusCode = _mapFirebaseExceptionToStatusCode(e.code);
      throw APIException(message: e.message ?? 'Failed to update subscription', statusCode: statusCode);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }
}
