import 'package:equatable/equatable.dart';

class OtpVerification extends Equatable {
  final String phoneNumber;
  final String countryCode;
  final String otp;
  final DateTime? expiresAt;
  final int attempts;

  const OtpVerification({
    required this.phoneNumber,
    required this.countryCode,
    required this.otp,
    this.expiresAt,
    this.attempts = 0,
  });

  @override
  List<Object?> get props => [
    phoneNumber,
    countryCode,
    otp,
    expiresAt,
    attempts,
  ];

  OtpVerification copyWith({
    String? phoneNumber,
    String? countryCode,
    String? otp,
    DateTime? expiresAt,
    int? attempts,
  }) {
    return OtpVerification(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      otp: otp ?? this.otp,
      expiresAt: expiresAt ?? this.expiresAt,
      attempts: attempts ?? this.attempts,
    );
  }
}
