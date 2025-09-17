import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/auth/domain/entities/otp_verification.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase implements UseCase<OtpVerification, SendOtpParams> {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, OtpVerification>> call(SendOtpParams params) async {
    return await repository.sendOtp(
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
    );
  }
}

class SendOtpParams {
  final String phoneNumber;
  final String countryCode;

  SendOtpParams({required this.phoneNumber, required this.countryCode});
}
