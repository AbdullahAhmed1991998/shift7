import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/enums/search_tab.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomTabSelectorWidget extends StatefulWidget {
  final SearchTab selectedTab;
  final Function(SearchTab) onTabChanged;

  const CustomTabSelectorWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  State<CustomTabSelectorWidget> createState() =>
      _CustomTabSelectorWidgetState();
}

class _CustomTabSelectorWidgetState extends State<CustomTabSelectorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      height: 50.h,
      child: Row(
        children: [
          _buildTabItem(SearchTab.categories, 'categories'.tr()),
          SizedBox(width: 8.w),
          _buildTabItem(SearchTab.brands, 'brands'.tr()),
          SizedBox(width: 8.w),
          _buildTabItem(SearchTab.products, 'products'.tr()),
        ],
      ),
    );
  }

  Widget _buildTabItem(SearchTab tab, String title) {
    final isSelected = widget.selectedTab == tab;
    return Expanded(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: () {
                widget.onTabChanged(tab);
                _animationController
                  ..reset()
                  ..forward();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                decoration: BoxDecoration(
                  gradient:
                      isSelected
                          ? const LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : LinearGradient(
                            colors: [Colors.white, Colors.grey[50]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.primaryColor.withAlpha(30)
                            : Colors.grey[300]!,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isSelected
                              ? AppColors.primaryColor.withAlpha(30)
                              : Colors.black.withAlpha(5),
                      blurRadius: isSelected ? 12 : 6,
                      offset: Offset(0, isSelected ? 4 : 2),
                      spreadRadius: isSelected ? 1 : 0,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontSize: isSelected ? 14.sp : 13.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.5,
                    fontFamily: 'Cairo',
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
