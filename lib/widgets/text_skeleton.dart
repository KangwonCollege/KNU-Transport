

import 'package:flutter/material.dart';
import 'package:knu_transport/utilities/text_size.dart';
import 'package:skeleton_text/skeleton_text.dart';


class SkeletonText extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Color shimmerColor;

  const SkeletonText({
    super.key,
    required this.width, 
    required this.height, 
    this.color = Colors.grey,
    this.shimmerColor = Colors.white54
  });

  SkeletonText.fromText({
    super.key,
    required String text, 
    required TextStyle style,
    Color? color,
    Color? shimmerColor
  }) : width = getTextSize(text, style).width,
    height = getTextSize(text, style).height,
    color = color ?? Colors.grey,
    shimmerColor = color ?? Colors.white54;

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
    borderRadius: BorderRadius.circular(height / 3),
    shimmerColor: Colors.white54,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(height / 3),
      color: color),
      ),
  );
  }
}