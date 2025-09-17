import 'package:product_listing_app/features/home/data/datasources/user_remote_datasource.dart';

class UserProfile {
  final String name;
  final String phone;
  const UserProfile({required this.name, required this.phone});
}

abstract class UserRepository {
  Future<UserProfile> getUserProfile();
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  const UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getUserProfile() async {
    final data = await remoteDataSource.getUserData();
    final String name =
        (data['name'] ?? data['first_name'] ?? 'Unknown') as String;
    final String phone =
        (data['phone'] ?? data['phone_number'] ?? '...') as String;
    return UserProfile(name: name, phone: phone);
  }
}
