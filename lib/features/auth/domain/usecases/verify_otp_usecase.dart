import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/auth/domain/entities/user.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<User, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
      otp: params.otp,
    );
  }
}

class VerifyOtpParams {
  final String phoneNumber;
  final String countryCode;
  final String otp;

  VerifyOtpParams({
    required this.phoneNumber,
    required this.countryCode,
    required this.otp,
  });
}
