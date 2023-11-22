import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:moveout1/database/request_db.dart';
import 'package:moveout1/services/transports.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Save
Future<void> requestSave() async {
  try {
    var prefs = await SharedPreferences.getInstance();
    var user = await getUserInfo();
    var requests = await RequestDb.getInfoByField([user["cpf"]], "cpfClient");

    requests?.forEach((element) {
      element["createdAt"] = element["createdAt"].toString();
      element["updatedAt"] = element["updatedAt"].toString();
    });

    await prefs.setString('requestData', json.encode(requests));
  } catch (e) {
    print(e);
  }
}

Future<void> loginSave(dynamic userInfo) async {

  try {

    userInfo["userData"]["createdAt"] = userInfo["userData"]["createdAt"].toString();
    userInfo["userData"]["updatedAt"] = userInfo["userData"]["updatedAt"].toString();
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', json.encode(userInfo["userData"]));
    await requestSave();

  } catch (e) {
    print(e);
  }
}

Future<void> saveNotificationToken(String? token) async{
  
  try {
    var prefs = await SharedPreferences.getInstance();
    var currentToken = await getNotificationToken();

    if(token != null && token != currentToken){
      await prefs.setString('token', token);
      await removeUserInfo();
    }

  } catch (e) {
    print(e);
  }
}
// Save

// Get
Future<double> getCurrentRating(cnh) async {
  
  double rating = 0;
  var transportList = await getTransports(cnh);

  if(transportList!.isEmpty){
    return 0.0;
  }

  for(var transport in transportList){
    rating += transport["rating"];
  }
  
  return (rating / transportList.length);
}


Future<dynamic> getUserInfo() async {

  var prefs = await SharedPreferences.getInstance();
  final user = prefs.getString("userData") ?? "{}";

  return jsonDecode(user);

}

Future<dynamic> getRequestsInfo() async {

  var prefs = await SharedPreferences.getInstance();
  final requests = prefs.getString("requestData") ?? "{}";

  return jsonDecode(requests);

}

Future<String?> getNotificationToken() async{
  
  try {

    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');

  } catch (e) {
    print(e);
    return null;
  }

}
// Get

// Add
Future<void> addRequestInfo(dynamic newRequest) async {

  var prefs = await SharedPreferences.getInstance();
  final requestsData = prefs.getString("requestData") ?? "[]";

  List<dynamic> requests = jsonDecode(requestsData);

  newRequest["createdAt"] = newRequest["createdAt"].toString();
  newRequest["updatedAt"] = newRequest["updatedAt"].toString();

  requests.add(newRequest);

  await prefs.setString('requestData', json.encode(requests));

}
// Add

// Edit
Future<void> changeRequestSituation(ObjectId id, String situation) async {
  var prefs = await SharedPreferences.getInstance();
  final requestsData = prefs.getString("requestData") ?? "[]";

  List<dynamic> requests = jsonDecode(requestsData);

  for(var element in requests){
    if(ObjectId.parse(element["_id"]) == id){
      element["status"] = situation.toUpperCase();
      element["updatedAt"] = DateTime.now().toString();
    }
  }

  await prefs.setString('requestData', json.encode(requests));
}
// Edit

// Remove
Future<void> removeRequestsInfo(String createdAt) async {

  var prefs = await SharedPreferences.getInstance();
  final requestsData = prefs.getString("requestData") ?? "[]";

  List<dynamic> requests = jsonDecode(requestsData);

  requests.removeWhere((element) => element["createdAt"] == createdAt);

  await prefs.setString('requestData', json.encode(requests));

}

Future<void> removeUserInfo() async {

  var prefs = await SharedPreferences.getInstance();
  prefs.setString("userData", "{}");

}
// Remove