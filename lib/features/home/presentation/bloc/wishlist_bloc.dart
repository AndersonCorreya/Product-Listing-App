import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_listing_app/features/home/data/repositories/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository repository;

  WishlistBloc({required this.repository}) : super(const WishlistInitial()) {
    on<WishlistFetchEvent>((event, emit) async {
      emit(const WishlistLoading());
      try {
        final items = await repository.fetchWishlist();
        emit(WishlistLoaded(items));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });

    on<WishlistToggleEvent>((event, emit) async {
      // Start from current list or empty
      List<Map<String, dynamic>> current = state is WishlistLoaded
          ? List<Map<String, dynamic>>.from((state as WishlistLoaded).items)
          : <Map<String, dynamic>>[];

      // Optimistic update
      final int idx = current.indexWhere((p) => p['id'] == event.productId);
      List<Map<String, dynamic>> before = List<Map<String, dynamic>>.from(
        current,
      );
      if (event.isFavoriteAfterToggle) {
        if (idx == -1 && event.product != null) {
          current.insert(0, Map<String, dynamic>.from(event.product!));
        }
      } else {
        if (idx != -1) {
          current.removeAt(idx);
        }
      }
      emit(WishlistLoaded(current));

      // Call API; if it fails, revert optimistic change
      try {
        await repository.toggleWishlist(event.productId);
      } catch (e) {
        emit(WishlistLoaded(before));
        return;
      }

      // Try to reconcile from server; if it errors, keep optimistic state
      try {
        final items = await repository.fetchWishlist();
        emit(WishlistLoaded(items));
      } catch (_) {
        // ignore: keep optimistic state
      }
    });
  }
}
