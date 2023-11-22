import 'package:moveout1/database/transport_db.dart';

Future<List<Map<String, dynamic>>?> getTransports(cnh) async {

  try {
    
    var transportList = await TransportDb.getInfoByField([cnh], "driver");

    return transportList;

  } catch (e) {
    print(e);
    return null;
  }

}