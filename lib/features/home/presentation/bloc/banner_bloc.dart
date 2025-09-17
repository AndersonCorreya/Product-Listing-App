import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/core/usecases/usecase.dart';
import 'package:product_listing_app/features/home/domain/usecases/get_banners_usecase.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_event.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final GetBannersUseCase getBannersUseCase;

  BannerBloc({required this.getBannersUseCase}) : super(const BannerInitial()) {
    on<GetBannersEvent>(_onGetBanners);
  }

  Future<void> _onGetBanners(
    GetBannersEvent event,
    Emitter<BannerState> emit,
  ) async {
    emit(const BannerLoading());

    final result = await getBannersUseCase(const NoParams());

    result.fold(
      (failure) => emit(BannerError(message: failure.message)),
      (banners) => emit(BannerLoaded(banners: banners)),
    );
  }
}
