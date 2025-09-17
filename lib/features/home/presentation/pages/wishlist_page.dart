import 'package:flutter/material.dart';
import 'package:product_listing_app/features/home/presentation/widgets/product_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/wishlist_bloc.dart';
import 'package:product_listing_app/core/di/injection_container.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  Widget _buildWishlistGrid(
    BuildContext context,
    List<Map<String, dynamic>> items,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final spacing = 16.0;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = items[index];
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
            imageUrl: imageUrl,
            originalPrice: mrp,
            discountedPrice: salePrice,
            rating: rating,
            productName: name,
            productId: product['id'] as int?,
            initiallyFavorite: true,
            heartIconColor: const Color(0xFF6366F1),
          );
        }, childCount: items.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WishlistBloc>.value(
      value: sl<WishlistBloc>()..add(const WishlistFetchEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
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
                    vertical: 24.0,
                  ),
                  child: Row(
                    children: [
                      AppText.light(
                        'Wishlist',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, state) {
                  if (state is WishlistLoading || state is WishlistInitial) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is WishlistError) {
                    // Show blank when server returns empty/400 like "Missing product ID"
                    return const SliverToBoxAdapter(
                      child: Center(child: Text('No wishlist items')),
                    );
                  }
                  if (state is WishlistLoaded) {
                    if (state.items.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(child: Text('No wishlist items')),
                      );
                    }
                    return _buildWishlistGrid(context, state.items);
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
