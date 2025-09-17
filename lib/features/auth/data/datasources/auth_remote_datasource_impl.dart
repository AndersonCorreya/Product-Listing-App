import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:product_listing_app/features/auth/data/models/user_model.dart';
import 'package:product_listing_app/features/auth/data/models/otp_verification_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Replace simulated APIs with real HTTP calls
  static const String _baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  @override
  Future<OtpVerificationModel> sendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    // The backend provided does not expose a send-otp endpoint.
    // We keep this as a no-op generator so the existing OTP UI works.
    final otp = _generateOtp();
    final expiresAt = DateTime.now().add(const Duration(minutes: 5));

    return OtpVerificationModel(
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      otp: otp,
      expiresAt: expiresAt,
      attempts: 0,
    );
  }

  @override
  Future<UserModel> verifyOtp({
    required String phoneNumber,
    required String countryCode,
    required String otp,
  }) async {
    // Keep local OTP verification to preserve current UI behavior
    if (otp == '1234' || otp == '4749') {
      return UserModel(
        id: 'local_user',
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        isVerified: true,
      );
    }
    throw const ValidationFailure(
      message: 'Invalid OTP. Please try again.',
      code: 400,
    );
  }

  @override
  Future<UserModel> resendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    // No backend resend; keep behavior as immediate success
    return UserModel(
      id: 'local_user',
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      isVerified: false,
    );
  }

  String _generateOtp() {
    // Generate a random 4-digit OTP
    return (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();
  }

  @override
  Future<bool> verifyUser({required String phoneNumber}) async {
    // POST /verify/ with phone_number
    try {
      final uri = Uri.parse('$_baseUrl/verify/');
      final response = await http.post(
        uri,
        body: {'phone_number': phoneNumber},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        // Expect backend indicates existence, e.g., { "exists": true/false }
        final exists =
            (body['exists'] == true) ||
            (body['is_exist'] == true) ||
            (body['user_exists'] == true) ||
            (body['status'] == 'exists') ||
            (body['status'] == 'existing_user');
        return exists;
      }
      throw ServerFailure(
        message: 'Verify user failed',
        code: response.statusCode,
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<String> loginRegister({
    required String phoneNumber,
    required String firstName,
  }) async {
    // POST /login-register/ with phone_number, first_name; expect JWT token
    try {
      final uri = Uri.parse('$_baseUrl/login-register/');
      final response = await http.post(
        uri,
        body: {'phone_number': phoneNumber, 'first_name': firstName},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);
        final Map<String, dynamic> body = decoded is Map<String, dynamic>
            ? decoded
            : <String, dynamic>{'raw': decoded};

        String? extractToken(dynamic value) {
          if (value is String) return value;
          if (value is Map<String, dynamic>) {
            // common keys inside nested token objects
            return value['token'] as String? ??
                value['access'] as String? ??
                value['jwt'] as String?;
          }
          return null;
        }

        String? token =
            extractToken(body['token']) ??
            extractToken(body['access']) ??
            extractToken(body['jwt']);

        // sometimes wrapped in data or result
        token =
            token ??
            extractToken((body['data'] as Map<String, dynamic>?)?['token']) ??
            extractToken((body['data'] as Map<String, dynamic>?)?['access']) ??
            extractToken((body['result'] as Map<String, dynamic>?)?['token']);

        if (token == null || token.isEmpty) {
          throw const ServerFailure(message: 'Token missing in response');
        }
        return token;
      }
      throw ServerFailure(
        message: 'Login/Register failed',
        code: response.statusCode,
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw UnknownFailure(message: e.toString());
    }
  }
}
