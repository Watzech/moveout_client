
import 'package:mongo_dart/mongo_dart.dart';
import 'package:moveout1/classes/vehicle.dart';

// enum Situation {
//   running,
//   completed,
//   pending,
//   canceled
// }

class Transport {
  final ObjectId request;
  final Vehicle? vehicle;
  final String driver;
  final ObjectId client;
  String situation;
  int rating = 0;
  List<dynamic> scheduledAt;
  DateTime? finishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transport({
    required this.request,
    required this.vehicle,
    required this.driver,
    required this.client,
    required this.situation,
    required this.rating,
    required this.scheduledAt,
    required this.finishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'request': request,
      'vehicle': vehicle,
      'driver': driver,
      'client': client,
      'situation': situation,
      'rating': rating,
      'scheduledAt': scheduledAt,
      'finishedAt': finishedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Transport.fromMap(Map<String, dynamic> map) :
    request = map['request'],
    vehicle = map['vehicle'],
    driver = map['driver'],
    client = map['client'],
    situation = map['situation'],
    rating = map['rating'],
    scheduledAt = map['scheduledAt'],
    finishedAt = map['finishedAt'],
    createdAt = map['createdAt'],
    updatedAt = map['updatedAt'];
}