import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchRestaurantlist();
  }

  late Restaurant _restaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  Restaurant get result => _restaurant;

  ResultState get state => _state;

  Future<dynamic> _fetchRestaurantlist() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getListRestaurant();
      if (restaurant.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurant = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
