import 'package:flutter/material.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/features/home/presentation/pages/home_page.dart';
import 'package:product_listing_app/features/widgets/app_back_button.dart';
import 'package:product_listing_app/features/widgets/app_button.dart';
import 'package:product_listing_app/features/widgets/bottom_border_textfield.dart';
import 'package:product_listing_app/features/widgets/route_transitions.dart';

class NamePage extends StatelessWidget {
  const NamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              SizedBox(height: 40),
              BottomBorderTextField(hintText: 'Enter Full Name'),
              SizedBox(height: 25),
              AppButton(
                label: 'Continue',
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(slideRightToLeftRoute(const HomePage()));
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
    );
  }
}
