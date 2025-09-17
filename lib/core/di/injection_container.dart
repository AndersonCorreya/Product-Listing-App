import 'package:get_it/get_it.dart';
import 'package:product_listing_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:product_listing_app/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:product_listing_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:product_listing_app/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:product_listing_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:product_listing_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:product_listing_app/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/verify_user_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/login_register_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/save_token_usecase.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_listing_app/features/home/data/repositories/search_repository.dart';
import 'package:product_listing_app/features/home/presentation/bloc/search_bloc.dart';
import 'package:product_listing_app/features/home/data/repositories/wishlist_repository.dart';
import 'package:product_listing_app/features/home/presentation/bloc/wishlist_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Third-party async singletons
  final sharedPreferences = await SharedPreferences.getInstance();
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      resendOtpUseCase: sl(),
      verifyUserUseCase: sl(),
      loginRegisterUseCase: sl(),
      saveTokenUseCase: sl(),
    ),
  );
  sl.registerFactory(() => SearchBloc(repository: sl()));
  sl.registerLazySingleton(() => WishlistBloc(repository: sl()));

  // Use cases
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginRegisterUseCase(sl()));
  sl.registerLazySingleton(() => SaveTokenUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<SearchRepository>(() => SearchRepository());
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepository(authLocalDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(prefs: sl()),
  );

  // Shared Preferences
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
