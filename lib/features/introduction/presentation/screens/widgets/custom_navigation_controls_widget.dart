import 'package:flutter/material.dart';
import 'package:shift7_app/features/introduction/presentation/screens/widgets/custom_dots_indicator_widget.dart';
import 'package:shift7_app/features/introduction/presentation/screens/widgets/custom_get_started_button_widget.dart';
import 'package:shift7_app/features/introduction/presentation/screens/widgets/custom_next_button_widget.dart';

class CustomNavigationControlsWidget extends StatelessWidget {
  final bool isLastPage;
  final int totalPages;
  final int currentPage;
  final VoidCallback onNextPressed;
  final VoidCallback onGetStartedPressed;

  const CustomNavigationControlsWidget({
    super.key,
    required this.isLastPage,
    required this.totalPages,
    required this.currentPage,
    required this.onNextPressed,
    required this.onGetStartedPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isLastPage)
          CustomDotsIndicatorWidget(
            totalPages: totalPages,
            currentPage: currentPage,
          ),
        if (!isLastPage) CustomNextButtonWidget(onPressed: onNextPressed),
        if (isLastPage)
          CustomGetStartedButtonWidget(onPressed: onGetStartedPressed),
      ],
    );
  }
}
