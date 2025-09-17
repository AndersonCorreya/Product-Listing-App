import 'package:product_listing_app/features/auth/domain/entities/otp_verification.dart';

class OtpVerificationModel extends OtpVerification {
  const OtpVerificationModel({
    required super.phoneNumber,
    required super.countryCode,
    required super.otp,
    super.expiresAt,
    super.attempts,
  });

  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationModel(
      phoneNumber: json['phone_number'] ?? '',
      countryCode: json['country_code'] ?? '',
      otp: json['otp'] ?? '',
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      attempts: json['attempts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'country_code': countryCode,
      'otp': otp,
      'expires_at': expiresAt?.toIso8601String(),
      'attempts': attempts,
    };
  }

  factory OtpVerificationModel.fromEntity(OtpVerification otpVerification) {
    return OtpVerificationModel(
      phoneNumber: otpVerification.phoneNumber,
      countryCode: otpVerification.countryCode,
      otp: otpVerification.otp,
      expiresAt: otpVerification.expiresAt,
      attempts: otpVerification.attempts,
    );
  }
}
