import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/wishlist_bloc.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final double originalPrice;
  final double discountedPrice;
  final double rating;
  final String productName;
  final Color? heartIconColor;
  final int? productId;
  final bool initiallyFavorite;
  final Map<String, dynamic>? fullProduct;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.rating,
    required this.productName,
    this.heartIconColor,
    this.productId,
    this.initiallyFavorite = false,
    this.fullProduct,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initiallyFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2; // Account for padding and spacing
    final cardHeight = cardWidth * 1.42; // Maintain aspect ratio
    final imageHeight = cardHeight * 0.76; // Image takes 76% of card height

    return BlocListener<WishlistBloc, WishlistState>(
      listenWhen: (previous, current) => current is WishlistLoaded,
      listener: (context, state) {
        if (state is WishlistLoaded && widget.productId != null) {
          final bool inWishlist = state.items.any(
            (p) => p['id'] == widget.productId,
          );
          if (inWishlist != _isFavorite) {
            setState(() {
              _isFavorite = inWishlist;
            });
          }
        }
      },
      child: Container(
        height: cardHeight,
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              height: imageHeight,
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Colors.grey[50],
              ),
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      widget.imageUrl,
                      height: imageHeight,
                      width: cardWidth,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: imageHeight,
                          width: cardWidth,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  // Heart Icon
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.productId != null) {
                          context.read<WishlistBloc>().add(
                            WishlistToggleEvent(
                              widget.productId!,
                              !_isFavorite,
                              product: widget.fullProduct,
                            ),
                          );
                        }
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOutBack,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: SvgPicture.asset(
                          _isFavorite
                              ? 'assets/icons/filled_heart.svg'
                              : 'assets/icons/empty_heart.svg',
                          key: ValueKey<bool>(_isFavorite),
                          height: 24,
                          width: 24,
                          colorFilter: widget.heartIconColor != null
                              ? ColorFilter.mode(
                                  widget.heartIconColor!,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price Row
                    Row(
                      children: [
                        AppText.heading(
                          '₹${widget.originalPrice.toInt()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppText.heading(
                          '₹${widget.discountedPrice.toInt()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                        const Spacer(),
                        // Rating
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/star.svg',
                              height: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              widget.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Product Name
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
