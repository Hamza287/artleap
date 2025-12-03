import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/route_export.dart';

class ImageLoadingEffect extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const ImageLoadingEffect({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<ImageLoadingEffect> createState() => _ImageLoadingEffectState();
}

class _ImageLoadingEffectState extends State<ImageLoadingEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: false);

    _gradientAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 450,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: widget.borderRadius,
          ),
          child: CustomPaint(
            painter: _ImageLoadingPainter(
              animationValue: _gradientAnimation.value,
              baseColor: theme.colorScheme.surfaceVariant,
              highlightColor: theme.colorScheme.surfaceVariant.withOpacity(0.8),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ImageLoadingPainter extends CustomPainter {
  final double animationValue;
  final Color baseColor;
  final Color highlightColor;

  _ImageLoadingPainter({
    required this.animationValue,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()..color = baseColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), basePaint);

    final gradientRect = Rect.fromLTWH(
      -size.width + (size.width * 2 * animationValue),
      0,
      size.width * 0.4,
      size.height,
    );

    final gradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          baseColor.withOpacity(0.3),
          highlightColor,
          baseColor.withOpacity(0.3),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(gradientRect);

    canvas.drawRect(gradientRect, gradient);
  }

  @override
  bool shouldRepaint(covariant _ImageLoadingPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        baseColor != oldDelegate.baseColor ||
        highlightColor != oldDelegate.highlightColor;
  }
}