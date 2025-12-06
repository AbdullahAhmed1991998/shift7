import 'package:flutter/material.dart';

class SmartTwoLineTitle extends StatelessWidget {
  final String title;
  final TextStyle style;
  final TextAlign textAlign;

  const SmartTwoLineTitle({
    super.key,
    required this.title,
    required this.style,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final shaped = _shapeTitle(title);
    final words = _splitWords(title);
    final isOneWord = words.length <= 1;

    return Text(
      shaped,
      textAlign: textAlign,
      style: style,
      maxLines: isOneWord ? 1 : 2,
      softWrap: !isOneWord,
      overflow: TextOverflow.ellipsis,
    );
  }

  static List<String> _splitWords(String input) {
    return input
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
  }

  static String _shapeTitle(String raw) {
    final words = _splitWords(raw);
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first;
    if (words.length == 2) return '${words[0]}\n${words[1]}';

    int bestIndex = 1;
    int bestDiff = 1 << 30;

    for (int i = 1; i < words.length; i++) {
      final left = words.sublist(0, i).join(' ');
      final right = words.sublist(i).join(' ');
      final diff = (left.characters.length - right.characters.length).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        bestIndex = i;
      }
    }

    final left = words.sublist(0, bestIndex).join(' ');
    final right = words.sublist(bestIndex).join(' ');
    return '$left\n$right';
  }
}
