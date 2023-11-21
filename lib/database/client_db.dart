import '../constants/main.dart' as constants;
import 'package:mongo_dart/mongo_dart.dart';
import '../classes/client.dart';

String url = constants.URL_CONNECTION;
String clientCollectionURL = constants.CLIENT_COLLECTION;

class ClientDb{

  static Db? db;
  static DbCollection? clientCollection;

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

      clientCollection = db?.collection(clientCollectionURL);

    } catch (e) {
      print(e);
    }
  }
  
  static Future<List<Map<String, dynamic>>?> getInfo() async {
    try {
      final users = await clientCollection?.find(where.sortBy('_id')).toList();
      return users;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getInfoByField(List<String> values, String fieldName) async {
    try {
      final users = await clientCollection?.find(where.oneFrom(fieldName, values)).toList();
      return users;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static insert(Client client) async {
    await connect();
    await clientCollection?.insertAll([client.toMap()]);
  }

  static update(Client client) async {
    await connect();
    var u = await clientCollection?.findOne({"cpf": client.cpf});

    u?["name"] = client.name;
    u?["phone"] = client.phone;
    u?["email"] = client.email;
    u?["password"] = client.password;
    u?["photo"] = client.photo;
    u?["address"] = client.address;
    u?["updatedAt"] = client.updatedAt;
    u?["token"] = client.token;

    await clientCollection?.replaceOne({"cpf": client.cpf}, u!);
  }

}