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

  static Future<Map<String, dynamic>?> getOneBy(String email, String password) async {
    try {
      final user = await clientCollection?.findOne({"email": email, "password": password});
      return user;
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
    var u = await clientCollection?.findOne({"cpf": client.cpf});

    u?["name"] = client.name;
    u?["phone"] = client.phone;
    u?["email"] = client.email;
    u?["password"] = client.password;
    u?["photo"] = client.photo;
    u?["address"] = client.address;
    u?["updatedAt"] = client.updatedAt;

    await clientCollection?.replaceOne({"cpf": client.cpf}, u!);
  }

}