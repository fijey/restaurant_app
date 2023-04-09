import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant_model.dart';

class ApiService {
  final String _baseUrl = "https://restaurant-api.dicoding.dev/";

  Future<List<dynamic>> getListRestaurant() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      List<dynamic> listRestaurant = json
          .decode(response.body)['restaurants']
          .map((restaurant) =>
              Restaurant.fromJson(restaurant as Map<String, dynamic>))
          .toList();

      return listRestaurant;
      // return Restaurant.fromJson(json.decode(response.body)['restaurants']);
    } else {
      throw Exception('Failed to load Retsaurant List');
    }
  }

  Future<Restaurant> getDetailRestaurant(String id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return Restaurant.fromJson(json.decode(response.body)['restaurant']);
    } else {
      throw Exception('Failed to load Retsaurant List');
    }
  }

  Future<List<dynamic>> searchRestaurant(query) async {
    final response = await http.get(Uri.parse("${_baseUrl}search?q=$query"));
    if (response.statusCode == 200) {
      List<dynamic> listRestaurant = json
          .decode(response.body)['restaurants']
          .map((restaurant) =>
              Restaurant.fromJson(restaurant as Map<String, dynamic>))
          .toList();

      return listRestaurant;
      // return Restaurant.fromJson(json.decode(response.body)['restaurants']);
    } else {
      throw Exception('Failed to load Retsaurant List');
    }
  }
}
