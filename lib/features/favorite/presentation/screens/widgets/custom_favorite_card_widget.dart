import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/features/favorite/data/models/get_favourite_model.dart';
import 'package:shift7_app/features/favorite/presentation/screens/widgets/custom_card_content.dart';
import 'package:shift7_app/features/favorite/presentation/screens/widgets/custom_image_container.dart';

class CustomFavoriteCardWidget extends StatefulWidget {
  final WishlistItemModel product;
  final VoidCallback onDelete;

  const CustomFavoriteCardWidget({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  State<CustomFavoriteCardWidget> createState() =>
      _CustomFavoriteCardWidgetState();
}

class _CustomFavoriteCardWidgetState extends State<CustomFavoriteCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        widget.product.media.isNotEmpty ? widget.product.media.first.url : '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      padding: EdgeInsets.all(2.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha(30),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Row(
          children: [
            CustomImageContainer(imageUrl: imageUrl),
            SizedBox(width: 5.w),
            Expanded(
              child: CustomCardContent(
                product: widget.product,
                isFavorite: true,
                scaleAnimation: _scaleAnimation,
                onToggleFavorite: widget.onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
