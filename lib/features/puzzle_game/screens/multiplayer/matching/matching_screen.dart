import 'dart:developer';

import 'package:autism_empowering/features/puzzle_game/application/states/player_matching_state.dart';
import 'package:autism_empowering/features/puzzle_game/models/user_info.dart';
import 'package:autism_empowering/features/puzzle_game/providers.dart';
import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/matching/matching_screen_large.dart';
import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/matching/matching_screen_medium.dart';
import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/matching/matching_screen_small.dart';
import 'package:autism_empowering/features/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/features/puzzle_game/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchingScreen extends ConsumerWidget {
  const MatchingScreen({
    required this.user,
    required this.solverClient,
    super.key,
  });

  final EUserData user;
  final PuzzleSolverClient solverClient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(playerMatchingNotifierProvider, (previous, next) {
      if (next is PlayerMatched) {
        log('Start multi');
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => PuzzleScreen(
        //       initialList: numberList,
        //       id: next.id,
        //       myInfo: userData,
        //     ),
        //   ),
        // );
      }
    });

    return ResponsiveLayout(
      largeChild: MatchingScreenLarge(
        user: user,
        solverClient: solverClient,
      ),
      mediumChild: MatchingScreenMedium(
        user: user,
        solverClient: solverClient,
      ),
      smallChild: MatchingScreenSmall(
        user: user,
        solverClient: solverClient,
      ),
    );
  }
}
