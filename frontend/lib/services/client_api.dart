import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_order_ui/configuration/client.dart';
import 'package:food_order_ui/utils/shared_preferences.dart';

class ClientApi {
  static const String baseUrl = 'http://localhost:8080/api/v1/clients';

  static Future<List<Client>> getClients() async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String? token = sharedPrefsUtil.getToken();
    if (token == null || token.isEmpty) {
      print('Token is null or empty');
      throw Exception('Token is null or empty');
    }
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print('Client API Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Parsed Clients: $jsonResponse');
      return jsonResponse.map((client) => Client.fromJson(client)).toList();
    } else {
      print('Failed to load clients: ${response.reasonPhrase}');
      throw Exception('Failed to load clients');
    }
  }

  static Future<void> updateClient(String clientId, Client updatedClient) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String? token = sharedPrefsUtil.getToken();

    final url = '$baseUrl/$clientId';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updatedClient.toJson()),
    );

    if (response.statusCode == 200) {
      print('Client updated successfully.');
    } else {
      print('Failed to update client: ${response.reasonPhrase}');
      throw Exception('Failed to update client');
    }
  }

  static Future<void> deleteClient(String clientId) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String? token = sharedPrefsUtil.getToken();

    final url = '$baseUrl/$clientId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      print('Client deleted successfully.');
    } else {
      print('Failed to delete client: ${response.reasonPhrase}');
      throw Exception('Failed to delete client');
    }
  }

  static Future<Client> createClient(Client client) async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String? token = sharedPrefsUtil.getToken();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(client.toJson()),
    );
    print('Client API Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 201) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create client');
    }
  }
  static Future<int> getTotalUsers() async {
    final sharedPrefsUtil = SharedPrefsUtil();
    await sharedPrefsUtil.initPrefs();
    String? token = sharedPrefsUtil.getToken();
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/users/count'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load user count');
    }
  }
}