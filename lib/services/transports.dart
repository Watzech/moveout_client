import 'package:mongo_dart/mongo_dart.dart';
import 'package:moveout1/classes/driver.dart';
import 'package:moveout1/classes/request.dart';
import 'package:moveout1/classes/transport.dart';
import 'package:moveout1/database/driver_db.dart';
import 'package:moveout1/database/request_db.dart';
import 'package:moveout1/database/transport_db.dart';
import 'package:moveout1/services/device_info.dart';
import 'package:http/http.dart' as http;

Future<void> setDriver(Request request, Driver driver) async {

  await RequestDb.update(request);
  dynamic user = await getUserInfo();

  Transport transport = Transport(
    request: request.id,
    vehicle: null,
    driver: driver.cnh,
    client: ObjectId.parse(user["_id"]),
    situation: "Pending",
    rating: 0,
    scheduledAt: request.date,
    finishedAt: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now()
  );

  await TransportDb.insert(transport);
  await changeRequestSituation(request.id, "AG");

  List<dynamic>? tokens = driver.token;
  
  if(tokens != null){
    String title = "Você foi escolhido para um transporte";
    String desc = "Clique para acessar!";
    for(var token in tokens){
      try {
        http.get(Uri.https("us-central1-moveout-c74de.cloudfunctions.net", "sendMessage", {"token": token, "title": title, "body": desc}));
      } catch (e) {
        print(e);
      }
    }
  }

}

Future<bool> endTransport(Request request) async {
  
  try {
    dynamic transportMap = await getTransport(request.id);
    Transport transport = Transport.fromMap(transportMap);
    transport.situation = "Completed";

    await TransportDb.update(transport);
    await RequestDb.update(request);
    await changeRequestSituation(request.id, "AG");

    return true;
  } catch (e) {
    print(e);
    return false;
  }

}

Future<Driver?> getDriver(cnh) async {

  try {
    
    var driverList = await DriverDb.getInfoByField([cnh], "cnh");

    return Driver.fromMap(driverList![0]);

  } catch (e) {
    print(e);
    return null;
  }

}

Future<Map<String, dynamic>?> getTransport(request) async {

  try {
    
    var transportList = await TransportDb.getInfoByField([request], "request");

    return transportList![0];

  } catch (e) {
    print(e);
    return null;
  }

}

Future<List<Map<String, dynamic>>?> getTransports(cnh) async {

  try {
    
    var transportList = await TransportDb.getInfoByField([cnh], "driver");

    return transportList;

  } catch (e) {
    print(e);
    return null;
  }

}

double getCurrentRating(transportList) {
  
  double rating = 0;

  if(transportList == null || transportList!.isEmpty){
    return 0.0;
  }

  for(var transport in transportList){
    rating += transport["rating"];
  }
  
  return (rating / transportList.length);
}