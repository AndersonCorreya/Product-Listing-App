import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/home/domain/entities/banner_entity.dart';
import 'package:product_listing_app/features/home/domain/repositories/banner_repository.dart';

class GetBannersUseCase implements UseCase<List<BannerEntity>, NoParams> {
  final BannerRepository repository;

  GetBannersUseCase(this.repository);

  @override
  Future<Either<Failure, List<BannerEntity>>> call(NoParams params) async {
    return await repository.getBanners();
  }
}
