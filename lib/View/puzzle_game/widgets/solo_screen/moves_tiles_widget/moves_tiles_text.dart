import 'package:flutter/material.dart';

class MovesTilesText extends StatelessWidget {
  final int moves;
  final int tiles;
  final double fontSize;

  const MovesTilesText({
    super.key,
    required this.moves,
    required this.tiles,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          // fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: moves.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' Moves | '),
          TextSpan(
            text: tiles.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' Tiles'),
        ],
      ),
    );
  }
}
