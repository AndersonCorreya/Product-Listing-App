import 'package:flutter/material.dart';
import 'package:product_listing_app/features/home/presentation/widgets/dynamic_carousel.dart';
import 'package:product_listing_app/features/home/presentation/widgets/search_field.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              CustomSearchField(hintText: 'Search'),
              SizedBox(height: 24),
              DynamicCarousel(
                images: [
                  'assets/images/image_2.jpg',
                  'assets/images/image_1.jpg',
                  'assets/images/image_1.jpg',
                ],
              ),
              const SizedBox(height: 24),
              AppText.heading(
                'Popular Product',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
