import 'package:flutter/material.dart';
import 'package:restaurant_app/common/common_function.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchRestaurantlist();
  }

  late List<dynamic> _restaurant;
  late List<Restaurant> _restaurantFavorite;
  late List<Restaurant> restaurantListFiltered;
  late ResultState _state;

  String _message = '';
  String get message => _message;
  List<dynamic> get result => _restaurant;
  List<Restaurant> get result_favorite => _restaurantFavorite;

  ResultState get state => _state;

  Future<dynamic> _fetchRestaurantlist() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getListRestaurant();
      if (restaurant.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _restaurantFavorite = CommonFunction()
            .sortFavoriteRestaurant(restaurant)
            .take(3)
            .toList();

// Step 1: Buat list baru sebagai data sumber daftar mitra
        restaurantListFiltered = List.from(restaurant);
        restaurantListFiltered.removeWhere(
            (restaurant) => _restaurantFavorite.contains(restaurant));

        _restaurant = restaurantListFiltered;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
