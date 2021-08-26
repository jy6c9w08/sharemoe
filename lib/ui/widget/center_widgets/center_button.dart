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
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Icon(
        icon,
        color: color,
        size: 20.w,
      ).constrained(height: 48.w, width: 48.w).decorated(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4.w,
            offset: Offset(0, 1.h),
          ),
        ],
      )
          .gestures(onTap: onPressed).padding(bottom: 4.h),
      Text(text).fontSize(12.sp).textColor(Colors.grey[600]),
    ],
  ).padding(right: 16.w);
}
