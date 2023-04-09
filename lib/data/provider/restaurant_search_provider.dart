import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';

enum ResultStateSearch { loading, noData, hasData, error }

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;
  final String query;

  RestaurantSearchProvider({required this.apiService, required this.query}) {
    searchRestaurant(query: query);
  }

  late List<dynamic> _restaurant;
  late List<Restaurant> _restaurantFavorite;
  late List<Restaurant> restaurantListFiltered;
  late ResultStateSearch _state;

  String _message = '';
  String get message => _message;
  List<dynamic> get result => _restaurant;
  List<Restaurant> get result_favorite => _restaurantFavorite;

  ResultStateSearch get state => _state;

  Future<dynamic> searchRestaurant({required String query}) async {
    try {
      _state = ResultStateSearch.loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(query);

      if (restaurant.isEmpty) {
        _state = ResultStateSearch.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateSearch.hasData;
        notifyListeners();
        _restaurant = restaurant;
        print(_restaurant);
        return;
      }
    } on SocketException catch (_) {
      // kode untuk menampilkan pesan error atau widget khusus
      _state = ResultStateSearch.error;
      notifyListeners();
      return _message = 'Tidak Ada Koneksi Internet';
    } catch (e) {
      _state = ResultStateSearch.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
