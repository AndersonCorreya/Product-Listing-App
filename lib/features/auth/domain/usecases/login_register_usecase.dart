import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';

class LoginRegisterUseCase implements UseCase<String, LoginRegisterParams> {
  final AuthRepository repository;

  LoginRegisterUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(LoginRegisterParams params) async {
    return repository.loginRegister(
      phoneNumber: params.phoneNumber,
      firstName: params.firstName,
    );
  }
}

class LoginRegisterParams {
  final String phoneNumber;
  final String firstName;

  LoginRegisterParams({required this.phoneNumber, required this.firstName});
}
