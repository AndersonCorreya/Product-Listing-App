import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/widgets/app_button.dart';
import 'package:product_listing_app/features/widgets/bottom_border_textfield.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:product_listing_app/features/auth/presentation/pages/otp_page.dart';
import 'package:product_listing_app/features/widgets/route_transitions.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FlCountryCodePicker _countryCodePicker = const FlCountryCodePicker();
  CountryCode? _selectedCountryCode;
  final TextEditingController _phoneController = TextEditingController();

  // Store verification result
  bool? _userExists;
  String? _preVerifiedToken;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = const CountryCode(
      name: 'India',
      code: 'IN',
      dialCode: '+91',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is UserExistsChecked) {
            // Store verification result and send OTP
            setState(() {
              _userExists = state.exists;
              _preVerifiedToken = state.token;
            });
            // Persist token immediately for existing users (no login-register)
            if (state.exists &&
                (state.token != null && state.token!.isNotEmpty)) {
              context.read<AuthBloc>().add(SaveTokenEvent(state.token!));
            }
            context.read<AuthBloc>().add(
              SendOtpEvent(
                phoneNumber: _phoneController.text,
                countryCode: _selectedCountryCode?.dialCode ?? '+91',
              ),
            );
          } else if (state is OtpSent) {
            // Navigate to OTP page with stored verification info
            Navigator.of(context).push(
              slideRightToLeftRoute(
                OtpPage(
                  phoneNumber: _phoneController.text,
                  countryCode: _selectedCountryCode?.dialCode ?? '+91',
                  existingUser:
                      _userExists ?? false, // Default to false if null
                  preVerifiedToken: _preVerifiedToken,
                ),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const AppText.heading(
                    'Login',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    "Let's connect with Lorem Ipsum..!",
                    type: AppTextType.light,
                    style: TextStyle(fontSize: 14, color: Color(0xFF4E4D4D)),
                  ),
                  const SizedBox(height: 40),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final CountryCode? countryCode =
                              await _countryCodePicker.showPicker(
                                context: context,
                              );
                          if (countryCode != null) {
                            setState(() {
                              _selectedCountryCode = countryCode;
                            });
                          }
                        },
                        child: Container(
                          width: 45,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedCountryCode?.dialCode ?? '+91',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: BottomBorderTextField(
                          controller: _phoneController,
                          hintText: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            // Only allow digits and limit to 10 characters
                            if (value.length > 10) {
                              _phoneController.text = value.substring(0, 10);
                              _phoneController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _phoneController.text.length,
                                    ),
                                  );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 27),
                  AppButton(
                    label: state is AuthLoading ? 'Sending...' : 'Continue',
                    expand: true,
                    type: AppButtonType.filled,
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_phoneController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter your phone number',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            if (_phoneController.text.length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter a valid 10-digit phone number',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // First verify user, then send OTP
                            context.read<AuthBloc>().add(
                              VerifyUserEvent(
                                phoneNumber: _phoneController.text,
                              ),
                            );
                          },
                    backgroundColor: AppColors.blue,
                    borderRadius: 10,
                  ),
                  const SizedBox(height: 27),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 10, color: Colors.black),
                        children: [
                          TextSpan(text: 'By continuing you accepting the '),
                          TextSpan(
                            text: 'Terms of Use & Privacy Policy',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
