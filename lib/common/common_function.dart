import 'package:flutter/services.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

class CommonFunction {
  List<Restaurant> sortFavoriteRestaurant(listArray) {
    List<Restaurant> data = List.from(listArray);
    data.sort((a, b) => b.rating.compareTo(a.rating));
    return data;
  }
}
