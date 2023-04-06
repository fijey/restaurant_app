import 'package:flutter/services.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

class HomeController {
  Future<String> _loadRestaurantData() async {
    return await rootBundle.loadString('assets/data/data.json');
  }

  Future<String> loadRestaurants() async {
    String jsonRestaurantData = await _loadRestaurantData();

    return jsonRestaurantData;
  }

  List<Restaurant> sortFavorite(listArray) {
    List<Restaurant> data = List.from(listArray);
    data.sort((a, b) => b.rating.compareTo(a.rating));
    return data;
  }
}
