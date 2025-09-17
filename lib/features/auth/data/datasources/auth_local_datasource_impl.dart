import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_listing_app/features/auth/data/datasources/auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  static const String _tokenKey = 'jwt_token';

  const AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await prefs.remove(_tokenKey);
  }
}
