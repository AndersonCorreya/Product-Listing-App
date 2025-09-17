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
import 'package:product_listing_app/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:product_listing_app/features/auth/domain/usecases/delete_token_usecase.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_listing_app/features/home/data/repositories/search_repository.dart';
import 'package:product_listing_app/features/home/presentation/bloc/search_bloc.dart';
import 'package:product_listing_app/features/home/data/repositories/wishlist_repository.dart';
import 'package:product_listing_app/features/home/presentation/bloc/wishlist_bloc.dart';
import 'package:product_listing_app/features/home/data/datasources/user_remote_datasource.dart';
import 'package:product_listing_app/features/home/data/repositories/user_repository.dart';
import 'package:product_listing_app/features/home/domain/usecases/get_user_data_usecase.dart';
import 'package:product_listing_app/features/home/presentation/bloc/profile_bloc.dart';
import 'package:product_listing_app/features/home/data/datasources/banner_remote_datasource.dart';
import 'package:product_listing_app/features/home/data/repositories/banner_repository_impl.dart';
import 'package:product_listing_app/features/home/domain/repositories/banner_repository.dart';
import 'package:product_listing_app/features/home/domain/usecases/get_banners_usecase.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/product_bloc.dart';
import 'package:product_listing_app/features/home/domain/repositories/product_repository.dart';
import 'package:product_listing_app/features/home/data/repositories/product_repository_impl.dart';
import 'package:product_listing_app/features/home/data/datasources/product_remote_datasource.dart';
import 'package:product_listing_app/features/home/data/datasources/product_remote_datasource_impl.dart';
import 'package:product_listing_app/features/home/domain/usecases/get_products_usecase.dart';
import 'package:http/http.dart' as http;

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
      getTokenUseCase: sl(),
      deleteTokenUseCase: sl(),
    ),
  );
  sl.registerFactory(() => SearchBloc(repository: sl()));
  sl.registerLazySingleton(() => WishlistBloc(repository: sl()));
  sl.registerFactory(() => ProfileBloc(getUserDataUseCase: sl()));
  sl.registerFactory(() => BannerBloc(getBannersUseCase: sl()));
  sl.registerFactory(() => ProductBloc(getProductsUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginRegisterUseCase(sl()));
  sl.registerLazySingleton(() => SaveTokenUseCase(sl()));
  sl.registerLazySingleton(() => GetTokenUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTokenUseCase(sl()));
  sl.registerLazySingleton(() => GetBannersUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<SearchRepository>(() => SearchRepository());
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepository(authLocalDataSource: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(authLocalDataSource: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetUserDataUseCase(sl()));
  sl.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(prefs: sl()),
  );
  sl.registerLazySingleton<BannerRemoteDataSource>(
    () => BannerRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Shared Preferences
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
