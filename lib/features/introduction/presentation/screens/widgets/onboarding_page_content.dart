import 'package:flutter/material.dart';
import 'package:shift7_app/features/introduction/data/model/on_boarding_model.dart';
import 'package:shift7_app/features/introduction/presentation/screens/widgets/custom_on_boarding_bottom_content_widget.dart';

class OnBoardingPageContent extends StatelessWidget {
  final OnBoardingModel model;
  final bool isLastPage;
  final VoidCallback onNextPressed;
  final VoidCallback onGetStartedPressed;

  const OnBoardingPageContent({
    super.key,
    required this.model,
    required this.isLastPage,
    required this.onNextPressed,
    required this.onGetStartedPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(model.image, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomOnBoardingBottomContentwidget(
            model: model,
            isLastPage: isLastPage,
            onNextPressed: onNextPressed,
            onGetStartedPressed: onGetStartedPressed,
          ),
        ),
      ],
    );
  }
}
