import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/core/utils/responsive.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:product_listing_app/features/auth/presentation/pages/otp_page.dart';
import 'package:product_listing_app/features/home/presentation/pages/home_page.dart';
import 'package:product_listing_app/features/widgets/app_button.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:product_listing_app/features/widgets/bottom_border_textfield.dart';
import 'package:product_listing_app/features/widgets/route_transitions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Constants
  static const String _defaultCountryName = 'India';
  static const String _defaultCountryCode = 'IN';
  static const String _defaultDialCode = '+91';
  static const int _maxPhoneNumberLength = 10;
  static const double _horizontalPadding = 20.0;
  static const double _topSpacing = 100.0;
  static const double _sectionSpacing = 40.0;
  static const double _smallSpacing = 10.0;
  static const double _mediumSpacing = 27.0;

  // Controllers and state
  final FlCountryCodePicker _countryCodePicker = const FlCountryCodePicker();
  final TextEditingController _phoneController = TextEditingController();

  CountryCode? _selectedCountryCode;
  bool? _userExists;
  String? _preVerifiedToken;

  @override
  void initState() {
    super.initState();
    _initializeDefaultCountry();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _initializeDefaultCountry() {
    _selectedCountryCode = const CountryCode(
      name: _defaultCountryName,
      code: _defaultCountryCode,
      dialCode: _defaultDialCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChanges,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => _buildBody(responsive, state),
        ),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is AuthError) {
      _showErrorSnackBar(context, state.message);
    } else if (state is UserExistsChecked) {
      _handleUserExistsChecked(context, state);
    } else if (state is OtpSent) {
      _navigateToOtpPage(context);
    } else if (state is TokenSaved) {
      _navigateToHomePage(context);
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _handleUserExistsChecked(BuildContext context, UserExistsChecked state) {
    setState(() {
      _userExists = state.exists;
      _preVerifiedToken = state.token;
    });

    // Save token for existing users
    if (state.exists && state.token != null && state.token!.isNotEmpty) {
      context.read<AuthBloc>().add(SaveTokenEvent(state.token!));
    }

    // Send OTP
    context.read<AuthBloc>().add(
      SendOtpEvent(
        phoneNumber: _phoneController.text,
        countryCode: _selectedCountryCode?.dialCode ?? _defaultDialCode,
      ),
    );
  }

  void _navigateToOtpPage(BuildContext context) {
    Navigator.of(context).push(
      slideRightToLeftRoute(
        OtpPage(
          phoneNumber: _phoneController.text,
          countryCode: _selectedCountryCode?.dialCode ?? _defaultDialCode,
          existingUser: _userExists ?? false,
          preVerifiedToken: _preVerifiedToken,
        ),
      ),
    );
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  Widget _buildBody(Responsive responsive, AuthState state) {
    return Padding(
      padding: EdgeInsets.all(responsive.w(_horizontalPadding)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: responsive.h(_topSpacing)),
          _buildHeader(responsive),
          SizedBox(height: responsive.h(_sectionSpacing)),
          _buildPhoneNumberInput(responsive),
          SizedBox(height: responsive.h(_mediumSpacing)),
          _buildContinueButton(responsive, state),
          SizedBox(height: responsive.h(_mediumSpacing)),
          _buildTermsAndConditions(responsive),
        ],
      ),
    );
  }

  Widget _buildHeader(Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.heading(
          'Login',
          style: TextStyle(
            fontSize: responsive.sp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsive.h(_smallSpacing)),
        AppText(
          "Let's connect with Lorem Ipsum..!",
          type: AppTextType.light,
          style: TextStyle(
            fontSize: responsive.sp(14),
            color: const Color(0xFF4E4D4D),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberInput(Responsive responsive) {
    return Row(
      children: [
        _buildCountryCodeSelector(responsive),
        SizedBox(width: responsive.w(8)),
        Expanded(child: _buildPhoneNumberField(responsive)),
      ],
    );
  }

  Widget _buildCountryCodeSelector(Responsive responsive) {
    return GestureDetector(
      onTap: _showCountryCodePicker,
      child: Container(
        width: responsive.w(60),
        height: responsive.h(50),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _selectedCountryCode?.dialCode ?? _defaultDialCode,
              style: TextStyle(
                fontSize: responsive.sp(16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField(Responsive responsive) {
    return BottomBorderTextField(
      controller: _phoneController,
      hintText: 'Phone Number',
      keyboardType: TextInputType.phone,
      onChanged: _handlePhoneNumberChange,
    );
  }

  Widget _buildContinueButton(Responsive responsive, AuthState state) {
    final isLoading = state is AuthLoading;

    return AppButton(
      label: isLoading ? 'Sending...' : 'Continue',
      expand: true,
      type: AppButtonType.filled,
      onPressed: isLoading ? null : _handleContinuePressed,
      backgroundColor: AppColors.blue,
      borderRadius: responsive.w(10),
    );
  }

  Widget _buildTermsAndConditions(Responsive responsive) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: responsive.sp(10), color: Colors.black),
          children: const [
            TextSpan(text: 'By continuing you accepting the '),
            TextSpan(
              text: 'Terms of Use & Privacy Policy',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCountryCodePicker() async {
    final CountryCode? countryCode = await _countryCodePicker.showPicker(
      context: context,
    );

    if (countryCode != null) {
      setState(() {
        _selectedCountryCode = countryCode;
      });
    }
  }

  void _handlePhoneNumberChange(String value) {
    if (value.length > _maxPhoneNumberLength) {
      _phoneController.text = value.substring(0, _maxPhoneNumberLength);
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
    }
  }

  void _handleContinuePressed() {
    if (!_validatePhoneNumber()) {
      return;
    }

    context.read<AuthBloc>().add(
      VerifyUserEvent(phoneNumber: _phoneController.text),
    );
  }

  bool _validatePhoneNumber() {
    final phoneNumber = _phoneController.text;

    if (phoneNumber.isEmpty) {
      _showValidationError('Please enter your phone number');
      return false;
    }

    if (phoneNumber.length != _maxPhoneNumberLength) {
      _showValidationError('Please enter a valid 10-digit phone number');
      return false;
    }

    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
