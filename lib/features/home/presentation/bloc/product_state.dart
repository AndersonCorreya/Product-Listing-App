part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> popularProducts;
  final List<Map<String, dynamic>> latestProducts;

  const ProductLoaded({
    required this.products,
    required this.popularProducts,
    required this.latestProducts,
  });

  @override
  List<Object?> get props => [products, popularProducts, latestProducts];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}
