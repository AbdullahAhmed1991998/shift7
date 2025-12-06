import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shift7_app/core/network/api_status.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/custom_app_bottom.dart';
import 'package:shift7_app/features/introduction/data/model/app_version_model.dart';
import 'package:shift7_app/features/introduction/presentation/cubit/intro_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _start();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: const Offset(1, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.8)),
    );
  }

  Future<void> _start() async {
    final introCubit = context.read<IntroCubit>();
    await Future.wait([_controller.forward(), _initializeApp(introCubit)]);
    await _handleVersionAndNavigate();
  }

  Future<void> _initializeApp(IntroCubit cubit) async {
    await Future.wait([cubit.getAppVersion(), cubit.getAllStores()]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleVersionAndNavigate() async {
    final state = context.read<IntroCubit>().state;
    final appVersionData = state.appVersion?.data;

    if (state.appVersionStatus == ApiStatus.success && appVersionData != null) {
      final currentVersion = await _getCurrentVersion();
      final minSupportedVersion = appVersionData.minSupportedVersion;
      final latestVersion = appVersionData.latestVersion;

      final isBelowMin = _isVersionLower(currentVersion, minSupportedVersion);
      final isBelowLatest = _isVersionLower(currentVersion, latestVersion);

      if (isBelowMin || isBelowLatest) {
        await _showUpdateDialog(appVersionData, isForce: isBelowMin);
        if (isBelowMin) {
          return;
        }
      }
    }

    navigation();
  }

  Future<String> _getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  bool _isVersionLower(String current, String minRequired) {
    final currentParts = _parseVersion(current);
    final minParts = _parseVersion(minRequired);

    for (var i = 0; i < currentParts.length; i++) {
      if (currentParts[i] < minParts[i]) {
        return true;
      } else if (currentParts[i] > minParts[i]) {
        return false;
      }
    }
    return false;
  }

  List<int> _parseVersion(String value) {
    final parts = value.split('.');
    final result = <int>[];

    for (var part in parts) {
      result.add(int.tryParse(part) ?? 0);
    }

    while (result.length < 3) {
      result.add(0);
    }

    return result.sublist(0, 3);
  }

  Future<void> _showUpdateDialog(
    AppVersionDataModel data, {
    required bool isForce,
  }) async {
    final url = Platform.isAndroid ? data.storeUrlAndroid : data.storeUrlIos;
    final uri = Uri.parse(url);

    await showDialog<void>(
      context: context,
      barrierDismissible: !isForce,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64.r,
                  width: 64.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withAlpha(179),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.system_update_alt_rounded,
                    color: AppColors.whiteColor,
                    size: 32.r,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "newVersionAvailable".tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.styleBlack16Bold,
                ),
                SizedBox(height: 8.h),
                Text(
                  "pleaseUpdate".tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.styleBlack12W400,
                ),
                SizedBox(height: 24.h),
                if (isForce)
                  CustomAppBottom(
                    onTap: () async {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                    height: 50.h,
                    horizontalPadding: 20.w,
                    verticalPadding: 5.h,
                    width: double.infinity,
                    child: Text(
                      "updateNow".tr(),
                      style: AppTextStyle.styleBlack14W500.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: CustomAppBottom(
                          onTap: () {
                            Navigator.of(context).pop();
                            navigation();
                          },
                          backgroundColor: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                          height: 46.h,
                          horizontalPadding: 12.w,
                          verticalPadding: 4.h,
                          width: double.infinity,
                          child: Text(
                            "remindMeLater".tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyle.styleBlack14W500.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomAppBottom(
                          onTap: () async {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          backgroundColor: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                          height: 46.h,
                          horizontalPadding: 12.w,
                          verticalPadding: 4.h,
                          width: double.infinity,
                          child: Text(
                            "updateNow".tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyle.styleBlack14W500.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void navigation() {
    final isLogin =
        getIt<CacheHelper>().getData(key: CacheHelperKeys.isLogin) ?? false;
    final isFirstTime =
        getIt<CacheHelper>().getData(key: CacheHelperKeys.isFirstTime) ?? true;

    if (isLogin == true) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutesKeys.shift7MainApp,
        arguments: {
          'storeId': getIt<CacheHelper>().getData(
            key: CacheHelperKeys.mainStoreId,
          ),
        },
      );
    } else {
      if (isFirstTime == true) {
        Navigator.pushReplacementNamed(context, AppRoutesKeys.onBoarding);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutesKeys.auth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = AppIcons.secondAppLogo;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: Center(
              child: LoadingAnimationWidget.inkDrop(
                color: AppColors.whiteColor,
                size: 30.sp,
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (_controller.value <= 0.4) {
                  return Transform.translate(
                    offset: _slideAnimation.value,
                    child: SvgPicture.asset(icon, width: 100.w),
                  );
                } else {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: SvgPicture.asset(icon, width: 100.w),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
