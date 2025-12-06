import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shift7_app/core/network/api_service.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/features/app/presentation/cubit/app_cubit.dart';
import 'package:shift7_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:shift7_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shift7_app/features/cart/data/repos/cart_repo_impl.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shift7_app/features/categories/data/repos/categories_repo_impl.dart';
import 'package:shift7_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:shift7_app/features/favorite/data/repos/fav_repo_impl.dart';
import 'package:shift7_app/features/favorite/presentation/cubit/fav_cubit.dart';
import 'package:shift7_app/features/home/data/repos/home_repo_impl.dart';
import 'package:shift7_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shift7_app/features/introduction/data/repos/intro_repo_impl.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';
import 'package:shift7_app/features/profile/data/repos/profile_repo_impl.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';

final getIt = GetIt.instance;

void serviceLocatorSetup() {
  initServiceLocator();
  introductionServiceLocator();
  authServiceLocator();
  categoriesServiceLocator();
  homeServiceLocator();
  favServiceLocator();
  cartServiceLocator();
  profileServiceLocator();
}

void initServiceLocator() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<CacheHelper>(CacheHelper()..cacheInit());
  getIt.registerSingleton<ApiService>(ApiService());
  getIt.registerSingleton<AppCubit>(AppCubit());
}

void introductionServiceLocator() {
  // * Intro repo
  getIt.registerSingleton<IntroRepoImpl>(
    IntroRepoImpl(apiService: getIt<ApiService>()),
  );

  // * cubit
  getIt.registerSingleton<IntroCubit>(
    IntroCubit(introRepo: getIt<IntroRepoImpl>()),
  );
}

void authServiceLocator() {
  // * GoogleSignIn instance
  getIt.registerSingleton<GoogleSignIn>(GoogleSignIn.instance);

  // * Auth repo
  getIt.registerSingleton<AuthRepoImpl>(
    AuthRepoImpl(
      apiService: getIt<ApiService>(),
      googleSignIn: getIt<GoogleSignIn>(),
    ),
  );

  // * cubit
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(authRepo: getIt<AuthRepoImpl>()),
  );
}

void categoriesServiceLocator() {
  getIt.registerSingleton<CategoriesRepoImpl>(
    CategoriesRepoImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(repository: getIt<CategoriesRepoImpl>()),
  );
}

void homeServiceLocator() {
  // * Home repo
  getIt.registerSingleton<HomeRepoImpl>(
    HomeRepoImpl(apiService: getIt<ApiService>()),
  );

  // * cubit
  getIt.registerSingleton<HomeCubit>(
    HomeCubit(homeRepo: getIt<HomeRepoImpl>()),
  );
}

void favServiceLocator() {
  // * Fav repo
  getIt.registerSingleton<FavRepoImpl>(
    FavRepoImpl(apiService: getIt<ApiService>()),
  );

  // * cubit
  getIt.registerSingleton<FavCubit>(FavCubit(repository: getIt<FavRepoImpl>()));
}

void cartServiceLocator() {
  // * Cart repo
  getIt.registerSingleton<CartRepoImpl>(
    CartRepoImpl(apiService: getIt<ApiService>()),
  );

  // * cubit
  getIt.registerSingleton<CartCubit>(
    CartCubit(repository: getIt<CartRepoImpl>()),
  );
}

void profileServiceLocator() {
  // * Profile repo
  getIt.registerSingleton<ProfileRepoImpl>(
    ProfileRepoImpl(apiService: getIt<ApiService>()),
  );

  // * cubit
  getIt.registerSingleton<ProfileCubit>(
    ProfileCubit(repository: getIt<ProfileRepoImpl>()),
  );
}
