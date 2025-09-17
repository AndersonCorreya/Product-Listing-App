import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_listing_app/features/home/data/repositories/user_repository.dart';
import 'package:product_listing_app/features/home/domain/usecases/get_user_data_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserDataUseCase getUserDataUseCase;
  ProfileBloc({required this.getUserDataUseCase})
    : super(const ProfileInitial()) {
    on<ProfileRequested>((event, emit) async {
      emit(const ProfileLoading());
      try {
        final profile = await getUserDataUseCase();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
