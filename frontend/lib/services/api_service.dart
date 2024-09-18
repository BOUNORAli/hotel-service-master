import 'dart:convert';
import 'package:food_order_ui/configuration/cart.dart';
import 'package:food_order_ui/utils/api_endpoints.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<String?> login(String email, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var requestBody = {"email": email, "password": password};
    var uri = Uri.parse(ApiEnPoints.baseUrl + ApiEnPoints.authEndpoints.loginEmail);
    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print("Login response status: ${response.statusCode}");
    print("Login response body: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var accessToken = jsonResponse['results']['access_token'];
      var refreshToken = jsonResponse['results']['refresh_token'];

      if (accessToken == null || refreshToken == null) {
        throw Exception('Login failed: Access token or refresh token is null');
      }


      final sharedPrefsUtil = SharedPrefsUtil();
      await sharedPrefsUtil.initPrefs();
      await sharedPrefsUtil.saveToken(accessToken, refreshToken);

      return accessToken;
    } else {
      throw Exception('Login failed: ${response.reasonPhrase}');
    }
  }

  static Future<String> getUserRole(String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var uri = Uri.parse('http://localhost:8080/api/v1/auth/user?token=$token');

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse['role'];
      } else {
        throw Exception('Failed to fetch user role: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching user role: $e');
    }
  }



  static Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    var headers = {'Content-Type': 'application/json'};
    var requestBody = {
      "firstname": firstName,
      "lastname": lastName,
      "email": email,
      "password": password,
      "role": "ADMIN"
    };

    var uri = Uri.parse(ApiEnPoints.baseUrl + ApiEnPoints.authEndpoints.registerEmail);
    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print("Register response status: ${response.statusCode}");
    print("Register response body: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception('Failed to register user: ${response.reasonPhrase}');
    }
  }

  static Future<Map<String, dynamic>> fetchUserData(String token) async {
    var uri = Uri.parse('http://localhost:8080/api/v1/auth/user')
        .replace(queryParameters: {'token': token});
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("User data fetched: $jsonResponse");
      return jsonResponse;
    } else {
      throw Exception('Failed to fetch user data: ${response.reasonPhrase}');
    }
  }



  static Future<void> fetchClients() async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String? token = await sharedPrefsUtil.getToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var uri = Uri.parse('http://localhost:8080/api/v1/clients');
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var clients = jsonDecode(response.body);
      print(clients);
    } else {
      throw Exception('Failed to load clients: ${response.reasonPhrase}');
    }
  }

  static Future<List<dynamic>> fetchPastOrders(String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var uri = Uri.parse('http://localhost:8080/api/v1/orders/past');

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('Failed to load past orders');
    }
  }

  Future<bool> updateUserName(String firstName, String lastName) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String? token = sharedPrefsUtil.getToken();

    if (token != null) {
      final response = await http.patch(
        Uri.parse('http://localhost:8080/api/v1/users/update-name'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      if (response.statusCode == 200) {
        print("Name updated successfully");
        return true;
      } else {
        print("Failed to update name: ${response.body}");
        return false;
      }
    }

    return false;
  }

}
