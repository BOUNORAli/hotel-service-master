import 'dart:convert';

import 'package:food_order_ui/configuration/category.dart';
import 'package:food_order_ui/utils/api_endpoints.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;


class CategoryApi {
  static Future<List<Category>> fetchCategories() async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    final accessToken = sharedPrefsUtil.getToken();    final headers = {'Authorization': 'Bearer $accessToken'};
    final uri = Uri.parse(ApiEnPoints.baseUrl+ApiEnPoints.categoryEndpoints.categories);

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('results')) {
          final List<dynamic> results = data['results'];
          final List<Category> categories = results.map((categoryJson) => Category.fromJson(categoryJson)).toList();
          return categories;
        } else {
          throw Exception('Invalid response format: Expected "results" key in response');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
