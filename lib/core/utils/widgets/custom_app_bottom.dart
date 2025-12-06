import 'package:flutter/material.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomAppBottom extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double horizontalPadding;
  final double verticalPadding;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool? hasBorder;

  const CustomAppBottom({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.horizontalPadding = 16.0,
    this.verticalPadding = 8.0,
    this.height,
    this.width,
    this.borderRadius,
    this.onTap,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.zero,
        border:
            hasBorder == true
                ? Border.all(color: AppColors.blackColor, width: 1)
                : Border.all(color: Colors.transparent, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Center(child: child),
      ),
    );
  }
}
