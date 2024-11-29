import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/subscription.dart';

class SubscriptionModel extends Subscription {
  const SubscriptionModel({
    required super.id,
    required super.name,
    required super.status,
    required super.startDate,
    required super.endDate,
    required super.price,
    required super.description,
  });

  // Method to create a SubscriptionModel from a Map
  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'],
      name: map['name'],
      status: map['status'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      price: (map['price'] as num).toDouble(),
      description: map['description'],
    );
  }

  // Method to create a SubscriptionModel from JSON
  factory SubscriptionModel.fromJson(String source) {
    return SubscriptionModel.fromMap(json.decode(source));
  }

  // Method to convert a SubscriptionModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'price': price,
      'description': description,
    };
  }

  // Method to convert a SubscriptionModel to JSON
  String toJson() {
    return json.encode(toMap());
  }

  // Create a SubscriptionModel from Firestore document data
  factory SubscriptionModel.fromFirestore(Map<String, dynamic> data) {
    return SubscriptionModel(
      id: data["id"],
      name: data["name"],
      status: data["status"],
      startDate: (data["startDate"] as Timestamp).toDate(),
      endDate: (data["endDate"] as Timestamp).toDate(),
      price: data["price"],
      description: data["description"],
    );
  }

  // Convert SubscriptionModel back to Subscription entity
  Subscription toEntity() {
    return Subscription(
      id: id,
      name: name,
      status: status,
      startDate: startDate,
      endDate: endDate,
      price: price,
      description: description,
    );
  }
}
