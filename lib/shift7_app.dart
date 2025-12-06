import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shift7_app/features/app/presentation/cubit/app_cubit.dart';
import 'package:shift7_app/features/app/presentation/cubit/app_state.dart';
import 'package:shift7_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shift7_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:shift7_app/features/favorite/presentation/cubit/fav_cubit.dart';
import 'package:shift7_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';

class Shift7App extends StatelessWidget {
  const Shift7App({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortestSide = constraints.biggest.shortestSide;
        final bool isTablet = shortestSide >= 600;
        const mobileDesign = Size(375, 850);
        const tabletDesign = Size(600, 1025);

        return ScreenUtilInit(
          designSize: isTablet ? tabletDesign : mobileDesign,
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          builder: (_, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => getIt<AppCubit>()),
                BlocProvider(create: (context) => getIt<HomeCubit>()),
                BlocProvider(create: (context) => getIt<IntroCubit>()),
                BlocProvider(create: (context) => getIt<CategoriesCubit>()),
                BlocProvider(create: (context) => getIt<FavCubit>()),
                BlocProvider(create: (context) => getIt<CartCubit>()),
                BlocProvider(create: (context) => getIt<ProfileCubit>()),
              ],
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    initialRoute: AppRoutesKeys.initial,
                    onGenerateRoute: AppRoutes.generateRoute,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    builder: (context, widget) {
                      if (widget == null) return const SizedBox.shrink();
                      final mq = MediaQuery.of(context);
                      final textScale =
                          isTablet
                              ? const TextScaler.linear(0.9)
                              : const TextScaler.linear(1.0);
                      return MediaQuery(
                        data: mq.copyWith(textScaler: textScale),
                        child: widget,
                        // child: ConnectivityWrapper(child: widget),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
