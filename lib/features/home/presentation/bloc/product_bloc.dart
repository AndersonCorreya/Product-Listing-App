import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/home/domain/usecases/get_products_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc({required this.getProductsUseCase})
    : super(const ProductInitial()) {
    on<GetProductsEvent>(_onGetProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
  }

  Future<void> _onGetProducts(
    GetProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final result = await getProductsUseCase(const NoParams());
      result.fold((failure) => emit(ProductError(message: failure.message)), (
        products,
      ) {
        final popularProducts = _getPopularTop4(products);
        final latestProducts = _getLatestTop4(products);
        emit(
          ProductLoaded(
            products: products,
            popularProducts: popularProducts,
            latestProducts: latestProducts,
          ),
        );
      });
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    add(const GetProductsEvent());
  }

  List<Map<String, dynamic>> _getPopularTop4(
    List<Map<String, dynamic>> products,
  ) {
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

  List<Map<String, dynamic>> _getLatestTop4(
    List<Map<String, dynamic>> products,
  ) {
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
}
