import 'package:autism_empowering/features/puzzle_game/models/puzzle_data.dart';
import 'package:autism_empowering/features/puzzle_game/models/user_info.dart';
import 'package:autism_empowering/features/puzzle_game/providers.dart';
import 'package:autism_empowering/features/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/multiplayer_screen/multi_puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MultiPuzzleWidget extends StatelessWidget {
  const MultiPuzzleWidget({
    super.key,
    required this.id,
    required this.user,
    required PuzzleSolverClient solverClient,
    required this.boardSize,
    required this.eachBoxSize,
    required PuzzleData initialPuzzleData,
    required this.fontSize,
    this.images,
    this.borderRadius = 20,
    required int kInitialSpeed,
  })  : _solverClient = solverClient,
        _initialPuzzleData = initialPuzzleData,
        _kInitialSpeed = kInitialSpeed;

  final String id;
  final EUserData user;
  final PuzzleSolverClient _solverClient;
  final double boardSize;
  final double eachBoxSize;
  final PuzzleData _initialPuzzleData;
  final double fontSize;
  final List<Image>? images;
  final int _kInitialSpeed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(multiPuzzleNotifierProvider(_solverClient));

        return state.when(
          () => MultiPuzzleBoard(
            id: id,
            user: user,
            solverClient: _solverClient,
            boardSize: boardSize,
            eachBoxSize: eachBoxSize,
            puzzleData: _initialPuzzleData,
            fontSize: fontSize,
            images: images,
            isEnabled: false,
            animationSpeed: _kInitialSpeed,
            borderRadius: borderRadius,
          ),
          initializing: () => MultiPuzzleBoard(
            id: id,
            user: user,
            solverClient: _solverClient,
            boardSize: boardSize,
            eachBoxSize: eachBoxSize,
            puzzleData: _initialPuzzleData,
            fontSize: fontSize,
            images: images,
            isEnabled: false,
            animationSpeed: _kInitialSpeed,
            borderRadius: borderRadius,
          ),
          current: (puzzleData) => MultiPuzzleBoard(
            id: id,
            user: user,
            solverClient: _solverClient,
            boardSize: boardSize,
            eachBoxSize: eachBoxSize,
            puzzleData: puzzleData,
            fontSize: fontSize,
            images: images,
            borderRadius: borderRadius,
          ),
          solved: (puzzleData) => MultiPuzzleBoard(
            id: id,
            user: user,
            solverClient: _solverClient,
            boardSize: boardSize,
            eachBoxSize: eachBoxSize,
            puzzleData: puzzleData,
            fontSize: fontSize,
            images: images,
            isEnabled: false,
            borderRadius: borderRadius,
          ),
          error: (_) => MultiPuzzleBoard(
            id: id,
            user: user,
            solverClient: _solverClient,
            boardSize: boardSize,
            eachBoxSize: eachBoxSize,
            puzzleData: _initialPuzzleData,
            fontSize: fontSize,
            images: images,
            borderRadius: borderRadius,
          ),
        );
      },
    );
  }
}
