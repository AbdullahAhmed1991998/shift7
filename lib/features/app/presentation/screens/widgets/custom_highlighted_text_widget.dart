import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHighlightedTextWidget extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? textStyle;
  final Color highlightColor;

  const CustomHighlightedTextWidget({
    super.key,
    required this.text,
    required this.query,
    this.textStyle,
    this.highlightColor = const Color(0xFFFFF59D),
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
      fontFamily: 'Cairo',
    );

    if (query.isEmpty) {
      return Text(
        text,
        style: textStyle ?? defaultStyle,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = query.toLowerCase();

    if (!lowercaseText.contains(lowercaseQuery)) {
      return Text(
        text,
        style: textStyle ?? defaultStyle,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      );
    }

    final startIndex = lowercaseText.indexOf(lowercaseQuery);
    final endIndex = startIndex + query.length;

    return RichText(
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: textStyle ?? defaultStyle,
        children: [
          if (startIndex > 0) TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              backgroundColor: highlightColor,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontFamily: 'Cairo',
            ),
          ),
          if (endIndex < text.length) TextSpan(text: text.substring(endIndex)),
        ],
      ),
    );
  }
}
