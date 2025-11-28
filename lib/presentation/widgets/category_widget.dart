import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final String icon;
  static Color color = Color(0xFF53B538);
  final String label;
  final Widget destination;

  const CircleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFF3F4F6), width: 1),
              ),
              child: Image.asset(icon, width: 32, height: 32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF4B5563), letterSpacing: 0),
          ),
        ],
      ),
    );
  }
}
