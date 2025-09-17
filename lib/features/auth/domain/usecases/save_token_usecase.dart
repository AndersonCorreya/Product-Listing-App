import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';

class SaveTokenUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  SaveTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String token) async {
    return repository.saveToken(token);
  }
}
