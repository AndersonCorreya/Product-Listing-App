import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/verify_user_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/login_register_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/save_token_usecase.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final VerifyUserUseCase verifyUserUseCase;
  final LoginRegisterUseCase loginRegisterUseCase;
  final SaveTokenUseCase saveTokenUseCase;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
    required this.verifyUserUseCase,
    required this.loginRegisterUseCase,
    required this.saveTokenUseCase,
  }) : super(const AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<LogoutEvent>(_onLogout);
    on<ClearErrorEvent>(_onClearError);
    on<VerifyUserEvent>(_onVerifyUser);
    on<LoginRegisterEvent>(_onLoginRegister);
    on<SaveTokenEvent>(_onSaveToken);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await sendOtpUseCase(
      SendOtpParams(
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (otpVerification) => emit(OtpSent(otpVerification: otpVerification)),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await verifyOtpUseCase(
      VerifyOtpParams(
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
        otp: event.otp,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(OtpVerified(user: user)),
    );
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await resendOtpUseCase(
      ResendOtpParams(
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(const AuthSuccess(message: 'OTP resent successfully')),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthInitial());
  }

  void _onClearError(ClearErrorEvent event, Emitter<AuthState> emit) {
    emit(const AuthInitial());
  }

  Future<void> _onVerifyUser(
    VerifyUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await verifyUserUseCase(
      VerifyUserParams(phoneNumber: event.phoneNumber),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (existsWithToken) => emit(
        UserExistsChecked(
          exists: existsWithToken.$1,
          token: existsWithToken.$2,
        ),
      ),
    );
  }

  Future<void> _onLoginRegister(
    LoginRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await loginRegisterUseCase(
      LoginRegisterParams(
        phoneNumber: event.phoneNumber,
        firstName: event.firstName,
      ),
    );
    await result.fold(
      (failure) async => emit(AuthError(message: failure.message)),
      (token) async {
        final saved = await saveTokenUseCase(token);
        saved.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (_) => emit(TokenSaved(token: token)),
        );
      },
    );
  }

  Future<void> _onSaveToken(
    SaveTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final saved = await saveTokenUseCase(event.token);
    saved.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(TokenSaved(token: event.token)),
    );
  }
}
