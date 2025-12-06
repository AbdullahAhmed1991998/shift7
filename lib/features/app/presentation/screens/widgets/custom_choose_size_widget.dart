import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomChooseSizeWidget extends StatefulWidget {
  final List<String> sizes;
  final String? initialSelected;
  final ValueChanged<String>? onSizeSelected;

  const CustomChooseSizeWidget({
    super.key,
    required this.sizes,
    this.initialSelected,
    this.onSizeSelected,
  });

  @override
  State<CustomChooseSizeWidget> createState() => _CustomChooseSizeWidgetState();
}

class _CustomChooseSizeWidgetState extends State<CustomChooseSizeWidget> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelected != null) {
      final idx = widget.sizes.indexWhere(
        (s) => s.toLowerCase() == widget.initialSelected!.toLowerCase(),
      );
      if (idx >= 0) _selectedIndex = idx;
    } else if (widget.sizes.isNotEmpty) {
      _selectedIndex = 0;
    }
  }

  @override
  void didUpdateWidget(covariant CustomChooseSizeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final sizesChanged = !listEquals(widget.sizes, oldWidget.sizes);
    if (sizesChanged) {
      if (widget.initialSelected != null) {
        final idx = widget.sizes.indexWhere(
          (s) => s.toLowerCase() == widget.initialSelected!.toLowerCase(),
        );
        setState(
          () =>
              _selectedIndex =
                  idx >= 0 ? idx : (widget.sizes.isNotEmpty ? 0 : null),
        );
      } else {
        setState(() => _selectedIndex = widget.sizes.isNotEmpty ? 0 : null);
      }
      return;
    }

    if (widget.initialSelected != oldWidget.initialSelected &&
        widget.initialSelected != null) {
      final idx = widget.sizes.indexWhere(
        (s) => s.toLowerCase() == widget.initialSelected!.toLowerCase(),
      );
      if (idx >= 0 && idx != _selectedIndex) {
        setState(() => _selectedIndex = idx);
      }
    }
  }

  void _select(int index) {
    setState(() => _selectedIndex = index);
    widget.onSizeSelected?.call(widget.sizes[index]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sizes.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('sizes'.tr(), style: AppTextStyle.styleBlack16Bold),
          SizedBox(height: 8.h),
          SizedBox(
            height: 44.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.sizes.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => _select(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1,
                      ),
                      color:
                          isSelected
                              ? AppColors.primaryColor.withAlpha(20)
                              : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        widget.sizes[index],
                        style: AppTextStyle.styleBlack14W500.copyWith(
                          color:
                              isSelected
                                  ? AppColors.primaryColor
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
