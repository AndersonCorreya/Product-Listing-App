import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/home/domain/repositories/product_repository.dart';

class GetProductsUseCase
    implements UseCase<List<Map<String, dynamic>>, NoParams> {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
    NoParams params,
  ) async {
    return await repository.getProducts();
  }
}
