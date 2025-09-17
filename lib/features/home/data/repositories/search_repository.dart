import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchRepository {
  static const String _endpoint =
      'http://skilltestflutter.zybotechlab.com/api/search/';

  Future<List<Map<String, dynamic>>> search(String query) async {
    final uri = Uri.parse(
      '$_endpoint?query=${Uri.encodeQueryComponent(query)}',
    );
    final response = await http.get(uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> decoded = json.decode(response.body) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    }
    throw Exception('Search failed: ${response.statusCode}');
  }
}
