import 'package:autism_empowering/View/puzzle_game/application/states/puzzle_state.dart';
import 'package:autism_empowering/View/puzzle_game/models/puzzle_data.dart';
import 'package:autism_empowering/View/puzzle_game/providers.dart';
import 'package:autism_empowering/View/puzzle_game/screens/solo/solo_screen_large.dart';
import 'package:autism_empowering/View/puzzle_game/screens/solo/solo_screen_small.dart';
import 'package:autism_empowering/View/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/View/puzzle_game/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import 'solo_screen_medium.dart';

class SoloScreen extends ConsumerWidget {
  const SoloScreen({
    required this.solverClient,
    required this.initialPuzzleData,
    required this.puzzleSize,
    required this.puzzleType,
    required this.riveController,
    super.key,
  });

  final PuzzleSolverClient solverClient;
  final PuzzleData initialPuzzleData;
  final int puzzleSize;
  final String puzzleType;
  final RiveAnimationController riveController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(puzzleNotifierProvider(solverClient),
        (previous, PuzzleState next) {
      if (next is PuzzleSolved) {
        ref.read(timerNotifierProvider.notifier).stopTimer();
      }
    });

    return ResponsiveLayout(
      largeChild: SoloScreenLarge(
        solverClient: solverClient,
        puzzleType: puzzleType,
        initialPuzzleData: initialPuzzleData,
        puzzleSize: puzzleSize,
        riveController: riveController,
      ),
      mediumChild: SoloScreenMedium(
        solverClient: solverClient,
        initialPuzzleData: initialPuzzleData,
        puzzleSize: puzzleSize,
        puzzleType: puzzleType,
        riveController: riveController,
      ),
      smallChild: SoloScreenSmall(
        solverClient: solverClient,
        initialPuzzleData: initialPuzzleData,
        puzzleSize: puzzleSize,
        puzzleType: puzzleType,
        riveController: riveController,
      ),
    );
  }
}
