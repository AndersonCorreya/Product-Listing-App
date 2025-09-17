import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final int showingOrder;

  const BannerEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.showingOrder,
  });

  @override
  List<Object> get props => [id, name, image, showingOrder];
}
