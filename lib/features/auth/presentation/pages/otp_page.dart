import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/features/auth/presentation/widgets/otp_widget.dart';
import 'package:product_listing_app/features/home/presentation/pages/main_navigation_page.dart';
import 'package:product_listing_app/features/widgets/app_back_button.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:product_listing_app/features/auth/presentation/pages/name_page.dart';
import 'package:product_listing_app/features/widgets/route_transitions.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_state.dart';

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
  final TextEditingController _otpController = TextEditingController();

  // Timer related variables
  Timer? _timer;
  int _remainingSeconds = 120;
  bool _isOnOtpPage = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we're back on the OTP page (e.g., after popping from another page)
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
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is OtpVerified) {
            _isOnOtpPage = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP Verified Successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Existing user: token was already saved on login page (if provided). Go home.
            if (widget.existingUser) {
              Navigator.of(context).pushReplacement(
                slideRightToLeftRoute(const MainNavigationPage()),
              );
            } else {
              // New user -> prompt for name
              Navigator.of(context).push(
                slideRightToLeftRoute(
                  NamePage(phoneNumber: widget.phoneNumber),
                ),
              );
            }
          } else if (state is TokenSaved) {
            // After successful token save, go to Home
            Navigator.of(context).pushReplacement(
              slideRightToLeftRoute(const MainNavigationPage()),
            );
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _otpController.clear();
            _resetTimer();
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final errorText = state is AuthError ? state.message : null;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppBackButton(),
                    const SizedBox(height: 40),
                    AppText.heading(
                      'OTP VERIFICATION',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        AppText.light('Enter the OTP sent to '),
                        AppText.light(
                          '${widget.countryCode} ${widget.phoneNumber}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        AppText.heading(
                          'OTP is ',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AppText.heading(
                          '4749 ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // OTP Input Widget - Clean and reusable!
                    Center(
                      child: OtpInputWidget(
                        controller: _otpController,
                        length: 4,
                        errorText: errorText,
                        onCompleted: (pin) {
                          _handleOtpComplete(pin);
                        },
                        onChanged: (pin) {
                          if (errorText != null) {
                            context.read<AuthBloc>().add(
                              const ClearErrorEvent(),
                            );
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 27),

                    Align(
                      alignment: Alignment.center,
                      child: AppText.light(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 14,
                          color: _remainingSeconds <= 10
                              ? Colors.red
                              : Colors.black,
                          fontWeight: _remainingSeconds <= 10
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),

                    // Resend OTP option
                    Center(
                      child: TextButton(
                        onPressed: isLoading ? null : _handleResendOtp,
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5A5A5A),
                            ),
                            children: [
                              TextSpan(text: "Didn't receive the code? "),
                              TextSpan(
                                text: 'Resend',
                                style: TextStyle(color: Color(0xFF00E5A4)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleOtpComplete(String pin) {
    print('OTP Entered: $pin');
    // Use Bloc to verify OTP
    context.read<AuthBloc>().add(
      VerifyOtpEvent(
        phoneNumber: widget.phoneNumber,
        countryCode: widget.countryCode,
        otp: pin,
      ),
    );
  }

  void _handleResendOtp() {
    // Use Bloc to resend OTP
    context.read<AuthBloc>().add(
      ResendOtpEvent(
        phoneNumber: widget.phoneNumber,
        countryCode: widget.countryCode,
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isOnOtpPage) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer?.cancel();
            _showTimerExpiredSnackbar();
          }
        });
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 120;
    });
    _startTimer();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')} Sec';
  }

  void _showTimerExpiredSnackbar() {
    if (mounted && _isOnOtpPage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP has expired. Please request a new one.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }
}
