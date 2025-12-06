import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/favorite/presentation/cubit/fav_cubit.dart';

class CustomTitleProductWidget extends StatefulWidget {
  final String title;
  final bool isFav;
  final int productId;

  const CustomTitleProductWidget({
    super.key,
    required this.title,
    required this.isFav,
    required this.productId,
  });

  @override
  State<CustomTitleProductWidget> createState() =>
      _CustomTitleProductWidgetState();
}

class _CustomTitleProductWidgetState extends State<CustomTitleProductWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late bool isWish;

  @override
  void initState() {
    super.initState();
    isWish = widget.isFav;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void toggleWishlist() {
    _controller.forward().then((_) => _controller.reverse());

    setState(() {
      isWish = !isWish;
    });

    BlocProvider.of<FavCubit>(context).setFav(productId: widget.productId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: AppTextStyle.styleBlack20W500.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: GestureDetector(
              onTap: toggleWishlist,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FaIcon(
                  isWish ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                  color: AppColors.secondaryColor,
                  size: 25.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
