import 'package:product_listing_app/features/auth/data/models/user_model.dart';
import 'package:product_listing_app/features/auth/data/models/otp_verification_model.dart';

abstract class AuthRemoteDataSource {
  Future<OtpVerificationModel> sendOtp({
    required String phoneNumber,
    required String countryCode,
  });

  Future<UserModel> verifyOtp({
    required String phoneNumber,
    required String countryCode,
    required String otp,
  });

  Future<UserModel> resendOtp({
    required String phoneNumber,
    required String countryCode,
  });

  Future<(bool exists, String? token)> verifyUser({
    required String phoneNumber,
  });

  Future<String> loginRegister({
    required String phoneNumber,
    required String firstName,
  });
}
