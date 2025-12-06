import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class PriceFilterWidget extends StatefulWidget {
  final int? minPrice;
  final int? maxPrice;
  final void Function(int?, int?) onPriceChanged;
  final Color? fillColor;

  const PriceFilterWidget({
    super.key,
    this.minPrice,
    this.maxPrice,
    required this.onPriceChanged,
    this.fillColor,
  });

  @override
  State<PriceFilterWidget> createState() => _PriceFilterWidgetState();
}

class _PriceFilterWidgetState extends State<PriceFilterWidget>
    with WidgetsBindingObserver {
  final _focusNode = FocusNode();
  final _overlayKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  bool _isOpen = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.minPrice != null) {
      _minController.text = widget.minPrice!.toString();
    }
    if (widget.maxPrice != null) {
      _maxController.text = widget.maxPrice!.toString();
    }
  }

  @override
  void didUpdateWidget(PriceFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_disposed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_disposed) {
          if (widget.minPrice != oldWidget.minPrice) {
            _minController.text = widget.minPrice?.toString() ?? '';
          }
          if (widget.maxPrice != oldWidget.maxPrice) {
            _maxController.text = widget.maxPrice?.toString() ?? '';
          }
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _forceRemoveOverlay();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    _minController.dispose();
    _maxController.dispose();
    _forceRemoveOverlay();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (mounted && !_disposed) {
      setState(fn);
    }
  }

  void _forceRemoveOverlay() {
    try {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
    } finally {
      _overlayEntry = null;
      _isOpen = false;
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted || _disposed) return;

    final RenderBox? renderBox =
        _overlayKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !mounted || _disposed) return;

    try {
      final size = renderBox.size;
      final offset = renderBox.localToGlobal(Offset.zero);
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final availableHeight = screenHeight - offset.dy - size.height - 20.h;
      final maxHeight = availableHeight > 300.h ? 300.h : availableHeight;

      _safeSetState(() {
        _isOpen = true;
      });

      _overlayEntry = OverlayEntry(
        builder:
            (context) => Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _removeOverlay,
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Positioned(
                  left: 16.w,
                  right: 16.w,
                  top: offset.dy + size.height + 4.h,
                  child: Material(
                    elevation: 8.0,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      width: screenWidth - 32.w,
                      constraints: BoxConstraints(maxHeight: maxHeight),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "min_price".tr(),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12.sp,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    TextFormField(
                                      controller: _minController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.sp,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 14.sp,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 10.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "max_price".tr(),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12.sp,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    TextFormField(
                                      controller: _maxController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.sp,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '99999',
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 14.sp,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 10.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    if (!_disposed) {
                                      _minController.clear();
                                      _maxController.clear();
                                      widget.onPriceChanged(null, null);
                                      _removeOverlay();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red.withAlpha(30),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    'clear_all'.tr(),
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    if (!_disposed) {
                                      final minValue =
                                          _minController.text.isEmpty
                                              ? null
                                              : int.tryParse(
                                                _minController.text,
                                              );
                                      final maxValue =
                                          _maxController.text.isEmpty
                                              ? null
                                              : int.tryParse(
                                                _maxController.text,
                                              );

                                      widget.onPriceChanged(minValue, maxValue);
                                      _removeOverlay();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    'apply'.tr(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      );

      if (mounted && !_disposed && context.mounted) {
        Overlay.of(context).insert(_overlayEntry!);
      }
    } catch (e) {
      _forceRemoveOverlay();
    }
  }

  void _removeOverlay() {
    _forceRemoveOverlay();
    _safeSetState(() {
      _isOpen = false;
    });
  }

  String _getPriceText() {
    if (widget.minPrice == null && widget.maxPrice == null) {
      return "price_range".tr();
    }

    if (widget.minPrice != null && widget.maxPrice != null) {
      return '${widget.minPrice} - ${widget.maxPrice}';
    } else if (widget.minPrice != null) {
      return '${"from".tr()} ${widget.minPrice}';
    } else {
      return '${"to".tr()} ${widget.maxPrice}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _overlayKey,
      onTap: () {
        if (_disposed) return;
        if (_isOpen) {
          _removeOverlay();
        } else {
          _showOverlay();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                (widget.minPrice != null || widget.maxPrice != null)
                    ? AppColors.primaryColor
                    : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                _getPriceText(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
