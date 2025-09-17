import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:product_listing_app/features/home/data/datasources/product_remote_datasource.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Map<String, dynamic>>> getProducts() async {
    final uri = Uri.parse(
      'http://skilltestflutter.zybotechlab.com/api/products/',
    );
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load products: ${response.statusCode}');
    }

    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }
}
