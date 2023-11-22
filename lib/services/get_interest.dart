import 'package:moveout1/database/driver_db.dart';

Future<List<Map<String, dynamic>>?> getInterests(List<dynamic> driversId) async{
  DriverDb.connect();
  List<Map<String, dynamic>>? drivers = await DriverDb.getInfoByField(driversId, 'cnh');

  return drivers;
}