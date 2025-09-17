import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String countryCode;

  const SendOtpEvent({required this.phoneNumber, required this.countryCode});

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String countryCode;
  final String otp;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.countryCode,
    required this.otp,
  });

  @override
  List<Object?> get props => [phoneNumber, countryCode, otp];
}

class ResendOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String countryCode;

  const ResendOtpEvent({required this.phoneNumber, required this.countryCode});

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class ClearErrorEvent extends AuthEvent {
  const ClearErrorEvent();
}

class VerifyUserEvent extends AuthEvent {
  final String phoneNumber;

  const VerifyUserEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class LoginRegisterEvent extends AuthEvent {
  final String phoneNumber;
  final String firstName;

  const LoginRegisterEvent({
    required this.phoneNumber,
    required this.firstName,
  });

  @override
  List<Object?> get props => [phoneNumber, firstName];
}

class SaveTokenEvent extends AuthEvent {
  final String token;

  const SaveTokenEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class DeleteTokenEvent extends AuthEvent {
  const DeleteTokenEvent();
}
