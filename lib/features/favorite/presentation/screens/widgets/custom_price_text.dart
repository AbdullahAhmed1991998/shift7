import 'package:flutter/material.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomPriceText extends StatelessWidget {
  final String price;
  const CustomPriceText({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(price, style: AppTextStyle.stylePrimary16Bold);
  }
}
