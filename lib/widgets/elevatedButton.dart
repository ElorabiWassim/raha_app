import 'package:flutter/material.dart';

Widget btn(onPressedFunc, String text) {
  return Center(
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF53B538),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ), // rounded corners
        ),
        onPressed: onPressedFunc,
        child: Text(text),
      ),
    ),
  );
}
