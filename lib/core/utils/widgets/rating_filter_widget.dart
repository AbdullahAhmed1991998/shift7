import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class RatingFilterWidget extends StatefulWidget {
  final int? selectedRating;
  final void Function(int?) onRatingChanged;
  final Color? fillColor;

  const RatingFilterWidget({
    super.key,
    this.selectedRating,
    required this.onRatingChanged,
    this.fillColor,
  });

  @override
  State<RatingFilterWidget> createState() => _RatingFilterWidgetState();
}

class _RatingFilterWidgetState extends State<RatingFilterWidget>
    with WidgetsBindingObserver {
  int? _selectedRating;
  final _focusNode = FocusNode();
  final _overlayKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedRating = widget.selectedRating;
  }

  @override
  void didUpdateWidget(RatingFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_disposed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_disposed) {
          setState(() {
            _selectedRating = widget.selectedRating;
          });
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
      final maxHeight = availableHeight > 200.h ? 200.h : availableHeight;

      _safeSetState(() {
        _isOpen = true;
      });

      _overlayEntry = OverlayEntry(
        builder:
            (context) => StatefulBuilder(
              builder:
                  (context, overlaySetState) => Stack(
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      final rating = index + 1;
                                      final isActive =
                                          _selectedRating != null &&
                                          rating <= _selectedRating!;

                                      return GestureDetector(
                                        onTap: () {
                                          if (!_disposed) {
                                            _safeSetState(() {
                                              _selectedRating = rating;
                                            });
                                            overlaySetState(() {});
                                            widget.onRatingChanged(rating);
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                          ),
                                          child: Icon(
                                            isActive
                                                ? Icons.star
                                                : Icons.star_border,
                                            color:
                                                isActive
                                                    ? Colors.amber
                                                    : Colors.grey.shade400,
                                            size: 32.sp,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),

                                  if (_selectedRating != null) ...[
                                    SizedBox(height: 16.h),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () {
                                          if (!_disposed) {
                                            _safeSetState(() {
                                              _selectedRating = null;
                                            });
                                            overlaySetState(() {});
                                            widget.onRatingChanged(null);
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.red.withAlpha(
                                            30,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.h,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6.r,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "clear_all".tr(),
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12.sp,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                _selectedRating != null
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
                "rating".tr(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_selectedRating != null) ...[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '$_selectedRating',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
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
