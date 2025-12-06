import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shift7_app/features/app/presentation/screens/widgets/custom_svg_app_icon_widget.dart';

class CustomStoreImageWidget extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final bool withAnimation;
  final bool small;

  const CustomStoreImageWidget({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.withAnimation = false,
    this.small = false,
  });

  @override
  State<CustomStoreImageWidget> createState() => _CustomStoreImageWidgetState();
}

class _CustomStoreImageWidgetState extends State<CustomStoreImageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.withAnimation) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget =
        widget.imageUrl.isEmpty
            ? const CustomSvgAppIconWidget()
            : CachedNetworkImage(
              imageUrl: widget.imageUrl,
              height: widget.height,
              width: widget.width,
              fit: BoxFit.contain,

              errorWidget:
                  (context, url, error) => const CustomSvgAppIconWidget(),
            );

    return widget.withAnimation
        ? SlideTransition(position: _animation, child: imageWidget)
        : imageWidget;
  }
}
