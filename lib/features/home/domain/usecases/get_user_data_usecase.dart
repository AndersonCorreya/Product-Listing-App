import 'package:product_listing_app/features/home/data/repositories/user_repository.dart';

class GetUserDataUseCase {
  final UserRepository repository;
  const GetUserDataUseCase(this.repository);

  Future<UserProfile> call() {
    return repository.getUserProfile();
  }
}
