import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/features/app/data/models/product_reviews_model.dart';
import 'package:shift7_app/features/app/presentation/screens/product_review_screen.dart';
import 'package:shift7_app/features/app/presentation/screens/product_screen.dart';
import 'package:shift7_app/features/app/presentation/screens/search_result_screen.dart';
import 'package:shift7_app/features/app/presentation/screens/shift_7_main_app.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:shift7_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shift7_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:shift7_app/features/cart/presentation/screens/chechout_screen.dart';
import 'package:shift7_app/features/categories/data/model/category_args.dart';
import 'package:shift7_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:shift7_app/features/categories/presentation/screens/category_details_screen.dart';
import 'package:shift7_app/features/home/data/repos/home_repo_impl.dart';
import 'package:shift7_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shift7_app/features/home/presentation/screens/brand_details_screen.dart';
import 'package:shift7_app/features/home/presentation/screens/custom_tabs_details_screen.dart';
import 'package:shift7_app/features/home/presentation/screens/media_links_details_screen.dart';
import 'package:shift7_app/features/introduction/presentation/screens/on_boarding_screen.dart';
import 'package:shift7_app/features/introduction/presentation/screens/splash_screen.dart';
import 'package:shift7_app/features/profile/presentation/screens/add_location_screen.dart';
import 'package:shift7_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:shift7_app/features/profile/presentation/screens/help_center_screen.dart';
import 'package:shift7_app/features/profile/presentation/screens/my_orders_screen.dart';
import 'package:shift7_app/features/profile/presentation/screens/notification_screen.dart';
import 'package:shift7_app/features/profile/presentation/screens/privacy_screen.dart';
import 'package:shift7_app/features/profile/presentation/screens/set_location_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesKeys.initial:
        return _buildAnimatedRoute(const SplashScreen(), settings);
      case AppRoutesKeys.shift7MainApp:
        final arguments = settings.arguments as Map<String, dynamic>;
        final storeId = arguments['storeId'] as int;
        return _buildAnimatedRoute(Shift7MainApp(storeId: storeId), settings);
      case AppRoutesKeys.onBoarding:
        return _buildAnimatedRoute(const OnBoardingScreen(), settings);
      case AppRoutesKeys.auth:
        return _buildAnimatedRoute(
          BlocProvider(
            create: (context) => AuthCubit(authRepo: getIt<AuthRepoImpl>()),
            child: const AuthScreen(),
          ),
          settings,
        );
      case AppRoutesKeys.product:
        final arguments = settings.arguments as Map<String, dynamic>;
        final productId = arguments['productId'] as int;
        return _buildAnimatedRoute(
          ProductScreen(productId: productId),
          settings,
        );
      case AppRoutesKeys.editProfile:
        return _buildAnimatedRoute(const EditProfileScreen(), settings);
      case AppRoutesKeys.setLocations:
        return _buildAnimatedRoute(const SetLocationScreen(), settings);
      case AppRoutesKeys.addLocation:
        final arguments = settings.arguments as Map<String, dynamic>;
        final isCart = arguments['isCart'] as bool;
        return _buildAnimatedRoute(AddLocationScreen(isCart: isCart), settings);
      case AppRoutesKeys.notifications:
        return _buildAnimatedRoute(const NotificationScreen(), settings);
      case AppRoutesKeys.privacyPolicy:
        return _buildAnimatedRoute(const PrivacyScreen(), settings);
      case AppRoutesKeys.helpCenter:
        return _buildAnimatedRoute(const HelpCenterScreen(), settings);
      case AppRoutesKeys.checkout:
        final arguments = settings.arguments as Map<String, dynamic>;
        final totalPrice = arguments['totalPrice'] as double;
        return _buildAnimatedRoute(
          CheckoutScreen(totalPrice: totalPrice),
          settings,
        );
      case AppRoutesKeys.categoryDetails:
        {
          int id = 0;
          String name = 'Category';
          int depth = 1;

          final args = settings.arguments;
          if (args is CategoryArgs) {
            id = args.id;
            name = args.name;
            depth = args.depth;
          } else if (args is Map) {
            id = (args['categoryId'] as int?) ?? 0;
            name = (args['categoryName'] as String?) ?? 'Category';
            depth = (args['depth'] as int?) ?? 1;
          }

          return _buildAnimatedRoute(
            BlocProvider<CategoriesCubit>(
              create:
                  (_) =>
                      getIt<CategoriesCubit>()
                        ..getProductsList(categoryId: id, limit: 20, page: 1),
              child: CategoryDetailsScreen(
                categoryId: id,
                categoryName: name,
                depth: depth,
              ),
            ),
            RouteSettings(name: '${AppRoutesKeys.categoryDetails}/$id'),
          );
        }

      case AppRoutesKeys.customTabsDetails:
        final arguments = settings.arguments as Map<String, dynamic>;
        final tabId = arguments['tabId'] as int;
        final tabName = arguments['tabName'] as String;
        return _buildAnimatedRoute(
          BlocProvider(
            create: (context) => HomeCubit(homeRepo: getIt<HomeRepoImpl>()),
            child: CustomTabsDetailsScreen(tabId: tabId, tabName: tabName),
          ),
          settings,
        );
      case AppRoutesKeys.mediaLinksDetails:
        final arguments = settings.arguments as Map<String, dynamic>;
        final mediaId = arguments['mediaId'] as int;
        final mediaName = arguments['mediaName'] as String;
        return _buildAnimatedRoute(
          BlocProvider(
            create: (context) => HomeCubit(homeRepo: getIt<HomeRepoImpl>()),
            child: MediaLinksDetailsScreen(
              mediaId: mediaId,
              mediaName: mediaName,
            ),
          ),
          settings,
        );
      case AppRoutesKeys.brandDetails:
        final arguments = settings.arguments as Map<String, dynamic>;
        final brandId = arguments['brandId'] as int;
        final brandName = arguments['brandName'] as String;
        return _buildAnimatedRoute(
          BlocProvider(
            create: (context) => HomeCubit(homeRepo: getIt<HomeRepoImpl>()),
            child: BrandDetailsScreen(brandId: brandId, brandName: brandName),
          ),
          settings,
        );

      case AppRoutesKeys.productReview:
        final arguments = settings.arguments as Map<String, dynamic>;
        final isReviewPage = arguments['isReviewPage'] as bool;
        final productId = arguments['productId'] as int;
        final reviewsList =
            arguments['reviewsList'] as List<ProductReviewsModel>;
        return _buildAnimatedRoute(
          ProductReviewScreen(
            isReviewPage: isReviewPage,
            reviewsList: reviewsList,
            productId: productId,
          ),
          settings,
        );
      case AppRoutesKeys.searchResult:
        return _buildAnimatedRoute(SearchResultScreen(), settings);
      case AppRoutesKeys.myOrders:
        return _buildAnimatedRoute(MyOrdersScreen(), settings);
      default:
        return _buildAnimatedRoute(
          Shift7MainApp(
            storeId: getIt<CacheHelper>().getData(
              key: CacheHelperKeys.mainStoreId,
            ),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildAnimatedRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
