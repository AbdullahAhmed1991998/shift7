import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/functions/format_price.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/features/profile/data/models/get_my_orders_model.dart';
import 'package:shift7_app/features/profile/presentation/screens/widgets/custom_my_orders_product_mini_tile_widget.dart';

class MyOrdersCard extends StatefulWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const MyOrdersCard({super.key, required this.order, this.onTap});

  @override
  State<MyOrdersCard> createState() => _MyOrdersCardState();
}

class _MyOrdersCardState extends State<MyOrdersCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _arrowTurns;

  bool get _isArabic => getIt<CacheHelper>().getData(key: 'language') == 'ar';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _arrowTurns = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  String _mapStatus(int status) {
    switch (status) {
      case 0:
        return 'pending'.tr();
      case 1:
        return 'processing'.tr();
      case 2:
        return 'shipped'.tr();
      case 3:
        return 'delivered'.tr();
      case 4:
        return 'canceled'.tr();
      default:
        return 'pending'.tr();
    }
  }

  Color _statusColor(int status) {
    switch (status) {
      case 0:
        return AppColors.secondaryColor;
      case 1:
        return Colors.tealAccent;
      case 2:
        return AppColors.secondaryColor;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return AppColors.secondaryColor;
    }
  }

  String _formatDateTime(DateTime date) {
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    int hour = date.hour;
    final int minute = date.minute;
    final bool isPm = hour >= 12;
    final bool is12 = hour == 0 || hour == 12;
    final int displayHour = is12 ? 12 : hour % 12;
    final String hStr = displayHour.toString().padLeft(2, '0');
    final String minStr = minute.toString().padLeft(2, '0');

    String period;
    if (_isArabic) {
      period = isPm ? 'م'.tr() : 'ص'.tr();
    } else {
      period = isPm ? 'pm'.tr() : 'am'.tr();
    }

    final String dateStr = '$y-$m-$d';
    final String timeStr = '$hStr:$minStr $period';
    return '$dateStr  $timeStr';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatMoney(double v) => formatJod(v, _isArabic);

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    final Color borderColor = Colors.grey.withAlpha(60);
    final Color statusColor = _statusColor(order.status);
    final Color chipBg = statusColor.withAlpha(30);
    final String orderIdText = '${'orderNumber'.tr()} ${order.id}';
    final String dateText = _formatDateTime(order.createdAt);
    final String totalText = _formatMoney(order.totalPrice);

    final String subTotalText = _formatMoney(order.subTotalPrice);
    final String taxText = _formatMoney(order.taxFee);
    final String serviceText = _formatMoney(order.serviceFee);
    final String deliveryText = _formatMoney(order.deliveryFee);
    final String couponText = _formatMoney(order.coupon);

    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor, width: 0.7),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.primaryColor.withAlpha(15),
                ),
                child: Center(
                  child: Text(
                    orderIdText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.styleBlack16Bold.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  IntrinsicWidth(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        dateText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.styleBlack12W500.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      _mapStatus(order.status),
                      style: AppTextStyle.styleBlack12W500.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  InkWell(
                    onTap: _toggleExpanded,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: RotationTransition(
                        turns: _arrowTurns,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22.sp,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.yellow.withAlpha(10),
                ),
                child: Column(
                  children: [
                    _PriceRow(label: 'subTotal'.tr(), value: subTotalText),
                    SizedBox(height: 4.h),
                    _PriceRow(label: 'taxFee'.tr(), value: taxText),
                    SizedBox(height: 4.h),
                    _PriceRow(label: 'serviceFee'.tr(), value: serviceText),
                    SizedBox(height: 4.h),
                    _PriceRow(label: 'deliveryFee'.tr(), value: deliveryText),
                    SizedBox(height: 4.h),
                    _PriceRow(
                      label: 'coupon'.tr(),
                      value: '- $couponText',
                      valueColor: Colors.red,
                    ),
                    SizedBox(height: 8.h),
                    Divider(
                      color: Colors.grey[300],
                      height: 12.h,
                      thickness: 1,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'totalPrice'.tr(),
                          style: AppTextStyle.stylePrimary16Bold,
                        ),
                        Text(totalText, style: AppTextStyle.stylePrimary16Bold),
                      ],
                    ),
                  ],
                ),
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child:
                    _expanded
                        ? Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Column(
                            children: [
                              Divider(
                                height: 16.h,
                                color: Colors.grey[200],
                                thickness: 1,
                              ),
                              Column(
                                children:
                                    order.orderItems
                                        .map(
                                          (item) => MyOrdersProductMiniTile(
                                            item: item,
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PriceRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.styleBlack14W500),
        Text(
          value,
          style: AppTextStyle.styleBlack14W500.copyWith(
            color: valueColor ?? AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
