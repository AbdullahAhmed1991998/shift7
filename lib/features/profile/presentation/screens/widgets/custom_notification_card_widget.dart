import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/profile/data/models/get_notifications_model.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_leading_badge_widget.dart';
import 'package:shift7_app/features/profile/presentation/cubit/profile_cubit.dart';

class CustomNotificationCardWidget extends StatefulWidget {
  final NotificationItem item;
  const CustomNotificationCardWidget({super.key, required this.item});

  @override
  State<CustomNotificationCardWidget> createState() =>
      _CustomNotificationCardWidgetState();
}

class _CustomNotificationCardWidgetState
    extends State<CustomNotificationCardWidget>
    with TickerProviderStateMixin {
  late bool _seen;
  late final AnimationController _colorCtrl;
  late final AnimationController _shineCtrl;

  @override
  void initState() {
    super.initState();
    _seen = widget.item.isSeen;
    _colorCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      value: _seen ? 1.0 : 0.0,
    );
    _shineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void didUpdateWidget(covariant CustomNotificationCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.isSeen != _seen) {
      _seen = widget.item.isSeen;
      _colorCtrl.animateTo(_seen ? 1.0 : 0.0, curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    _colorCtrl.dispose();
    _shineCtrl.dispose();
    super.dispose();
  }

  void _markSeenOptimistic() {
    if (_seen) return;
    HapticFeedback.selectionClick();
    setState(() {
      _seen = true;
    });
    _colorCtrl.animateTo(1.0, curve: Curves.easeOutCubic);
    _shineCtrl
      ..reset()
      ..forward();
    context.read<ProfileCubit>().seenNotifications(
      notificationId: widget.item.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadBg = AppColors.primaryColor.withAlpha(14);
    final seenBg = AppColors.secondaryColor.withAlpha(14);
    final unreadBorder = AppColors.primaryColor.withAlpha(60);
    final seenBorder = AppColors.secondaryColor.withAlpha(60);
    return GestureDetector(
      onTap: _markSeenOptimistic,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _colorCtrl,
        builder: (context, child) {
          final t = _colorCtrl.value;
          final bg = Color.lerp(unreadBg, seenBg, t)!;
          final border = Color.lerp(unreadBorder, seenBorder, t)!;
          return Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                if (t < 0.5)
                  BoxShadow(
                    color: AppColors.primaryColor.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: border, width: 1),
                    ),
                    child: _buildContent(),
                  ),
                  _ShineOverlay(controller: _shineCtrl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    final eyeColor = _seen ? AppColors.secondaryColor : AppColors.primaryColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLeadingBadgeWidget(unread: !_seen),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.styleBlack16Bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: _markSeenOptimistic,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder:
                          (c, anim) => ScaleTransition(scale: anim, child: c),
                      child: Icon(
                        _seen
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_outlined,
                        key: ValueKey<bool>(_seen),
                        size: 20.sp,
                        color: eyeColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                widget.item.body,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.styleBlack14W500.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShineOverlay extends StatelessWidget {
  const _ShineOverlay({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;
          final total = cardWidth + 120.0;
          return AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              final dx = (controller.value * total) - 120.0;
              final opacity =
                  controller.value <= 0.5
                      ? controller.value * 2
                      : (1 - controller.value) * 2;
              return IgnorePointer(
                child: Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(dx, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Opacity(
                          opacity: opacity.clamp(0.0, 0.9),
                          child: SizedBox(
                            width: 90.w,
                            child: const _ShineStrip(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ShineStrip extends StatelessWidget {
  const _ShineStrip();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white.withAlpha(0),
              Colors.white.withAlpha(89),
              Colors.white.withAlpha(0),
            ],
          ),
        ),
      ),
    );
  }
}
