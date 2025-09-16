import 'package:flutter/material.dart';
import 'package:product_listing_app/features/widgets/bottom_border_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              'Login',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Let's connect with Lorem Ipsum..!",
              style: TextStyle(fontSize: 14, color: Color(0xFF4E4D4D)),
            ),
            const SizedBox(height: 40),

            Row(children: [BottomBorderTextField(hintText: '+91', width: 45)]),
          ],
        ),
      ),
    );
  }
}
