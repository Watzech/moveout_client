import 'package:mongo_dart/mongo_dart.dart';

class Request {
  ObjectId id;
  final String cpfClient;
  dynamic price;
  dynamic origin;
  dynamic destination;
  dynamic distance;
  bool helpers;
  List<dynamic> interesteds = [];
  List<dynamic> date = [];
  Map<dynamic, dynamic> load;
  final DateTime createdAt;
  final DateTime updatedAt;
  String status;

  Request({
    required this.id,
    required this.cpfClient,
    required this.price,
    required this.origin,
    required this.destination,
    required this.distance,
    required this.interesteds,
    required this.date,
    required this.helpers,
    required this.load,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'cpfClient': cpfClient,
      'price': price,
      'origin': origin,
      'destination': destination,
      'distance': distance,
      'interesteds': interesteds,
      'date': date,
      'helpers': helpers,
      'load': load,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status
    };
  }

  Request.fromMap(Map<String, dynamic> map)
      : id = ObjectId.parse(map['_id']),
        cpfClient = map['cpfClient'],
        price = map['price'],
        origin = map['origin'],
        destination = map['destination'],
        distance = map['distance'],
        interesteds = map['interesteds'],
        date = map['date'],
        helpers = map['helpers'],
        load = map['load'],
        createdAt = DateTime.parse(map['createdAt']),
        updatedAt = DateTime.parse(map['updatedAt']),
        status = map['status'];
}
