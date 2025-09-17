import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';

class DeleteTokenUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  DeleteTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.deleteToken();
  }
}
