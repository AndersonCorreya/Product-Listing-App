import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getProducts();
}
