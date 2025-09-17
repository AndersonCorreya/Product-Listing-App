import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_listing_app/features/auth/data/datasources/auth_local_datasource.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> getUserData();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final AuthLocalDataSource authLocalDataSource;
  static const String _endpoint =
      'https://skilltestflutter.zybotechlab.com/api/user-data/';

  const UserRemoteDataSourceImpl({required this.authLocalDataSource});

  @override
  Future<Map<String, dynamic>> getUserData() async {
    final token = await authLocalDataSource.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.get(Uri.parse(_endpoint), headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return <String, dynamic>{'raw': decoded};
    }
    throw Exception('Failed to load user data: ${response.statusCode}');
  }
}
