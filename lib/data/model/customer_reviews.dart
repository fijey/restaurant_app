// To parse this JSON data, do
//
//     final customerReviews = customerReviewsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CustomerReviews customerReviewsFromJson(String str) =>
    CustomerReviews.fromJson(json.decode(str));

String customerReviewsToJson(CustomerReviews data) =>
    json.encode(data.toJson());

class CustomerReviews {
  CustomerReviews({
    required this.customerReviews,
  });

  final List<CustomerReviewsElement> customerReviews;

  factory CustomerReviews.fromJson(Map<String, dynamic> json) =>
      CustomerReviews(
        customerReviews: List<CustomerReviewsElement>.from(
            json["customerReviews"]
                .map((x) => CustomerReviewsElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}

class CustomerReviewsElement {
  CustomerReviewsElement({
    required this.name,
    required this.review,
    required this.date,
  });

  final String name;
  final String review;
  final String date;

  factory CustomerReviewsElement.fromJson(Map<String, dynamic> json) =>
      CustomerReviewsElement(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}
