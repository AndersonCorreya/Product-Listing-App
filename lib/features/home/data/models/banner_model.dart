import 'package:product_listing_app/features/home/domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.name,
    required super.image,
    required super.showingOrder,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      showingOrder: json['showing_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'showing_order': showingOrder,
    };
  }
}
