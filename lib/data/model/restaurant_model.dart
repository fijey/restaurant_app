import 'package:restaurant_app/data/model/customer_reviews.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final List<dynamic> menus;
  final List<dynamic> drinks;
  final String category;
  final List<CustomerReviewsElement> review;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
    required this.drinks,
    required this.category,
    required this.review,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> menus = json['menus'] ?? {};

    var foods =
        menus['foods']?.map((key) => key['name'] as String).toList() ?? [];

    var drinks =
        menus['drinks']?.map((key) => key['name'] as String).toList() ?? [];

    var customerReview = json['customerReviews'] ?? [];

    return Restaurant(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      pictureId:
          "https://restaurant-api.dicoding.dev/images/medium/${json['pictureId'] ?? ""}",
      city: json['city'] ?? "",
      rating: (json['rating'] ?? 0).toDouble(),
      menus: foods as List,
      drinks: drinks as List,
      category: json['category'] ?? "",
      review: (customerReview as List)
          .map((review) => CustomerReviewsElement.fromJson(review))
          .toList(),
    );
  }
}
