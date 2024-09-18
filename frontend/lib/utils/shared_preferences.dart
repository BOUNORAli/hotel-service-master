import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil {
  SharedPreferences? _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String getToken() {
    String token = _prefs?.getString('access_token') ?? '';
    print('Retrieved Token: $token');
    return token;
  }

  String getCartId() {
    return _prefs?.getString('cart_id') ?? '';
  }

  String getUserId() {
    return _prefs?.getString('user_id') ?? '';
  }

  Future<void> saveToken(String accessToken, String refreshToken) async {
    await _prefs?.setString('access_token', accessToken);
    await _prefs?.setString('refresh_token', refreshToken);
  }

  Future<void> saveCartId(String? cartId) async {
    await _prefs?.setString('cart_id', cartId!);
  }

  Future<void> saveUserId(String? userId) async {
    await _prefs?.setString('user_id', userId!);
  }

  Future<void> saveFavorites(List<String> favoriteIds) async {
    await _prefs?.setStringList('favorites', favoriteIds);
  }

  List<String> getFavorites() {
    return _prefs?.getStringList('favorites') ?? [];
  }
}
