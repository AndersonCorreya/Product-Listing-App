import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/core/di/injection_container.dart';
import 'package:product_listing_app/features/home/presentation/bloc/search_bloc.dart';
import 'package:product_listing_app/features/home/presentation/widgets/product_card.dart';
import 'package:product_listing_app/features/home/presentation/widgets/search_field.dart';
import 'package:product_listing_app/features/home/presentation/bloc/wishlist_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(create: (_) => sl<SearchBloc>()),
        BlocProvider<WishlistBloc>.value(value: sl<WishlistBloc>()),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CustomSearchField(
                hintText: 'Search products',
                onChanged: (value) {
                  context.read<SearchBloc>().add(SearchQueryChanged(value));
                },
                onSubmitted: (value) {
                  context.read<SearchBloc>().add(SearchSubmitted(value));
                },
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitialState) {
                  return const Center(child: Text('Search for products'));
                }
                if (state is SearchLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SearchErrorState) {
                  return Center(child: Text(state.message));
                }
                if (state is SearchLoadedState) {
                  final products = state.results;
                  if (products.isEmpty) {
                    return const Center(child: Text('No results'));
                  }

                  final screenWidth = MediaQuery.of(context).size.width;
                  final crossAxisCount = screenWidth > 600 ? 3 : 2;
                  const spacing = 16.0;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final String imageUrl =
                            (product['featured_image'] ??
                                    (product['images'] is List &&
                                            (product['images'] as List)
                                                .isNotEmpty
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
                          initiallyFavorite: product['in_wishlist'] == true,
                          heartIconColor: const Color(0xFF6366F1),
                          fullProduct: product,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
