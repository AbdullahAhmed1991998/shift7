import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';

class CustomGovernorateDropdown extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;
  final String? hintText;
  final Color? fillColor;
  final void Function(String)? onChanged;

  const CustomGovernorateDropdown({
    super.key,
    required this.items,
    required this.controller,
    this.hintText,
    this.fillColor,
    this.onChanged,
  });

  @override
  State<CustomGovernorateDropdown> createState() =>
      _CustomGovernorateDropdownState();
}

class _CustomGovernorateDropdownState extends State<CustomGovernorateDropdown>
    with WidgetsBindingObserver {
  final GlobalKey _overlayKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _disposed = false;
  StateSetter? _overlaySetState;

  String? get _selectedValue {
    final value = widget.controller.text.trim();
    if (value.isEmpty) return null;
    return value;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(CustomGovernorateDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpen && _overlaySetState != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_disposed && _overlaySetState != null) {
          _overlaySetState!(() {});
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
    _scrollController.dispose();
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
      _overlaySetState = null;
      _isOpen = false;
    }
  }

  void _removeOverlay() {
    _forceRemoveOverlay();
    _safeSetState(() {
      _isOpen = false;
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted || _disposed) return;

    final renderBox =
        _overlayKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !mounted || _disposed) return;

    try {
      final size = renderBox.size;
      final offset = renderBox.localToGlobal(Offset.zero);
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final availableHeight = screenHeight - offset.dy - size.height - 20.h;
      final maxHeight = availableHeight > 250.h ? 250.h : availableHeight;

      _safeSetState(() {
        _isOpen = true;
      });

      _overlayEntry = OverlayEntry(
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              _overlaySetState = setState;

              return Stack(
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
                        ),
                        child:
                            widget.items.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: widget.items.length,
                                  itemBuilder: (context, index) {
                                    final item = widget.items[index];
                                    final isSelected =
                                        item == widget.controller.text.trim();

                                    return GestureDetector(
                                      onTap: () {
                                        if (_disposed) return;
                                        widget.controller.text = item;
                                        widget.onChanged?.call(item);
                                        _removeOverlay();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 10.h,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20.w,
                                              height: 20.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    isSelected
                                                        ? AppColors.primaryColor
                                                        : Colors.grey.shade300,
                                                border: Border.all(
                                                  color:
                                                      isSelected
                                                          ? AppColors
                                                              .primaryColor
                                                          : Colors
                                                              .grey
                                                              .shade400,
                                                  width: 1,
                                                ),
                                              ),
                                              child:
                                                  isSelected
                                                      ? Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 12.sp,
                                                      )
                                                      : null,
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Cairo',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );

      if (mounted && !_disposed && context.mounted) {
        Overlay.of(context).insert(_overlayEntry!);
      }
    } catch (_) {
      _forceRemoveOverlay();
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      alignment: Alignment.center,
      child: Text(
        widget.hintText ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14.sp,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
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
        width: double.infinity,
        height: 55.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: widget.fillColor ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(EvaIcons.pin, color: AppColors.secondaryColor),
                SizedBox(width: 8.w),
                Text(
                  _selectedValue?.isNotEmpty == true
                      ? _selectedValue!
                      : (widget.hintText ?? ''),
                  style: AppTextStyle.styleBlack14W500,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Icon(
              _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.secondaryColor,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
