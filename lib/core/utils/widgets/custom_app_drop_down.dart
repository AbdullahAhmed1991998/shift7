import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_colors.dart';

class CustomAppDropdown extends StatefulWidget {
  final List<String> items;
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Color? fillColor;

  const CustomAppDropdown({
    super.key,
    required this.items,
    this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
    this.fillColor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomAppDropdownState createState() => _CustomAppDropdownState();
}

class _CustomAppDropdownState extends State<CustomAppDropdown> {
  String? _selectedItem;
  final _focusNode = FocusNode();
  final _overlayKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _selectedItem = widget.controller!.text;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && _overlayEntry == null) {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox renderBox =
        _overlayKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

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
                left: offset.dx,
                top: offset.dy + size.height + 3.h,
                width: size.width,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200.h),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isSelected = item == _selectedItem;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedItem = item;
                              if (widget.controller != null) {
                                widget.controller!.text = item;
                              }
                              widget.onChanged?.call(item);
                            });
                            _removeOverlay();
                            _focusNode.unfocus();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24.w,
                                  height: 24.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isSelected
                                            ? const Color(0xFF00A3FF)
                                            : Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontFamily: 'Rubik',
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
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      validator: widget.validator,
      readOnly: true,
      cursorRadius: Radius.circular(0.r),
      cursorColor: Colors.white,
      cursorErrorColor: Colors.red,
      cursorWidth: 2.w,
      style: TextStyle(
        color: Colors.white,
        fontSize: 22.sp,
        fontFamily: 'Rubik',
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        hintText: widget.hintText,
        suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        filled: true,
        fillColor: widget.fillColor ?? const Color(0xFF1C2526),
        hintStyle: TextStyle(
          color: Colors.white.withAlpha(127),
          fontSize: 22.sp,
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 20.sp,
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF00A3FF), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      key: _overlayKey,
      onTap: () {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        } else {
          _focusNode.requestFocus();
        }
      },
    );
  }
}
