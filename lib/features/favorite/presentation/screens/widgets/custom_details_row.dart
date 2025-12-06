import 'package:flutter/material.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomDetailsRow extends StatelessWidget {
  final String category;
  const CustomDetailsRow({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Text(category, style: AppTextStyle.styleBlack14W500);
  }
}
