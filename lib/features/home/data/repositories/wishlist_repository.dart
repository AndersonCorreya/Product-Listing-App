import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_listing_app/features/auth/data/datasources/auth_local_datasource.dart';

class WishlistRepository {
  static const String _endpoint =
      'https://skilltestflutter.zybotechlab.com/api/add-remove-wishlist/';
  static const String _wishlistListEndpoint =
      'https://skilltestflutter.zybotechlab.com/api/wishlist/';
  final AuthLocalDataSource authLocalDataSource;

  WishlistRepository({required this.authLocalDataSource});

  Future<Map<String, String>> _buildAuthHeaders({bool json = false}) async {
    final token = await authLocalDataSource.getToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    if (json) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }

  Future<List<Map<String, dynamic>>> fetchWishlist() async {
    final uri = Uri.parse(_wishlistListEndpoint);
    final headers = await _buildAuthHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> decoded = json.decode(response.body) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    }
    // If 404/204 means empty wishlist, return empty
    if (response.statusCode == 404 || response.statusCode == 204) {
      return <Map<String, dynamic>>[];
    }
    throw Exception('Fetch wishlist failed: ${response.statusCode}');
  }

  Future<void> toggleWishlist(int productId) async {
    final uri = Uri.parse(_endpoint);
    final response = await http.post(
      uri,
      headers: await _buildAuthHeaders(json: true),
      body: jsonEncode(<String, dynamic>{'product_id': productId}),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw Exception('Toggle wishlist failed: ${response.statusCode}');
  }
}
