import 'package:product_listing_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.phoneNumber,
    required super.countryCode,
    super.name,
    super.email,
    super.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      countryCode: json['country_code'] ?? '',
      name: json['name'],
      email: json['email'],
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'country_code': countryCode,
      'name': name,
      'email': email,
      'is_verified': isVerified,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      phoneNumber: user.phoneNumber,
      countryCode: user.countryCode,
      name: user.name,
      email: user.email,
      isVerified: user.isVerified,
    );
  }
}
