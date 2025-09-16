import 'package:flutter/material.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/features/auth/presentation/widgets/otp_widget.dart';
import 'package:product_listing_app/features/widgets/app_back_button.dart';
import 'package:product_listing_app/features/widgets/app_button.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:product_listing_app/features/auth/presentation/pages/name_page.dart';
import 'package:product_listing_app/features/widgets/route_transitions.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
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
                    '+91 9876543210',
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
                  errorText: _errorText,
                  onCompleted: (pin) {
                    _handleOtpComplete(pin);
                  },
                  onChanged: (pin) {
                    if (_errorText != null) {
                      setState(() {
                        _errorText = null;
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 27),

              Align(
                alignment: Alignment.center,
                child: AppText.light(
                  "00:120 Sec",
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),

              // Resend OTP option
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : _handleResendOtp,
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14, color: Color(0xFF5A5A5A)),
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
              AppButton(
                type: AppButtonType.filled,
                expand: true,
                label: 'Submit',
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.of(
                          context,
                        ).push(slideRightToLeftRoute(const NamePage()));
                      },
                backgroundColor: AppColors.blue,
                borderRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOtpComplete(String pin) {
    print('OTP Entered: $pin');
    // Automatically verify when OTP is complete
    _verifyOtp(pin);
  }

  Future<void> _verifyOtp(String otp) async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // For demo - check if OTP matches the displayed one
      if (otp == '4749') {
        // Success - navigate to next screen
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP Verified Successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigator.pushReplacement(context, ...);
        }
      } else {
        // Invalid OTP
        setState(() {
          _errorText = 'Invalid OTP. Please try again.';
        });
        _otpController.clear();
      }
    } catch (e) {
      setState(() {
        _errorText = 'Verification failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResendOtp() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      // Simulate resend API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP Resent Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _otpController.clear();
      }
    } catch (e) {
      setState(() {
        _errorText = 'Failed to resend OTP. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
