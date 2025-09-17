import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:product_listing_app/features/auth/presentation/pages/name_page.dart';
import 'package:product_listing_app/features/auth/presentation/widgets/otp_widget.dart';
import 'package:product_listing_app/features/home/presentation/pages/main_navigation_page.dart';
import 'package:product_listing_app/features/widgets/app_back_button.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:product_listing_app/features/widgets/route_transitions.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final bool existingUser;
  final String? preVerifiedToken;

  const OtpPage({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
    required this.existingUser,
    this.preVerifiedToken,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  // Constants
  static const double _horizontalPadding = 20.0;
  static const double _backButtonSpacing = 40.0;
  static const double _titleSpacing = 18.0;
  static const double _sectionSpacing = 40.0;
  static const double _otpSpacing = 27.0;
  static const double _resendSpacing = 30.0;
  static const int _otpLength = 4;
  static const int _timerDuration = 120; // 2 minutes
  static const int _warningThreshold = 10; // Show warning when 10 seconds left
  static const String _otpTitle = 'OTP VERIFICATION';
  static const String _otpPrefix = 'OTP is ';
  static const String _hardcodedOtp = '4749';
  static const String _otpSentMessage = 'Enter the OTP sent to ';
  static const String _resendText = "Didn't receive the code? ";
  static const String _resendButtonText = 'Resend';
  static const String _otpVerifiedMessage = 'OTP Verified Successfully!';
  static const String _otpExpiredMessage =
      'OTP has expired. Please request a new one.';

  // Controllers and state
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = _timerDuration;
  bool _isOnOtpPage = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePageVisibility();
  }

  void _updatePageVisibility() {
    if (ModalRoute.of(context)?.isCurrent == true) {
      _isOnOtpPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChanges,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => _buildBody(state),
        ),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is AuthError) {
      _showErrorSnackBar(context, state.message);
    } else if (state is OtpVerified) {
      _handleOtpVerified(context);
    } else if (state is TokenSaved) {
      _navigateToMainPage(context);
    } else if (state is AuthSuccess) {
      _handleAuthSuccess(context, state);
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _handleOtpVerified(BuildContext context) {
    _isOnOtpPage = false;
    _showSuccessSnackBar(_otpVerifiedMessage);

    if (widget.existingUser) {
      _navigateToMainPage(context);
    } else {
      _navigateToNamePage(context);
    }
  }

  void _handleAuthSuccess(BuildContext context, AuthSuccess state) {
    _showSuccessSnackBar(state.message);
    _otpController.clear();
    _resetTimer();
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _navigateToMainPage(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(slideRightToLeftRoute(const MainNavigationPage()));
  }

  void _navigateToNamePage(BuildContext context) {
    Navigator.of(
      context,
    ).push(slideRightToLeftRoute(NamePage(phoneNumber: widget.phoneNumber)));
  }

  Widget _buildBody(AuthState state) {
    final isLoading = state is AuthLoading;
    final errorText = state is AuthError ? state.message : null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(_horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBackButton(),
            const SizedBox(height: _backButtonSpacing),
            _buildHeader(),
            const SizedBox(height: _titleSpacing),
            _buildPhoneNumberDisplay(),
            const SizedBox(height: _sectionSpacing),
            _buildOtpDisplay(),
            const SizedBox(height: _sectionSpacing),
            _buildOtpInput(errorText),
            const SizedBox(height: _otpSpacing),
            _buildTimerDisplay(),
            _buildResendButton(isLoading),
            const SizedBox(height: _resendSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AppText.heading(
      _otpTitle,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPhoneNumberDisplay() {
    return Row(
      children: [
        AppText.light(_otpSentMessage),
        AppText.light(
          '${widget.countryCode} ${widget.phoneNumber}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpDisplay() {
    return Row(
      children: [
        AppText.heading(
          _otpPrefix,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        AppText.heading(
          '$_hardcodedOtp ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput(String? errorText) {
    return Center(
      child: OtpInputWidget(
        controller: _otpController,
        length: _otpLength,
        errorText: errorText,
        onCompleted: _handleOtpComplete,
        onChanged: (pin) => _handleOtpChange(pin, errorText),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    final isWarning = _remainingSeconds <= _warningThreshold;

    return Align(
      alignment: Alignment.center,
      child: AppText.light(
        _formatTime(_remainingSeconds),
        style: TextStyle(
          fontSize: 14,
          color: isWarning ? Colors.red : Colors.black,
          fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildResendButton(bool isLoading) {
    return Center(
      child: TextButton(
        onPressed: isLoading ? null : _handleResendOtp,
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, color: Color(0xFF5A5A5A)),
            children: [
              TextSpan(text: _resendText),
              TextSpan(
                text: _resendButtonText,
                style: TextStyle(color: Color(0xFF00E5A4)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOtpComplete(String pin) {
    context.read<AuthBloc>().add(
      VerifyOtpEvent(
        phoneNumber: widget.phoneNumber,
        countryCode: widget.countryCode,
        otp: pin,
      ),
    );
  }

  void _handleOtpChange(String pin, String? errorText) {
    if (errorText != null) {
      context.read<AuthBloc>().add(const ClearErrorEvent());
    }
  }

  void _handleResendOtp() {
    context.read<AuthBloc>().add(
      ResendOtpEvent(
        phoneNumber: widget.phoneNumber,
        countryCode: widget.countryCode,
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    if (!mounted || !_isOnOtpPage) return;

    setState(() {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
      } else {
        _timer?.cancel();
        _showTimerExpiredSnackbar();
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _timerDuration;
    });
    _startTimer();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')} Sec';
  }

  void _showTimerExpiredSnackbar() {
    if (!mounted || !_isOnOtpPage) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(_otpExpiredMessage),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }
}
