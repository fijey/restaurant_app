import 'package:flutter/services.dart';

class HomeController {
  Future<String> _loadRestaurantData() async {
    return await rootBundle.loadString('assets/data/data.json');
  }

  Future<String> loadRestaurants() async {
    String jsonRestaurantData = await _loadRestaurantData();

    return jsonRestaurantData;
  }

  List<dynamic> sortFavorite(list_array) {
    List<dynamic> data = List.from(list_array);
    data.sort((a, b) => b.rating.compareTo(a.rating));
    return data;
  }
}
