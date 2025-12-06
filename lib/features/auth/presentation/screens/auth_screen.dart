import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/assets/app_icons.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_send_code_forget_password_screen.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_create_new_password_screen.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_forget_password_screen.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_login_screen.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_sign_up_screen.dart';
import 'package:shift7_app/features/auth/presentation/screens/widgets/custom_verify_code_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String verifyEmail = '';
  String verifyPhone = '';
  String forgetPassEmail = '';
  String forgetPassPhone = '';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToVerifyEmail(String email) {
    setState(() => verifyEmail = email);
  }

  void _navigateToVerifyPhone(String phone) {
    setState(() => verifyPhone = phone);
  }

  void _navigateToChangePassWithEmail(String email) {
    setState(() => forgetPassEmail = email);
  }

  void _navigateToChangePassWithPhone(String phone) {
    setState(() => forgetPassPhone = phone);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isArabic = getIt<CacheHelper>().getData(key: 'language') == 'ar';
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              if ([3, 4].contains(_currentPage))
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => _pageController.jumpTo(0),
                    child: RotatedBox(
                      quarterTurns: isArabic ? 2 : 4,
                      child: Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                  ),
                ),
              if (_currentPage == 0 || _currentPage == 1)
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      getIt<CacheHelper>()
                          .setData(key: CacheHelperKeys.isLogin, value: false)
                          .then((_) {
                            Navigator.pushReplacementNamed(
                              // ignore: use_build_context_synchronously
                              context,
                              AppRoutesKeys.shift7MainApp,
                              arguments: {
                                "storeId": getIt<CacheHelper>().getData(
                                  key: CacheHelperKeys.mainStoreId,
                                ),
                              },
                            );
                          });
                    },
                    child: Text(
                      'skip'.tr(),
                      style: AppTextStyle.styleBlack18Bold.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height:
                    (_currentPage == 0 || _currentPage == 1)
                        ? screenHeight * 0.1
                        : screenHeight * 0.15,
              ),
              Center(
                child: SvgPicture.asset(
                  AppIcons.appIcon,
                  width: 70.w,
                  height: 70.h,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged:
                      (index) => setState(() => _currentPage = index),
                  children: [
                    CustomLoginScreen(
                      pageController: _pageController,
                      onNavigateToVerifyEmail: _navigateToVerifyEmail,
                      onNavigateToVerifyPhone: _navigateToVerifyPhone,
                    ),
                    CustomSignUpScreen(
                      pageController: _pageController,
                      onNavigateToVerifyEmail: _navigateToVerifyEmail,
                      onNavigateToVerifyPhone: _navigateToVerifyPhone,
                    ),
                    CustomVerifyCodeScreen(
                      pageController: _pageController,
                      verifyEmail: verifyEmail,
                      verifyPhone: verifyPhone,
                    ),
                    CustomForgetPasswordScreen(
                      pageController: _pageController,
                      onNavigateToForgetPassEmail:
                          _navigateToChangePassWithEmail,
                      onNavigateToForgetPassPhone:
                          _navigateToChangePassWithPhone,
                    ),
                    CustomSendCodeForgetPassScreen(
                      pageController: _pageController,
                      email: forgetPassEmail,
                      phone: forgetPassPhone,
                    ),
                    CustomCreateNewPasswordScreen(
                      pageController: _pageController,
                      email: forgetPassEmail,
                      phone: forgetPassPhone,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
