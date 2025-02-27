import 'package:flutter/material.dart';

class ExpandedImage extends StatelessWidget {
  const ExpandedImage({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Image.network(image);
  }
}
