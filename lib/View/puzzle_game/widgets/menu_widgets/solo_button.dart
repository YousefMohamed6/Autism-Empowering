import 'package:autism_empowering/View/puzzle_game/res/palette.dart';
import 'package:autism_empowering/View/puzzle_game/screens/puzzle_solo_screen.dart';
import 'package:flutter/material.dart';

class SoloButton extends StatelessWidget {
  const SoloButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Palette.violet,
          backgroundColor: Palette.violet,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: const BorderSide(
            width: 2,
            color: Palette.violet,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const PuzzleSoloScreen(),
            ),
            (route) => false,
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Solo',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
