class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final List<dynamic> menus;
  final List<dynamic> drinks;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
    required this.drinks,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> menus = json['menus'] ?? {};

    var foods = menus.containsKey('foods')
        ? menus['foods'].map((key) => key['name'] as String).toList()
        : [];

    var drinks = menus.containsKey('drinks')
        ? menus['drinks'].map((key) => key['name'] as String).toList()
        : [];

    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pictureId:
          "https://restaurant-api.dicoding.dev/images/medium/${json['pictureId'] as String}",
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
      menus: foods,
      drinks: drinks,
    );
  }
}
