import 'dart:developer';

import 'package:autism_empowering/View/puzzle_game/utils/puzzle_solver.dart';
import 'package:flutter/material.dart';

class Helpers {
  static Map<int, FractionalOffset> createOffset(
    List<int> board,
    PuzzleSolverClient solverClient,
  ) {
    Map<int, FractionalOffset> offsetMap = {};
    int j = 0;

    log('BOARD: $board');

    for (int i = 0; i < board.length; i++) {
      var puzzleSize = solverClient.size;
      final xMod = i % puzzleSize;
      double x = xMod / (puzzleSize - 1);

      if (x % i == 0 && i != 0) j++;
      int yMod = j % puzzleSize;
      double y = yMod / (puzzleSize - 1);

      offsetMap.addEntries([
        MapEntry<int, FractionalOffset>(
          board[i],
          FractionalOffset(x, y),
        )
      ]);
    }

    log('INITIAL OFFSET MAP: $offsetMap');

    return offsetMap;
  }
}
