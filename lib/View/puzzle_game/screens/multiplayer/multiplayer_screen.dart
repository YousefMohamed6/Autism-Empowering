import 'dart:developer';

import 'package:autism_empowering/View/puzzle_game/application/states/email_auth_state.dart';
import 'package:autism_empowering/View/puzzle_game/models/puzzle_data.dart';
import 'package:autism_empowering/View/puzzle_game/providers.dart';
import 'package:autism_empowering/View/puzzle_game/screens/multiplayer/account/account_screen.dart';
import 'package:autism_empowering/View/puzzle_game/screens/multiplayer/multi_puzzle/multi_puzzle_screen.dart';
import 'package:autism_empowering/View/puzzle_game/utils/puzzle_solver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class MultiplayerScreen extends ConsumerStatefulWidget {
  const MultiplayerScreen({
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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MultiplayerScreenState();
}

class _MultiplayerScreenState extends ConsumerState<MultiplayerScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(emailAuthNotificationProvider, (previous, EmailAuthState next) {
      if (next is EmailAuthDone) {
        log('done');
        ref
            .read(multiPuzzleNotifierProvider(widget.solverClient).notifier)
            .getScrambledPuzzle();
      }
    });

    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(emailAuthNotificationProvider);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: state.maybeWhen(
            () => const AccountScreen(),
            done: (user) => MultiPuzzleScreen(
              user: user,
              solverClient: widget.solverClient,
              initialPuzzleData: widget.initialPuzzleData,
              puzzleSize: widget.puzzleSize,
              puzzleType: widget.puzzleType,
              riveController: widget.riveController,
            ),
            orElse: () => const AccountScreen(),
          ),
        );
      },
    );
  }
}
