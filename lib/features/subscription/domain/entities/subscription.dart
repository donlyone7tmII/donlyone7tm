
import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final String id;
  final String name;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final num price;
  final String description;

  const Subscription({
    required this.id,
    required this.name,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.description,
  });

  @override
  List<Object> get props => [id, name, status, startDate, endDate, price, description];
}
