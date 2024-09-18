import 'dart:convert';
import 'package:food_order_ui/configuration/food.dart';
import 'package:food_order_ui/utils/api_endpoints.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FoodApi {
  static Future<List<Food>> _fetchFoods(String endpoint) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    final accessToken = sharedPrefsUtil.getToken();
    final headers = {'Authorization': 'Bearer $accessToken'};
    final uri = Uri.parse(ApiEnPoints.baseUrl + endpoint);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      if (responseBody.isNotEmpty) {
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);


        if (jsonResponse.containsKey('results')) {
          final List<dynamic> data = jsonResponse['results'];
          return data.map((json) => Food.fromJson(json)).toList();
        } else {
          throw Exception('Response does not contain results');
        }
      } else {
        throw Exception('Response body is null or empty');
      }
    } else {
      throw Exception('Failed to load foods');
    }
  }


  static Future<List<Food>> fetchPopularFoods() async {
    return _fetchFoods(ApiEnPoints.foodEndPoints.popularFood);
  }

  static Future<List<Food>> fetchRecommendFoods() async {
    return _fetchFoods(ApiEnPoints.foodEndPoints.recommendFood);
  }

  static Future<List<dynamic>> searchFoods(String keywords) async {
    final uri = Uri.parse(
        '${ApiEnPoints.baseUrl}${ApiEnPoints.foodEndPoints.search}$keywords?limit=10');
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil
        .initPrefs();
    final accessToken = sharedPrefsUtil.getToken();
    final headers = {'Authorization': 'Bearer $accessToken'};
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isNotEmpty) {
          return json.decode(responseBody);
        } else {
          throw Exception('Response body is null or empty');
        }
      } else {
        throw Exception('Failed to load foods: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Food> createFood(Food food) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    final accessToken = sharedPrefsUtil.getToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final uri = Uri.parse(ApiEnPoints.baseUrl + ApiEnPoints.foodEndPoints.createFood);
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(food.toJson()),
    );
    if (response.statusCode == 201) {
      return Food.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create food');
    }
  }


  static Future<Food> updateFood(String id, Food food) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    final accessToken = sharedPrefsUtil.getToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final uri = Uri.parse(ApiEnPoints.baseUrl + ApiEnPoints.foodEndPoints.updateFood(id));
    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(food.toJson()),
    );
    if (response.statusCode == 200) {
      return Food.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update food');
    }
  }


  static Future<void> deleteFood(String id) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    final accessToken = sharedPrefsUtil.getToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final uri = Uri.parse(ApiEnPoints.baseUrl + ApiEnPoints.foodEndPoints.deleteFood(id));
    final response = await http.delete(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete food');
    }
  }


  static Future<List<Food>> fetchAllFoods() async {
    return _fetchFoods(ApiEnPoints.foodEndPoints.allFoods);
  }

  static Future<List<Food>> getMostFavoritedFoods() async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    final token = sharedPrefsUtil.getToken();

    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/foods/most-favorited'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('results')) {

        List<dynamic> jsonResults = jsonResponse['results'];
        return jsonResults.map((foodJson) => Food.fromJson(foodJson)).toList();
      } else {
        throw Exception('Unexpected response structure');
      }
    } else {
      throw Exception('Failed to load most favorited foods');
    }
  }

}
