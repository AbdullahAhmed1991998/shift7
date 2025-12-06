import 'package:flutter/material.dart';
import 'package:shift7_app/core/services/cache_helper_keys.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/routing/app_routes_keys.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/features/introduction/data/model/on_boarding_model.dart';
import 'package:shift7_app/features/introduction/presentation/screens/widgets/custom_skip_button_widget.dart';
import 'package:shift7_app/features/introduction/presentation/screens/widgets/onboarding_page_content.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _handleGetStarted() {
    getIt<CacheHelper>()
        .setData(key: CacheHelperKeys.isFirstTime, value: false)
        .then((value) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, AppRoutesKeys.auth);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: OnBoardingModel.onBoardingData.length,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnBoardingPageContent(
                model: OnBoardingModel.onBoardingData[index],
                isLastPage: index == OnBoardingModel.onBoardingData.length - 1,
                onNextPressed: _handleNextPage,
                onGetStartedPressed: _handleGetStarted,
              );
            },
          ),
          currentPage == OnBoardingModel.onBoardingData.length - 1
              ? const SizedBox()
              : CustomSkipButtonWidget(
                onPressed: () {
                  _pageController.jumpToPage(
                    OnBoardingModel.onBoardingData.length - 1,
                  );
                },
              ),
        ],
      ),
    );
  }
}
