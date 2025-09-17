import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/auth/domain/entities/user.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUseCase implements UseCase<User, ResendOtpParams> {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(ResendOtpParams params) async {
    return await repository.resendOtp(
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
    );
  }
}

class ResendOtpParams {
  final String phoneNumber;
  final String countryCode;

  ResendOtpParams({required this.phoneNumber, required this.countryCode});
}
