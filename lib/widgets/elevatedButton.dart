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

Widget btn2(onPressedFunc, String text) {
  return Center(
    child: Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF0FEED),
          foregroundColor: Color(0xFF9FC098),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressedFunc,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 14, color: Color(0xFF9FC098)),
            SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    ),
  );
}
