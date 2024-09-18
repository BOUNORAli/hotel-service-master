class Category {
  final String categoryId;
  final String categoryName;
  final String categoryImage;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final categoryId = json['categoryId'] as String? ?? '';
    final categoryName = json['categoryName'] as String? ?? '';
    final categoryImage = json['categoryImage'] as String? ?? '';

    return Category(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryImage: categoryImage,
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
    'categoryImage': categoryImage,
  };

}
