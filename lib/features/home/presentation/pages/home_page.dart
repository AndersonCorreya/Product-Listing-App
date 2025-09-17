import 'package:flutter/material.dart';
import 'package:product_listing_app/features/home/presentation/widgets/dynamic_carousel.dart';
import 'package:product_listing_app/features/home/presentation/widgets/product_card.dart';
import 'package:product_listing_app/features/home/presentation/widgets/search_field.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/core/di/injection_container.dart';
import 'package:product_listing_app/features/home/presentation/bloc/search_bloc.dart';
import 'package:product_listing_app/features/home/presentation/pages/search_page.dart';
import 'package:product_listing_app/features/home/presentation/bloc/wishlist_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_event.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    final uri = Uri.parse(
      'http://skilltestflutter.zybotechlab.com/api/products/',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  List<Map<String, dynamic>> _popularTop4(List<Map<String, dynamic>> products) {
    final sorted = [...products];
    sorted.sort((a, b) {
      final double ra = (a['avg_rating'] is num)
          ? (a['avg_rating'] as num).toDouble()
          : 0.0;
      final double rb = (b['avg_rating'] is num)
          ? (b['avg_rating'] as num).toDouble()
          : 0.0;
      if (rb.compareTo(ra) != 0) return rb.compareTo(ra);
      final double da =
          double.tryParse((a['discount'] ?? '0').toString()) ?? 0.0;
      final double db =
          double.tryParse((b['discount'] ?? '0').toString()) ?? 0.0;
      return db.compareTo(da);
    });
    return sorted.take(4).toList();
  }

  List<Map<String, dynamic>> _latestTop4(List<Map<String, dynamic>> products) {
    final sorted = [...products];
    sorted.sort((a, b) {
      final DateTime da =
          DateTime.tryParse((a['created_date'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final DateTime db =
          DateTime.tryParse((b['created_date'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });
    return sorted.take(4).toList();
  }

  Widget _buildProductGridSliver(
    BuildContext context,
    List<Map<String, dynamic>> products,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600
        ? 3
        : 2; // 3 columns on tablets, 2 on phones
    final spacing = 16.0;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 0.7, // Adjust based on your card design
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
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
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }
            final products = snapshot.data ?? [];
            final popular = _popularTop4(products);
            final latest = _latestTop4(products);
            return MultiBlocProvider(
              providers: [
                BlocProvider<SearchBloc>(create: (_) => sl<SearchBloc>()),
                BlocProvider<WishlistBloc>.value(value: sl<WishlistBloc>()),
                BlocProvider<BannerBloc>(
                  create: (_) => sl<BannerBloc>()..add(const GetBannersEvent()),
                ),
              ],
              child: CustomScrollView(
                slivers: [
                  // Sticky Search Bar
                  SliverAppBar(
                    scrolledUnderElevation: 0.0,
                    floating: true,
                    pinned: true,
                    snap: false,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    toolbarHeight: 70,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
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
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: BlocBuilder<BannerBloc, BannerState>(
                            builder: (context, state) {
                              if (state is BannerLoading) {
                                return Container(
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (state is BannerError) {
                                return Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
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
                                        const SizedBox(height: 8),
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
                                  height: 138,
                                  autoPlay: true,
                                  autoPlayDuration: const Duration(seconds: 4),
                                );
                              }

                              // Default/Initial state
                              return Container(
                                height: 138,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
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
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  // Popular Products Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AppText.heading(
                        'Popular Product',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  // Product Grid
                  _buildProductGridSliver(context, popular),
                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  // Latest Products Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AppText.heading(
                        'Latest Products',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  // Product Grid
                  _buildProductGridSliver(context, latest),
                  // Bottom padding for floating nav
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
