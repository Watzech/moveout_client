import 'package:moveout1/classes/client.dart';
import 'package:moveout1/database/client_db.dart';
import 'package:moveout1/services/device_info.dart';

Future<bool> doSignup(String name, String cpf, String phone, String email, String password, var photo, String address, DateTime createdAt, DateTime updatedAt) async {

  Client client = Client(name: name, cpf: cpf, phone: phone, email: email, password: password, photo: photo, address: address, createdAt: createdAt, updatedAt: updatedAt);

  try {
    await ClientDb.connect();
    
    var emailExistList = await ClientDb.getInfoByField([email], "email");
    var cpfExistList = await ClientDb.getInfoByField([cpf], "cpf");

    bool emailExists = emailExistList != null && emailExistList.isNotEmpty;
    bool cpfExists = cpfExistList != null && cpfExistList.isNotEmpty;

    if(!cpfExists && !emailExists){
      String? token = await getNotificationToken();
      client.token = [token];
      await ClientDb.insert(client);
      return true;
    }
    else{
      print("Email ou CPF já existe");
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }

}

Future<dynamic> doLogin(String email, String password) async {
  Map<String, dynamic> result = {};

  try {
    await ClientDb.connect();
    
    dynamic userList = await ClientDb.getInfoByField([email], "email");
    result["done"] = false;
    if(userList != null && userList.isNotEmpty){

      userList.forEach((element) async { 
        if(element['password'] == password){

          result["userData"] = element;
          result["done"] = true;

          Client client = Client.fromMap(element);
          String? token = await getNotificationToken();
          client.token ??= [];
          client.token?.add(token);

          await ClientDb.update(client);
        }
      });

      return result;
    }
    else{
      result["done"] = false;
      return result;
    }

  } catch (e) {
    print(e);
    result["done"] = false;
    return result;
  }

}