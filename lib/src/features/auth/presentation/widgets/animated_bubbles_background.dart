import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBubblesBackground extends StatefulWidget {
  const AnimatedBubblesBackground({super.key});

  @override
  State<AnimatedBubblesBackground> createState() =>
      _AnimatedBubblesBackgroundState();
}

class _AnimatedBubblesBackgroundState extends State<AnimatedBubblesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Bubble> _bubbles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize bubbles
    for (int i = 0; i < 8; i++) {
      _bubbles.add(Bubble(_random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BubblesPainter(
            bubbles: _bubbles,
            animationValue: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class Bubble {
  late double x;
  late double y;
  late double radius;
  late double speed;
  late double opacity;
  late Color color;

  Bubble(Random random) {
    reset(random);
    // Start at random y positions initially
    y = random.nextDouble();
  }

  void reset(Random random) {
    x = random.nextDouble();
    y = 1.2; // Start slightly below screen
    radius = random.nextDouble() * 50 + 30; // Radius between 30 and 80
    speed = random.nextDouble() * 0.05 + 0.01; // Speed factor (much slower)
    opacity = random.nextDouble() * 0.2 + 0.05; // Opacity between 0.05 and 0.25
    color = Colors.white.withValues(alpha: opacity);
  }

  void update(Random random) {
    y -= speed * 0.01; // Move up
    if (y < -0.3) {
      // Allow to go further up before resetting to handle large bubbles
      reset(random);
    }
  }
}

class BubblesPainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double animationValue;
  final Random _random = Random();

  BubblesPainter({required this.bubbles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      bubble.update(_random);

      final center = Offset(bubble.x * size.width, bubble.y * size.height);
      // Create a 3D-like effect with RadialGradient
      final gradient = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: bubble.opacity * 0.8), // Highlight
          Colors.white.withValues(alpha: bubble.opacity * 0.1), // Shadow/Body
          Colors.transparent, // Edge
        ],
        stops: const [0.0, 0.7, 1.0],
        center: const Alignment(-0.3, -0.3), // Light source from top-left
        radius: 0.8,
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: bubble.radius),
        )
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, bubble.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
