import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomSearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final Function(String) onSubmitted;

  const CustomSearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.onSubmitted,
  });

  @override
  State<CustomSearchBarWidget> createState() => _CustomSearchBarWidgetState();
}

class _CustomSearchBarWidgetState extends State<CustomSearchBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            height: 50.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryColor,
                      size: 25.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    cursorColor: AppColors.secondaryColor,
                    decoration: InputDecoration(
                      hintText: 'search_here'.tr(),
                      hintStyle: AppTextStyle.styleBlack14W500.copyWith(
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 15.h,
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: widget.onSubmitted,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.controller.text.isNotEmpty ? 40.w : 0,
                  child:
                      widget.controller.text.isNotEmpty
                          ? IconButton(
                            onPressed: widget.onClear,
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.red[600],
                              size: 16.w,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            splashRadius: 15,
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
