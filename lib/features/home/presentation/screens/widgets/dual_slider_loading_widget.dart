import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DualSliderLoadingWidget extends StatefulWidget {
  const DualSliderLoadingWidget({super.key});

  @override
  State<DualSliderLoadingWidget> createState() =>
      _DualSliderLoadingWidgetState();
}

class _DualSliderLoadingWidgetState extends State<DualSliderLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBox() => FadeTransition(
    opacity: _animation,
    child: Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.r),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230.h,
      child: Row(
        children: [
          Expanded(
            child: Padding(padding: EdgeInsets.all(5.w), child: _buildBox()),
          ),
          Expanded(
            child: Padding(padding: EdgeInsets.all(5.w), child: _buildBox()),
          ),
        ],
      ),
    );
  }
}
