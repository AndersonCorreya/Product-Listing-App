import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:product_listing_app/features/home/presentation/pages/main_navigation_page.dart';
import 'package:product_listing_app/features/widgets/app_back_button.dart';
import 'package:product_listing_app/features/widgets/app_button.dart';
import 'package:product_listing_app/features/widgets/bottom_border_textfield.dart';
import 'package:product_listing_app/features/widgets/route_transitions.dart';

class NamePage extends StatefulWidget {
  final String? phoneNumber;

  const NamePage({super.key, this.phoneNumber});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  // Constants
  static const double _horizontalPadding = 20.0;
  static const double _backButtonSpacing = 40.0;
  static const double _fieldSpacing = 25.0;
  static const double _buttonBorderRadius = 10.0;
  static const String _hintText = 'Enter Full Name';
  static const String _buttonLabel = 'Continue';
  static const String _emptyNameError = 'Please enter your name';

  // Controllers and state
  final TextEditingController _nameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: _handleAuthStateChanges,
          child: _buildBody(),
        ),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    _updateLoadingState(state);

    if (state is AuthError) {
      _showErrorSnackBar(context, state.message);
    } else if (state is TokenSaved) {
      _navigateToMainPage(context);
    }
  }

  void _updateLoadingState(AuthState state) {
    final isLoading = state is AuthLoading;
    if (_isSubmitting != isLoading) {
      setState(() {
        _isSubmitting = isLoading;
      });
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _navigateToMainPage(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(slideRightToLeftRoute(const MainNavigationPage()));
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(_horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBackButton(),
          const SizedBox(height: _backButtonSpacing),
          _buildNameInputField(),
          const SizedBox(height: _fieldSpacing),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildNameInputField() {
    return BottomBorderTextField(
      hintText: _hintText,
      textCapitalization: TextCapitalization.words,
      controller: _nameController,
    );
  }

  Widget _buildContinueButton() {
    return AppButton(
      label: _buttonLabel,
      onPressed: _isSubmitting ? null : _handleContinuePressed,
      expand: true,
      type: AppButtonType.filled,
      backgroundColor: AppColors.blue,
      borderRadius: _buttonBorderRadius,
    );
  }

  void _handleContinuePressed() {
    final name = _nameController.text.trim();

    if (!_validateName(name)) {
      return;
    }

    _submitRegistration(name);
  }

  bool _validateName(String name) {
    if (name.isEmpty) {
      _showValidationError(_emptyNameError);
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _submitRegistration(String name) {
    final phoneNumber = widget.phoneNumber ?? '';

    context.read<AuthBloc>().add(
      LoginRegisterEvent(phoneNumber: phoneNumber, firstName: name),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
