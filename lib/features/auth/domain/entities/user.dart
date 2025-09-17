import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final String countryCode;
  final String? name;
  final String? email;
  final bool isVerified;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.countryCode,
    this.name,
    this.email,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [
    id,
    phoneNumber,
    countryCode,
    name,
    email,
    isVerified,
  ];

  User copyWith({
    String? id,
    String? phoneNumber,
    String? countryCode,
    String? name,
    String? email,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      name: name ?? this.name,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
