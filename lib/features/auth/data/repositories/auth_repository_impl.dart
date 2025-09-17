import 'package:dartz/dartz.dart';
import 'package:product_listing_app/core/error/failures.dart';
import 'package:product_listing_app/features/auth/domain/entities/user.dart';
import 'package:product_listing_app/features/auth/domain/entities/otp_verification.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:product_listing_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:product_listing_app/features/auth/data/datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, OtpVerification>> sendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      final otpVerification = await remoteDataSource.sendOtp(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );
      return Right(otpVerification);
    } on ValidationFailure catch (e) {
      return Left(e);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String phoneNumber,
    required String countryCode,
    required String otp,
  }) async {
    try {
      final user = await remoteDataSource.verifyOtp(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        otp: otp,
      );
      return Right(user);
    } on ValidationFailure catch (e) {
      return Left(e);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, User>> resendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      final user = await remoteDataSource.resendOtp(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );
      return Right(user);
    } on ValidationFailure catch (e) {
      return Left(e);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, (bool exists, String? token)>> verifyUser({
    required String phoneNumber,
  }) async {
    try {
      final existsWithToken = await remoteDataSource.verifyUser(
        phoneNumber: phoneNumber,
      );
      return Right(existsWithToken);
    } on ValidationFailure catch (e) {
      return Left(e);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginRegister({
    required String phoneNumber,
    required String firstName,
  }) async {
    try {
      final token = await remoteDataSource.loginRegister(
        phoneNumber: phoneNumber,
        firstName: firstName,
      );
      return Right(token);
    } on ValidationFailure catch (e) {
      return Left(e);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await localDataSource.saveToken(token);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteToken() async {
    try {
      await localDataSource.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
