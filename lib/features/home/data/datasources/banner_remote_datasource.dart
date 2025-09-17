import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_listing_app/core/error/exceptions.dart';
import 'package:product_listing_app/features/home/data/models/banner_model.dart';

abstract class BannerRemoteDataSource {
  Future<List<BannerModel>> getBanners();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final http.Client client;

  BannerRemoteDataSourceImpl({required this.client});

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final uri = Uri.parse(
        'http://skilltestflutter.zybotechlab.com/api/banners/',
      );
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to fetch banners: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to fetch banners: $e');
    }
  }
}
