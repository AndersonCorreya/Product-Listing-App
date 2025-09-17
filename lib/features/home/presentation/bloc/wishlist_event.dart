part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class WishlistFetchEvent extends WishlistEvent {
  const WishlistFetchEvent();
}

class WishlistToggleEvent extends WishlistEvent {
  final int productId;
  final bool isFavoriteAfterToggle;
  final Map<String, dynamic>? product;
  const WishlistToggleEvent(
    this.productId,
    this.isFavoriteAfterToggle, {
    this.product,
  });

  @override
  List<Object?> get props => [productId, isFavoriteAfterToggle, product];
}
