import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/exceptions.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/features/home/data/datasources/banner_remote_datasource.dart';
import 'package:product_listing_app/features/home/domain/entities/banner_entity.dart';
import 'package:product_listing_app/features/home/domain/repositories/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;

  BannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    try {
      final banners = await remoteDataSource.getBanners();
      return Right(banners);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
