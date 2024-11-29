import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:subscription_manager/core/error/exceptions.dart';
import 'package:subscription_manager/features/auth/data/datasources/auth_remote_data_source.dart';
import '../../data/models/auth_model.dart';

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuthRemoteDataSource( FirebaseFirestore firebaseFirestore);

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw APIException(
        message: e.message ?? 'Unknown error has occurred',
        statusCode: _mapErrorCode(e.code),
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Create a UserModel from the Firebase user data
        final userModel = UserModel(
          id: firebaseUser.uid, // Assigning uid to id
          email: firebaseUser.email ?? '', // Ensure email is not null
          name: firebaseUser.displayName ?? '', // Provide a default value if displayName is null
          uid: firebaseUser.uid, // Can be removed if not needed separately
          displayName: firebaseUser.displayName ?? '', // Ensure displayName is not null
        );


        // Store user data in Firestore
        await _firestore.collection('users').doc(firebaseUser.uid).set(userModel.toMap());
      }
    } on FirebaseAuthException catch (e) {
      throw APIException(
        message: e.message ?? 'Unknown error has occurred',
        statusCode: _mapErrorCode(e.code),
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw APIException(
        message: e.message ?? 'Unknown error has occurred',
        statusCode: _mapErrorCode(e.code),
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<UserModel>> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        // Convert Firebase user to UserModel and return a list containing the user
        return [
          UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email!,
            name: firebaseUser.displayName,
            displayName: firebaseUser.displayName, uid: '',
          ),
        ];
      } else {
        return [];
      }
    } on FirebaseAuthException catch (e) {
      throw APIException(
        message: e.message ?? 'Unknown error has occurred',
        statusCode: _mapErrorCode(e.code),
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }

 @override
Future<UserModel> login(String email, String password) async {
  try {
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      return UserModel(
        id: firebaseUser.uid,  
        email: firebaseUser.email ?? '', 
        name: '', 
        uid: firebaseUser.uid, 
        displayName: firebaseUser.displayName ?? '',  
      );
    } else {
      throw const APIException(message: "User not found", statusCode: 404);
    }
  } on FirebaseAuthException catch (e) {
    throw APIException(message: e.message ?? 'Unknown error occurred', statusCode: e.code.hashCode);
  }
}


  @override
Future<UserModel> register(String email, String password, String fullName) async {
  try {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    final firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      // Store additional user info in Firestore
      await _firestore.collection('users').doc(firebaseUser.uid).set({
        'email': firebaseUser.email,
        'fullName': fullName,
      });

      // Return a User entity, mapping fields correctly
      return UserModel(
            id: firebaseUser.uid,       
            email: firebaseUser.email ?? '',  // Ensure non-null email
            name: fullName,             
            uid: firebaseUser.uid,       
            displayName: firebaseUser.displayName ?? 'Default Name',           // Ensure photoURL is nullable if needed
            );

    } else {
      throw const APIException(message: "Registration failed", statusCode: 500);
    }
  } on FirebaseAuthException catch (e) {
    throw APIException(message: e.message ?? 'Unknown error occurred', statusCode: e.code.hashCode);
  }
}


  int _mapErrorCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 400;
      case 'user-disabled':
        return 403;
      case 'user-not-found':
        return 404;
      case 'wrong-password':
        return 401;
      default:
        return 500;
    }
  }
}


