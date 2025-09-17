import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/features/auth/domain/entities/user.dart';
import 'package:product_listing_app/features/auth/domain/entities/otp_verification.dart';

abstract class AuthRepository {
  Future<Either<Failure, OtpVerification>> sendOtp({
    required String phoneNumber,
    required String countryCode,
  });

  Future<Either<Failure, User>> verifyOtp({
    required String phoneNumber,
    required String countryCode,
    required String otp,
  });

  Future<Either<Failure, User>> resendOtp({
    required String phoneNumber,
    required String countryCode,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, (bool exists, String? token)>> verifyUser({
    required String phoneNumber,
  });

  Future<Either<Failure, String>> loginRegister({
    required String phoneNumber,
    required String firstName,
  });

  Future<Either<Failure, void>> saveToken(String token);
}
