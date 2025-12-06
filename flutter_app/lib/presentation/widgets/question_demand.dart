import 'package:flutter/material.dart';

class QuestionDemand extends StatelessWidget {
  final String question;
  const QuestionDemand({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 10, top: 10),
      child: Text(
        question,
        style: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
