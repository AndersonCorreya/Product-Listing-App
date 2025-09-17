import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/features/home/presentation/pages/main_navigation_page.dart';
import 'package:product_listing_app/features/widgets/app_back_button.dart';
import 'package:product_listing_app/features/widgets/app_button.dart';
import 'package:product_listing_app/features/widgets/bottom_border_textfield.dart';
import 'package:product_listing_app/features/widgets/route_transitions.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_state.dart';

class NamePage extends StatefulWidget {
  final String? phoneNumber;
  const NamePage({super.key, this.phoneNumber});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthLoading) {
              setState(() => _isSubmitting = true);
            } else {
              setState(() => _isSubmitting = false);
            }
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is TokenSaved) {
              Navigator.of(context).pushReplacement(
                slideRightToLeftRoute(const MainNavigationPage()),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBackButton(),
                SizedBox(height: 40),
                BottomBorderTextField(
                  hintText: 'Enter Full Name',
                  textCapitalization: TextCapitalization.words,
                  controller: _nameController,
                ),
                SizedBox(height: 25),
                AppButton(
                  label: 'Continue',
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          final name = _nameController.text.trim();
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter your name'),
                              ),
                            );
                            return;
                          }
                          final phone = widget.phoneNumber ?? '';
                          context.read<AuthBloc>().add(
                            LoginRegisterEvent(
                              phoneNumber: phone,
                              firstName: name,
                            ),
                          );
                        },
                  expand: true,
                  type: AppButtonType.filled,
                  backgroundColor: AppColors.blue,
                  borderRadius: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
