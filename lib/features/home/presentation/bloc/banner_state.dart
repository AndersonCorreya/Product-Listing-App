import 'package:equatable/equatable.dart';
import 'package:product_listing_app/features/home/domain/entities/banner_entity.dart';

abstract class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object> get props => [];
}

class BannerInitial extends BannerState {
  const BannerInitial();
}

class BannerLoading extends BannerState {
  const BannerLoading();
}

class BannerLoaded extends BannerState {
  final List<BannerEntity> banners;

  const BannerLoaded({required this.banners});

  @override
  List<Object> get props => [banners];
}

class BannerError extends BannerState {
  final String message;

  const BannerError({required this.message});

  @override
  List<Object> get props => [message];
}
