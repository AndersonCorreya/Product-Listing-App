import 'package:equatable/equatable.dart';
import 'package:product_listing_app/features/auth/domain/entities/user.dart';
import 'package:product_listing_app/features/auth/domain/entities/otp_verification.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class OtpSent extends AuthState {
  final OtpVerification otpVerification;

  const OtpSent({required this.otpVerification});

  @override
  List<Object?> get props => [otpVerification];
}

class OtpVerified extends AuthState {
  final User user;

  const OtpVerified({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserExistsChecked extends AuthState {
  final bool exists;

  const UserExistsChecked({required this.exists});

  @override
  List<Object?> get props => [exists];
}

class TokenSaved extends AuthState {
  final String token;

  const TokenSaved({required this.token});

  @override
  List<Object?> get props => [token];
}
