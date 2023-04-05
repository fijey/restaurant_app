import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant_model.dart';

class ApiService {
  final String _baseUrl = "https://restaurant-api.dicoding.dev/";

  Future<Restaurant> getListRestaurant() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return Restaurant.fromJson(json.decode(response.body)['restaurants']);
    } else {
      throw Exception('Failed to load Retsaurant List');
    }
  }
}
