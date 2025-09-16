import 'package:flutter/material.dart';
import 'package:product_listing_app/features/widgets/app_button.dart';
import 'package:product_listing_app/features/widgets/bottom_border_textfield.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:product_listing_app/features/auth/presentation/pages/otp_page.dart';
import 'package:product_listing_app/features/widgets/route_transitions.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(20.0),
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
                BottomBorderTextField(hintText: '+91', width: 45),
                const SizedBox(width: 8),
                Expanded(
                  child: BottomBorderTextField(
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 27),
            AppButton(
              label: 'Continue',
              expand: true,
              type: AppButtonType.filled,
              onPressed: () {
                Navigator.of(
                  context,
                ).push(slideRightToLeftRoute(const OtpPage()));
              },
              backgroundColor: AppColors.blue,
              borderRadius: 10,
            ),
            const SizedBox(height: 27),
            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                  children: const [
                    TextSpan(text: 'By continuing you accepting the '),
                    TextSpan(
                      text: 'Terms of Use & Privacy Policy',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
