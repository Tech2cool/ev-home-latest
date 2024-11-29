import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedPieChart extends StatefulWidget {
  final int visited;
  final int notVisited;
  final String title;
  final Color visitedColor;
  final Color notVisitedColor;

  const AnimatedPieChart({
    Key? key,
    required this.visited,
    required this.notVisited,
    required this.title,
    this.visitedColor = Colors.green,
    this.notVisitedColor = Colors.pink, // Updated default color
  }) : super(key: key);

  @override
  State<AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..repeat(); // Make the animation repeat continuously

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear, // Use linear curve for smooth rotation
    );
  }

  @override
  void didUpdateWidget(AnimatedPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visited != widget.visited ||
        oldWidget.notVisited != widget.notVisited) {
      _controller.reset();
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.visited + widget.notVisited;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: PieChartPainter(
                  animation: _animation.value,
                  visited: widget.visited,
                  notVisited: widget.notVisited,
                  visitedColor: widget.visitedColor,
                  notVisitedColor: widget.notVisitedColor,
                ),
              );
            },
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: total),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, value, child) {
                      return Text(
                        '$value',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      );
                    },
                  ),
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(
                          'Visited', widget.visited, widget.visitedColor),
                      const SizedBox(width: 20),
                      _buildLegendItem('Not Visited', widget.notVisited,
                          widget.notVisitedColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double animation;
  final int visited;
  final int notVisited;
  final Color visitedColor;
  final Color notVisitedColor;

  PieChartPainter({
    required this.animation,
    required this.visited,
    required this.notVisited,
    required this.visitedColor,
    required this.notVisitedColor, // Updated default color
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final strokeWidth = radius * 0.2;

    final total = visited + notVisited;
    final visitedAngle = (visited / total) * 2 * pi;
    final notVisitedAngle = (notVisited / total) * 2 * pi;

    // Draw background circle
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Draw segments
    final visitedPaint = Paint()
      ..color = visitedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final notVisitedPaint = Paint()
      ..color = notVisitedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw visited segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      visitedAngle,
      false,
      visitedPaint,
    );

    // Draw not visited segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2 + visitedAngle,
      notVisitedAngle,
      false,
      notVisitedPaint,
    );

    // Draw animated particles
    _drawAnimatedParticles(canvas, size, visitedAngle, notVisitedAngle);
  }

  void _drawAnimatedParticles(
      Canvas canvas, Size size, double visitedAngle, double notVisitedAngle) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final particleRadius = 2.0;

    final visitedParticlePaint = Paint()..color = visitedColor;
    final notVisitedParticlePaint = Paint()..color = notVisitedColor;

    final particleCount = 50;
    for (var i = 0; i < particleCount; i++) {
      final t = i / particleCount;
      final baseAngle = t * 2 * pi;

      // Add rotation animation
      final rotationAngle = baseAngle + (animation * 2 * pi);

      final distanceFromCenter =
          radius * (0.6 + 0.2 * sin(baseAngle * 3 + animation * 10));

      final x = center.dx + distanceFromCenter * cos(rotationAngle);
      final y = center.dy + distanceFromCenter * sin(rotationAngle);

      final particlePosition = Offset(x, y);

      if (baseAngle <= visitedAngle - pi / 2 || baseAngle > 2 * pi - pi / 2) {
        canvas.drawCircle(
            particlePosition, particleRadius, visitedParticlePaint);
      } else {
        canvas.drawCircle(
            particlePosition, particleRadius, notVisitedParticlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.visited != visited ||
        oldDelegate.notVisited != notVisited;
  }
}
