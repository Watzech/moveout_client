import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moveout1/constants/main.dart';
import 'package:moveout1/services/get_addresses.dart';

Future<Map<String, dynamic>> getPrice(dynamic info, double distance) async {
  Map<String, dynamic> place = {};

  String size = info["size"];
  int plus = info["plus"];
  bool helpers = info["helpers"];
  bool wrapping = info["wrapping"];

  double truck = 0;

  if (size == "S") {
    truck = 50;
    place["truckSize"] = "Small";
  } else if (size == "M") {
    truck = 100;
    place["truckSize"] = "Medium";
  } else {
    truck = 170;
    place["truckSize"] = "Large";
  }

  double km = 0;
  double obj = 5;
  int helper = helpers ? 120 : 0;
  int wrap = wrapping ? 50 : 0;

  if (distance * 2 <= 10) {
    km = 8.2;
  } else if (distance * 2 <= 60) {
    km = 3.3;
  } else if (distance * 2 <= 120) {
    km = 3;
  } else if (distance * 2 <= 300) {
    km = 2.7;
  } else if (distance * 2 <= 500) {
    km = 2;
  } else if (distance * 2 <= 800) {
    km = 1.9;
  } else if (distance * 2 <= 1000) {
    km = 1.8;
  } else if (distance * 2 >= 2400) {
    km = 1.6;
  } else {
    km = 1.5;
  }

  place["valuePerDistance"] = km * 2;
  place["valueByLoad"] = obj * plus;
  place["valueByTruck"] = truck;
  place["valueByHelper"] = helper;
  place["wrapping"] = wrap;
  place["distance"] = distance;
  place["finalPrice"] =
      (km * 2) * distance + (obj * plus) + truck + helper + wrap;

  return place;
}

Future<Map<String, dynamic>> getQuote(
    dynamic fromPlace, dynamic toPlace, dynamic info) async {
  Map<String, dynamic> quote = {};

  const baseUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json';
  final origins = Uri.encodeComponent(fromPlace["name"].toString());
  final destinations = Uri.encodeComponent(toPlace["name"].toString());
  const units = 'imperial';

  final url =
      '$baseUrl?origins=$origins&destinations=$destinations&units=$units&key=$API_KEY';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      quote["distance"] =
          data["rows"][0]["elements"][0]["distance"]["value"] / 1000;

      quote["helpers"] = info["helpers"];

      quote["price"] = await getPrice(info, quote["distance"]);

      quote["origin"] = {};

      quote["origin"]["address"] = data["origin_addresses"][0];
      quote["origin"]["state"] = getState(data["origin_addresses"][0]);
      quote["origin"]["lat"] = fromPlace["latitude"];
      quote["origin"]["long"] = fromPlace["longitude"];

      quote["destination"] = {};
      quote["destination"]["address"] = data["destination_addresses"][0];
      quote["destination"]["state"] =
          getState(data["destination_addresses"][0]);
      quote["destination"]["lat"] = toPlace["latitude"];
      quote["destination"]["long"] = toPlace["longitude"];

      quote["date"] = [info["date"][0], info["date"][1]];
      quote["load"] = info["load"];

      quote["interesteds"] = [];

      return quote;
    } else {
      quote["error"] = 'Erro na requisição: ${response.statusCode}';
      print('Erro na requisição 1: ${response.statusCode}');

      return quote;
    }
  } catch (e) {
    quote["error"] = 'Erro na requisição: $e';
    print('Erro na requisição 2: $e');

    return quote;
  }
}
