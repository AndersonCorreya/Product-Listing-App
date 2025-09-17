import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyUserUseCase
    implements UseCase<(bool exists, String? token), VerifyUserParams> {
  final AuthRepository repository;

  VerifyUserUseCase(this.repository);

  @override
  Future<Either<Failure, (bool exists, String? token)>> call(
    VerifyUserParams params,
  ) async {
    return repository.verifyUser(phoneNumber: params.phoneNumber);
  }
}

class VerifyUserParams {
  final String phoneNumber;

  VerifyUserParams({required this.phoneNumber});
}
