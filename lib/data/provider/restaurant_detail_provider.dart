import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

enum ResultStateDetail { loading, noData, hasData, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  RestaurantDetailProvider({required this.apiService, required this.id}) {
    _fetchRestaurantDetail();
  }

  late Restaurant _data;
  late ResultStateDetail _state;

  String _message = '';
  String get message => _message;
  Restaurant get result => _data;

  ResultStateDetail get state => _state;

  Future<dynamic> _fetchRestaurantDetail() async {
    try {
      _state = ResultStateDetail.loading;
      notifyListeners();
      final restaurant = await apiService.getDetailRestaurant(id);
      if (restaurant == null.toString()) {
        _state = ResultStateDetail.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateDetail.hasData;
        notifyListeners();

        _data = restaurant;

        return;
      }
    } catch (e) {
      _state = ResultStateDetail.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
