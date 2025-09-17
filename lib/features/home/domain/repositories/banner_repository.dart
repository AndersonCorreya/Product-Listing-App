import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/features/home/domain/entities/banner_entity.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<BannerEntity>>> getBanners();
}
