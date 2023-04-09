import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';

enum ResultStateReview { loading, noData, hasData, error }

class AddReviewProvier extends ChangeNotifier {
  final ApiService apiService;

  AddReviewProvier({required this.apiService});

  late List<dynamic> _data;
  late ResultStateReview _state;

  String _message = '';
  String get message => _message;
  List<dynamic> get result => _data;

  ResultStateReview get state => _state;

  Future<dynamic> addReview(
      {required String idRestaurant,
      required String name,
      required String message}) async {
    try {
      _state = ResultStateReview.loading;
      notifyListeners();
      final review = await apiService.addReview(
          id: idRestaurant, name: name, review: message);

      if (review == null.toString()) {
        _state = ResultStateReview.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultStateReview.hasData;
        notifyListeners();

        _data = [];

        return;
      }
    } catch (e) {
      _state = ResultStateReview.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}

String generateRandomString(int length) {
  var random = Random.secure();
  var values = List<int>.generate(length, (i) => random.nextInt(255));
  return String.fromCharCodes(values);
}
