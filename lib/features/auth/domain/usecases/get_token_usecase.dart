import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';

class GetTokenUseCase implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  GetTokenUseCase(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return repository.getToken();
  }
}
