import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/utils/style/app_text_style.dart';
import 'package:shift7_app/core/utils/widgets/string_color_extension.dart';

class CustomChooseColorWidget extends StatefulWidget {
  final List<String> colors;
  final String? initialSelected;
  final ValueChanged<String>? onColorSelected;

  const CustomChooseColorWidget({
    super.key,
    required this.colors,
    this.initialSelected,
    this.onColorSelected,
  });

  @override
  State<CustomChooseColorWidget> createState() =>
      _CustomChooseColorWidgetState();
}

class _CustomChooseColorWidgetState extends State<CustomChooseColorWidget>
    with SingleTickerProviderStateMixin {
  int? _selectedColorIndex;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.initialSelected != null) {
      final idx = widget.colors.indexWhere(
        (c) => c.toLowerCase() == widget.initialSelected!.toLowerCase(),
      );
      if (idx >= 0) _selectedColorIndex = idx;
    }
  }

  @override
  void didUpdateWidget(covariant CustomChooseColorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelected != oldWidget.initialSelected &&
        widget.initialSelected != null) {
      final idx = widget.colors.indexWhere(
        (c) => c.toLowerCase() == widget.initialSelected!.toLowerCase(),
      );
      if (idx >= 0 && idx != _selectedColorIndex) {
        setState(() => _selectedColorIndex = idx);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectColor(int index) {
    setState(() {
      _selectedColorIndex = index;
    });
    _animationController.forward().then((_) => _animationController.reverse());
    widget.onColorSelected?.call(widget.colors[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Colors', style: AppTextStyle.styleBlack16Bold),
          SizedBox(height: 8.h),
          SizedBox(
            height: 60.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.colors.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedColorIndex == index;
                return Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: GestureDetector(
                    onTap: () => _selectColor(index),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isSelected ? _scaleAnimation.value : 1.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 35.r,
                                height: 35.r,
                                decoration: BoxDecoration(
                                  color: widget.colors[index].toColor(),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                            ],
                          ),
                        );
                      },
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
