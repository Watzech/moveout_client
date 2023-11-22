import 'package:moveout1/classes/driver.dart';

import '../constants/main.dart' as constants;
import 'package:mongo_dart/mongo_dart.dart';

String url = constants.URL_CONNECTION;
String driverCollectionURL = constants.DRIVER_COLLECTION;

class DriverDb{

  static Db? db;
  static DbCollection? driverCollection;

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

      driverCollection = db?.collection(driverCollectionURL);

    } catch (e) {
      print(e);
    }
  }
  
  static Future<List<Map<String, dynamic>>?> getInfo() async {
    try {
      final drivers = await driverCollection?.find(where.sortBy('_id')).toList();
      return drivers;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getInfoByField(List<dynamic> values, String fieldName) async {
    try {
      final itemList = await driverCollection?.find(where.oneFrom(fieldName, values)).toList();
      return itemList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static insert(Driver driver) async {
    await connect();
    await driverCollection?.insertAll([driver.toMap()]);
  }

  static update(Driver driver) async {
    var u = await driverCollection?.findOne({"cnh": driver.cnh});

    u?["name"] = driver.name;
    u?["phone"] = driver.phone;
    u?["email"] = driver.email;
    u?["password"] = driver.password;
    u?["photo"] = driver.photo;
    u?["cnh"] = driver.cnh;
    u?["address"] = driver.address;
    u?["updatedAt"] = driver.updatedAt;
    u?["token"] = driver.token;

    await driverCollection?.replaceOne({"cnh": driver.cnh}, u!);
  }

}