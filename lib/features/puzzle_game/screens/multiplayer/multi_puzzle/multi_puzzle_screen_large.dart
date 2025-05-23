import 'dart:developer';

import 'package:autism_empowering/features/puzzle_game/application/states/puzzle_state.dart';
import 'package:autism_empowering/features/puzzle_game/models/puzzle_data.dart';
import 'package:autism_empowering/features/puzzle_game/models/user_info.dart';
import 'package:autism_empowering/features/puzzle_game/providers.dart';
import 'package:autism_empowering/features/puzzle_game/res/puzzle_constants.dart';
import 'package:autism_empowering/features/puzzle_game/res/strings.dart';
import 'package:autism_empowering/features/puzzle_game/screens/puzzle/top_bar.dart';
import 'package:autism_empowering/features/puzzle_game/utils/database_client.dart';
import 'package:autism_empowering/features/puzzle_game/utils/helpers.dart';
import 'package:autism_empowering/features/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/multiplayer_screen/multi_moves_tiles_widget.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/multiplayer_screen/multi_puzzle_widget.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/multiplayer_screen/other_player_puzzle.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/puzzle_widgets/solo/timer_widget.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/solo_screen/animated_dash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class MultiPuzzleScreenLarge extends ConsumerStatefulWidget {
  const MultiPuzzleScreenLarge({
    required this.id,
    required this.user,
    required this.solverClient,
    required this.initialPuzzleData,
    required this.puzzleSize,
    required this.puzzleType,
    required this.riveController,
    super.key,
  });

  final String id;
  final EUserData user;
  final PuzzleSolverClient solverClient;
  final PuzzleData initialPuzzleData;
  final int puzzleSize;
  final String puzzleType;
  final RiveAnimationController riveController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SoloScreenLargeState();
}

class _SoloScreenLargeState extends ConsumerState<MultiPuzzleScreenLarge> {
  late final PuzzleSolverClient _solverClient;
  late final int _puzzleSize;
  late final PuzzleData _initialPuzzleData;
  late final String _puzzleType;
  late final RiveAnimationController _riveController;
  late final String _id;
  late final EUserData _user;

  final _databaseClient = DatabaseClient();

  @override
  void initState() {
    _id = widget.id;
    _user = widget.user;
    _solverClient = widget.solverClient;
    _puzzleSize = widget.puzzleSize;
    _initialPuzzleData = widget.initialPuzzleData;
    _puzzleType = widget.puzzleType;
    _riveController = widget.riveController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(puzzleNotifierProvider(_solverClient),
        (previous, PuzzleState next) {
      if (next is PuzzleSolved) {
        // TODO: Add celebration
      }
      if (next is PuzzleInitializing) {}
    });

    var fontSize = 70.0;
    var boardSize = 450.0;

    var spacing = 5;
    var eachBoxSize = (boardSize / _puzzleSize) - (spacing * (_puzzleSize - 1));

    var otherFontSize = 32.0;
    var otherBoardSize = 180.0;

    var otherSpacing = 3;
    var otherEachBoxSize =
        (otherBoardSize / _puzzleSize) - (otherSpacing * (_puzzleSize - 1));

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 100),
        child: TopBar(
          puzzleSize: _puzzleSize,
          puzzleType: _puzzleType,
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 56.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(),
                Text(
                  _puzzleType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Puzzle',
                  style: TextStyle(
                    fontSize: 58,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Challenge',
                  style: TextStyle(
                    fontSize: 58,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                MultiMovesTilesWidget(solverClient: _solverClient),
                const SizedBox(height: 32),
                // GameButtonWidget(
                //   solverClient: _solverClient,
                //   initialPuzzleData: _initialPuzzleData,
                // ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const TimerWidget(
                  fontSize: 40,
                  color: Colors.black12,
                ),
                const SizedBox(height: 36),
                MultiPuzzleWidget(
                  solverClient: _solverClient,
                  boardSize: boardSize,
                  eachBoxSize: eachBoxSize,
                  initialPuzzleData: _initialPuzzleData,
                  fontSize: fontSize,
                  kInitialSpeed: kInitialSpeed,
                  id: _id,
                  user: _user,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Stack(
            children: [
              AnimatedDash(
                boardSize: boardSize * 0.8,
                riveController: _riveController,
                onInit: (_) => setState(() {}),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  // CountdownWidget(
                  //   isStartPressed: _isStartPressed,
                  //   onFinish: () {
                  //     ref.read(timerNotifierProvider.notifier).startTimer();
                  //     setState(() {
                  //       _isStartPressed = false;
                  //     });
                  //   },
                  //   initialSpeed: kInitialSpeed,
                  // ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: _databaseClient.trackGameState(id: widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        final String myUid = data[Strings.myuidFieldName];
                        final String otherUid = data[Strings.otheruidFieldName];
                        final String currentUid = widget.user.uid;
                        List<dynamic>? numberList;
                        int? moves;

                        List<String> idList = widget.id.split('-');
                        late final String opponentUid;

                        for (String id in idList) {
                          if (id != currentUid) {
                            opponentUid = id;
                          }
                        }

                        log('myuid: $myUid, otheruid: $otherUid, toMatch: $opponentUid');

                        if (otherUid != opponentUid) {
                          numberList = data[Strings.mylistFieldName];
                          moves = data[Strings.mymovesFieldName];
                        } else if (myUid != opponentUid) {
                          numberList = data[Strings.otherlistFieldName];
                          moves = data[Strings.othermovesFieldName];
                        }

                        log('list: $numberList, moves: $moves');

                        List<int> intPuzzle = List<int>.from(numberList!);
                        final board2D = _solverClient.convertTo2D(intPuzzle);
                        final offsetMap =
                            Helpers.createOffset(intPuzzle, _solverClient);

                        final puzzleData = PuzzleData(
                          board2D: board2D,
                          board1D: intPuzzle,
                          offsetMap: offsetMap,
                          moves: 0,
                          tiles: 0,
                          puzzleSize: _puzzleSize,
                        );

                        return OtherPlayerPuzzle(
                          boardSize: otherBoardSize,
                          eachBoxSize: otherEachBoxSize,
                          puzzleData: puzzleData,
                          fontSize: otherFontSize,
                          borderRadius: 6,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ],
          ),
          // SizedBox(),
        ],
      ),
    );
  }
}
