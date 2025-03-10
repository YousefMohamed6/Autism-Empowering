import 'package:flutter/material.dart';

class PuzzleSideImage extends StatelessWidget {
  const PuzzleSideImage({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: double.maxFinite,
      child: Image.asset(
        'assets/images/puzzle_side_image.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
