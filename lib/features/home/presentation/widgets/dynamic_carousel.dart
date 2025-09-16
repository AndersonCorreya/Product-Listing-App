import 'dart:async';
import 'package:flutter/material.dart';

class DynamicCarousel extends StatefulWidget {
  final List<String> images;
  final double height;
  final Duration autoPlayDuration;
  final bool autoPlay;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const DynamicCarousel({
    Key? key,
    required this.images,
    this.height = 138,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.autoPlay = true,
    this.borderRadius,
    this.margin,
  }) : super(key: key);

  @override
  State<DynamicCarousel> createState() => _DynamicCarouselState();
}

class _DynamicCarouselState extends State<DynamicCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    if (widget.autoPlay && widget.images.isNotEmpty) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (_currentIndex < widget.images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No images available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      height: widget.height,
      margin: widget.margin,
      child: Stack(
        children: [
          // Carousel
          ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: widget.height,
                  child: Image.asset(
                    widget.images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Dots Indicator
          if (widget.images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.black
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Usage Example
class CarouselExample extends StatelessWidget {
  const CarouselExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> sampleImages = [
      'assets/images/banner1.jpg',
      'assets/images/banner2.jpg',
      'assets/images/banner3.jpg',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Carousel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Default carousel
            DynamicCarousel(images: sampleImages),

            const SizedBox(height: 20),

            // Customized carousel
            DynamicCarousel(
              images: sampleImages,
              height: 138,
              autoPlay: true,
              autoPlayDuration: const Duration(seconds: 4),
              borderRadius: BorderRadius.circular(16),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ],
        ),
      ),
    );
  }
}
