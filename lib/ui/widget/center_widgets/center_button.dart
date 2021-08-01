// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

Widget centerOptionButton(
    {required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Icon(
        icon,
        color: Colors.white,
      ),
      Text(text).fontSize(12.sp).textColor(Colors.white),
    ],
  )
      .constrained(height: 40.h, width: 80.w)
      .card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.w)),
          color: color)
      .gestures(onTap: onPressed);
}
