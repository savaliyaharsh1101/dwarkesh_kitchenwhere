import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double? size;
  final Color? color; // Not used for image logo but kept for compatibility
  
  const LogoWidget({
    Key? key,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 32.0;

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/logo.jpeg',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if image fails to load
            return Container(
              width: logoSize,
              height: logoSize,
              color: Colors.orange[700],
              child: Center(
                child: Text(
                  'DE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: logoSize * 0.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class KitchenLogoPainter extends CustomPainter {
  final Color color;
  
  KitchenLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Draw subtle kitchen pattern - like steam lines
    for (int i = 0; i < 3; i++) {
      final y = size.height * (0.2 + i * 0.15);
      canvas.drawLine(
        Offset(size.width * 0.15, y),
        Offset(size.width * 0.3, y),
        paint,
      );
    }
    
    // Draw can/container outline
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.7,
        size.height * 0.15,
        size.width * 0.15,
        size.height * 0.3,
      ),
      Radius.circular(2),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
