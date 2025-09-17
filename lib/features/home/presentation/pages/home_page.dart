import 'package:flutter/material.dart';
import 'package:product_listing_app/features/home/presentation/widgets/dynamic_carousel.dart';
import 'package:product_listing_app/features/home/presentation/widgets/product_card.dart';
import 'package:product_listing_app/features/home/presentation/widgets/search_field.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/home/presentation/pages/search_page.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_state.dart';
import 'package:product_listing_app/features/home/presentation/bloc/product_bloc.dart';
import 'package:product_listing_app/core/utils/responsive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildProductGridSliver(
    BuildContext context,
    List<Map<String, dynamic>> products,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final r = Responsive.of(context);
    final crossAxisCount = screenWidth > 600
        ? 3
        : 2; // 3 columns on tablets, 2 on phones
    final spacing = r.w(16);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: r.w(16.0)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 0.7, // Keep consistent visual ratio
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];
          final String imageUrl =
              (product['featured_image'] ??
                      (product['images'] is List &&
                              (product['images'] as List).isNotEmpty
                          ? (product['images'] as List).first
                          : ''))
                  as String;
          final double mrp = (product['mrp'] is num)
              ? (product['mrp'] as num).toDouble()
              : 0.0;
          final double salePrice = (product['sale_price'] is num)
              ? (product['sale_price'] as num).toDouble()
              : mrp;
          final double rating = (product['avg_rating'] is num)
              ? (product['avg_rating'] as num).toDouble()
              : 0.0;
          final String name = (product['name'] ?? '') as String;
          return ProductCard(
            key: ValueKey<int>(product['id'] as int? ?? index),
            imageUrl: imageUrl,
            originalPrice: mrp,
            discountedPrice: salePrice,
            rating: rating,
            productName: name,
            productId: product['id'] as int?,
            initiallyFavorite: product['in_wishlist'] == true,
            heartIconColor: const Color(0xFF6366F1),
            fullProduct: product,
          );
        }, childCount: products.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(height: 8),
                      Text('Failed to load products'),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProductBloc>().add(
                            const GetProductsEvent(),
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProductLoaded) {
              return CustomScrollView(
                slivers: [
                  // Sticky Search Bar
                  SliverAppBar(
                    scrolledUnderElevation: 0.0,
                    floating: true,
                    pinned: true,
                    snap: false,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    toolbarHeight: r.h(70),
                    automaticallyImplyLeading: false,
                    flexibleSpace: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.w(16.0),
                        vertical: r.h(8.0),
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SearchPage(),
                            ),
                          );
                        },
                        child: const AbsorbPointer(
                          child: CustomSearchField(hintText: 'Search products'),
                        ),
                      ),
                    ),
                  ),
                  // Carousel Section
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: r.h(16)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: r.w(4.0)),
                          child: BlocBuilder<BannerBloc, BannerState>(
                            builder: (context, state) {
                              if (state is BannerLoading) {
                                return Container(
                                  height: r.h(130),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(
                                      r.w(12),
                                    ),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (state is BannerError) {
                                return Container(
                                  height: r.h(150),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(
                                      r.w(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                        SizedBox(height: r.h(8)),
                                        Text(
                                          'Failed to load banners',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (state is BannerLoaded) {
                                final bannerImages = state.banners
                                    .map((banner) => banner.image)
                                    .toList();

                                // Ensure we have at least 3 images by duplicating if needed
                                List<String> carouselImages = [...bannerImages];
                                while (carouselImages.length < 3) {
                                  carouselImages.addAll(bannerImages);
                                }
                                // Take only the first 3 images
                                carouselImages = carouselImages
                                    .take(3)
                                    .toList();

                                return DynamicCarousel(
                                  images: carouselImages,
                                  isNetworkImage: true,
                                  height: r.h(138),
                                  autoPlay: true,
                                  autoPlayDuration: const Duration(seconds: 4),
                                );
                              }

                              // Default/Initial state
                              return Container(
                                height: r.h(138),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(r.w(12)),
                                ),
                                child: const Center(
                                  child: Text(
                                    'No banners available',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: r.h(24)),
                      ],
                    ),
                  ),
                  // Popular Products Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.w(16.0)),
                      child: AppText.heading(
                        'Popular Product',
                        style: TextStyle(
                          fontSize: r.sp(18),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: r.h(16))),
                  // Product Grid
                  _buildProductGridSliver(context, state.popularProducts),
                  // Bottom padding
                  SliverToBoxAdapter(child: SizedBox(height: r.h(20))),
                  // Latest Products Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.w(16.0)),
                      child: AppText.heading(
                        'Latest Products',
                        style: TextStyle(
                          fontSize: r.sp(18),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: r.h(16))),
                  // Product Grid
                  _buildProductGridSliver(context, state.latestProducts),
                  // Bottom padding for floating nav
                  SliverToBoxAdapter(child: SizedBox(height: r.h(100))),
                ],
              );
            }

            // Initial state
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
