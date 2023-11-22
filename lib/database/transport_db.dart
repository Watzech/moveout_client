import 'package:moveout1/classes/transport.dart';

import '../constants/main.dart' as constants;
import 'package:mongo_dart/mongo_dart.dart';

String url = constants.URL_CONNECTION;
String transportCollectionURL = constants.TRANSPORT_COLLECTION;

class TransportDb{

  static Db? db;
  static DbCollection? transportCollection;

  static connect() async {

    try{
      db?.close();
    } catch (e){
      print(e);
    }

    try {
      
      db = await Db.create(url);
      await db?.open();

      db?.databaseName = "MoveOut";

      transportCollection = db?.collection(transportCollectionURL);

    } catch (e) {
      print(e);
    }
  }
  
  static Future<List<Map<String, dynamic>>?> getInfo() async {
    try {
      final transport = await transportCollection?.find(where.sortBy('_id')).toList();
      return transport;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getInfoByField(List<String> values, String fieldName) async {
    try {
      await TransportDb.connect();
      final transports = await transportCollection?.find(where.oneFrom(fieldName, values)).toList();
      return transports;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static insert(Transport transport) async {
    await connect();
    await transportCollection?.insertAll([transport.toMap()]);
  }

  static update(Transport transport) async {
    var u = await transportCollection?.findOne({"request": transport.request});

    u?["request"] = transport.request;
    u?["vehicle"] = transport.vehicle;
    u?["driver"] = transport.driver;
    u?["client"] = transport.client;
    u?["situation"] = transport.situation;
    u?["rating"] = transport.rating;
    u?["scheduledAt"] = transport.scheduledAt;
    u?["finishedAt"] = transport.finishedAt;
    u?["updatedAt"] = transport.updatedAt;

    await transportCollection?.replaceOne({"request": transport.request}, u!);
  }

}