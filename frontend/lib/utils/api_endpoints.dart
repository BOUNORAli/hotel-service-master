class ApiEnPoints {
  static const String baseUrl = "http://localhost:8080/api/v1/";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
  static _FoodEndPoints foodEndPoints = _FoodEndPoints();
  static _CategoryEndPoints categoryEndpoints = _CategoryEndPoints();
  static _CartEndPoints cartEndpoints = _CartEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = "auth/register";
  final String loginEmail = "auth/authenticate";
}

class _FoodEndPoints {
  final String popularFood = "foods/popular";
  final String recommendFood = "foods/recommend";
  final String allFoods = "foods";
  final String search = "foods/with/";


  final String createFood = "foods";
  String updateFood(String id) => "foods/$id";
  String deleteFood(String id) => "foods/$id";
}

class _CategoryEndPoints {
  final String categories = "categories";
}

class _CartEndPoints {
  final String emptyCart = "carts/createEmptyCart";
  final String carts = "carts/";
}
