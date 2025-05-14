import 'dart:developer';

import 'package:autism_empowering/features/puzzle_game/application/states/player_matching_state.dart';
import 'package:autism_empowering/features/puzzle_game/models/puzzle_data.dart';
import 'package:autism_empowering/features/puzzle_game/models/user_info.dart';
import 'package:autism_empowering/features/puzzle_game/providers.dart';
import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/matching/matching_screen.dart';
import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/multi_puzzle/multi_puzzle_screen_large.dart';
import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/multi_puzzle/multi_puzzle_screen_medium.dart';
import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/multi_puzzle/multi_puzzle_screen_small.dart';
import 'package:autism_empowering/features/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/features/puzzle_game/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class MultiPuzzleScreen extends ConsumerWidget {
  const MultiPuzzleScreen({
    required this.user,
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
  final EUserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(playerMatchingNotifierProvider, (previous, next) {
      if (next is PlayerMatched) {
        log('Start multi');

        ref
            .read(multiPuzzleNotifierProvider(solverClient).notifier)
            .setSelectedPuzzle(id: next.id);
        ref.read(timerNotifierProvider.notifier).startTimer();
      }
    });

    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(playerMatchingNotifierProvider);

        return state.maybeWhen(
          () => MatchingScreen(
            user: user,
            solverClient: solverClient,
          ),
          isMatched: (id) => ResponsiveLayout(
            largeChild: MultiPuzzleScreenLarge(
              id: id,
              user: user,
              solverClient: solverClient,
              initialPuzzleData: initialPuzzleData,
              puzzleSize: puzzleSize,
              puzzleType: puzzleType,
              riveController: riveController,
            ),
            mediumChild: MultiPuzzleScreenMedium(
              id: id,
              user: user,
              solverClient: solverClient,
              initialPuzzleData: initialPuzzleData,
              puzzleSize: puzzleSize,
              puzzleType: puzzleType,
              riveController: riveController,
            ),
            smallChild: MultiPuzzleScreenSmall(
              id: id,
              user: user,
              solverClient: solverClient,
              initialPuzzleData: initialPuzzleData,
              puzzleSize: puzzleSize,
              puzzleType: puzzleType,
              riveController: riveController,
            ),
          ),
          orElse: () => MatchingScreen(
            user: user,
            solverClient: solverClient,
          ),
        );
      },
    );
  }
}
