import 'dart:convert';  // To include json.decode for decoding JSON strings
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.uid,
    required super.displayName,  // Added displayName as a required field
    super.photoURL,
  });

  /// Creates a [UserModel] from a Map (for local storage, database, API response)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      uid: map['uid'] as String,  // Make sure to populate uid
      displayName: map['displayName'] as String,  // Make sure to populate displayName
      photoURL: map['photoURL'] as String?,  // Handle nullable photoURL
    );
  }

  /// Creates a [UserModel] from a JSON object (Map)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      uid: json['uid'] as String,  // Ensure uid is properly extracted
      displayName: json['displayName'] as String,  // Ensure displayName is properly extracted
      photoURL: json['photoURL'] as String?,  // Handle nullable photoURL
    );
  }

  /// Creates a [UserModel] from a JSON string
  factory UserModel.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);  // Decode JSON string
    return UserModel.fromJson(jsonMap);  // Convert the decoded map into UserModel
  }

  /// Converts a [UserModel] to a Map (for local storage, database, or API requests)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'uid': uid,  // Ensure uid is included
      'displayName': displayName,  // Ensure displayName is included
      'photoURL': photoURL,  // Handle nullable photoURL
    };
  }

  /// Converts a [UserModel] to a JSON object (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'uid': uid,  // Ensure uid is included
      'displayName': displayName,  // Ensure displayName is included
      'photoURL': photoURL,  // Handle nullable photoURL
    };
  }

  /// Converts a [UserModel] to a JSON string
  String toJsonString() {
    final map = toJson();  // Convert to Map first
    return json.encode(map);  // Encode the Map into a JSON string
  }
}
