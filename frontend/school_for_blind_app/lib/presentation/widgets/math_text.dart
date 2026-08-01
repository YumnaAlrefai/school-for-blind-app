import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MathText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final double mathScale;

  const MathText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.right,
    this.mathScale = 0.72,
  });

  CrossAxisAlignment get _columnAlignment {
    switch (textAlign) {
      case TextAlign.center:
        return CrossAxisAlignment.center;
      case TextAlign.left:
        return CrossAxisAlignment.end;
      case TextAlign.right:
      default:
        return CrossAxisAlignment.start;
    }
  }

  static String _fixBracketsBidi(String input) {
    if (input.isEmpty) return input;
    return input
        .replaceAll('(', '\u200E(\u200E')
        .replaceAll(')', '\u200E)\u200E')
        .replaceAll('[', '\u200E[\u200E')
        .replaceAll(']', '\u200E]\u200E')
        .replaceAll('<', '\u200E<\u200E')
        .replaceAll('>', '\u200E>\u200E');
  }

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    final mathFontSize = (style?.fontSize ?? 30) * mathScale;
    final mathStyle = (style ?? const TextStyle()).copyWith(
      fontSize: mathFontSize,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: _columnAlignment,
        children: [
          for (int i = 0; i < lines.length; i++) ...[
            if (i > 0) SizedBox(height: (style?.fontSize ?? 30) * 0.35),
            _buildLine(lines[i], mathStyle),
          ],
        ],
      ),
    );
  }

  Widget _buildLine(String line, TextStyle mathStyle) {
    final segments = _parseSegments(line);

    if (segments.length == 1 && !segments.first.isMath) {
      if (segments.first.content.isEmpty) return const SizedBox.shrink();
      return Text(
        _fixBracketsBidi(segments.first.content),
        textAlign: textAlign,
        style: style,
        textDirection: TextDirection.rtl,
      );
    }

    return Text.rich(
      TextSpan(
        children: segments.map<InlineSpan>((segment) {
          if (segment.isMath) {
            return WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Math.tex(
                      segment.content,
                      textStyle: mathStyle,
                      mathStyle: MathStyle.text,
                      onErrorFallback: (err) => Text(
                        _fixBracketsBidi(segment.content),
                        style: mathStyle,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return TextSpan(
            text: _fixBracketsBidi(segment.content),
            style: style,
          );
        }).toList(),
      ),
      textAlign: textAlign,
      textDirection: TextDirection.rtl,
    );
  }

  static List<_Segment> _parseSegments(String input) {
    final segments = <_Segment>[];
    final pattern = RegExp(r'\$\$(.+?)\$\$|\$(.+?)\$', dotAll: true);

    int lastEnd = 0;
    for (final match in pattern.allMatches(input)) {
      if (match.start > lastEnd) {
        final plain = input.substring(lastEnd, match.start);
        if (plain.isNotEmpty) segments.add(_Segment(plain, false));
      }
      final mathContent = match.group(1) ?? match.group(2) ?? '';
      if (mathContent.trim().isNotEmpty) {
        segments.add(_Segment(mathContent.trim(), true));
      }
      lastEnd = match.end;
    }
    if (lastEnd < input.length) {
      final plain = input.substring(lastEnd);
      if (plain.isNotEmpty) segments.add(_Segment(plain, false));
    }

    if (segments.isEmpty) segments.add(_Segment(input, false));
    return segments;
  }
}

class _Segment {
  final String content;
  final bool isMath;
  _Segment(this.content, this.isMath);
}
