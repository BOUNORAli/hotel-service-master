import 'category.dart';

class Food {
  late String id;
  late String name;
  late String price;
  late List<Category> categories;
  late String imageUrl;
  bool isFavorite;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.categories,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory Food.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('json parameter cannot be null');
    }

    //print('JSON received: $json');

    try {
      final price = json['price'];
      final foodPrice = price != null ? price.toString() : '';

      return Food(
        id: json['id'].toString(),
        name: json['name'] as String? ?? '',
        price: foodPrice,
        categories: (json['categories'] as List<dynamic>?)
            ?.map((category) => Category.fromJson(category))
            .toList() ??
            [],
        imageUrl: json['imageUrl'] as String? ?? '',
        isFavorite: json['isFavorite'] as bool? ?? false,
      );
    } catch (e) {
      print('Error in Food.fromJson: $e');
      rethrow;
    }
  }

  factory Food.fromJsonTwo(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('json parameter cannot be null');
    }

    //print('JSON received: $json');

    try {
      final price = json['price'];
      final foodPrice = price != null ? price.toString() : '';

      return Food(
        id: json['_id'].toString(),
        name: json['name'] as String? ?? '',
        price: foodPrice,
        categories: (json['categories'] as List<dynamic>?)
            ?.map((category) => Category.fromJson(category))
            .toList() ??
            [],
        imageUrl: json['imageUrl'] as String? ?? '',
        isFavorite: json['isFavorite'] as bool? ?? false,
      );
    } catch (e) {
      print('Error in Food.fromJson: $e');
      rethrow;
    }
  }



  static List<Food> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Food.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'categories': categories.map((category) => category.toJson()).toList(),
    'imageUrl': imageUrl,
    'isFavorite': isFavorite,
  };
}
