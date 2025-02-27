import 'package:autism_empowering/View/puzzle_game/application/states/puzzle_state.dart';
import 'package:autism_empowering/View/puzzle_game/models/puzzle_data.dart';
import 'package:autism_empowering/View/puzzle_game/providers.dart';
import 'package:autism_empowering/View/puzzle_game/res/puzzle_constants.dart';
import 'package:autism_empowering/View/puzzle_game/screens/puzzle/top_bar.dart';
import 'package:autism_empowering/View/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/View/puzzle_game/widgets/puzzle_widgets/solo/timer_widget.dart';
import 'package:autism_empowering/View/puzzle_game/widgets/solo_screen/animated_dash.dart';
import 'package:autism_empowering/View/puzzle_game/widgets/solo_screen/countdown_widget.dart';
import 'package:autism_empowering/View/puzzle_game/widgets/solo_screen/game_button_widget.dart';
import 'package:autism_empowering/View/puzzle_game/widgets/solo_screen/moves_tiles_widget.dart';
import 'package:autism_empowering/View/puzzle_game/widgets/solo_screen/puzzle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class SoloScreenLarge extends ConsumerStatefulWidget {
  const SoloScreenLarge({
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
      _SoloScreenLargeState();
}

class _SoloScreenLargeState extends ConsumerState<SoloScreenLarge> {
  late final PuzzleSolverClient _solverClient;
  late final int _puzzleSize;
  late final PuzzleData _initialPuzzleData;
  late final String _puzzleType;
  late final RiveAnimationController _riveController;
  bool _isStartPressed = false;

  @override
  void initState() {
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
      if (next is PuzzleInitializing) {
        setState(() {
          _isStartPressed = true;
        });
      }
    });

    var fontSize = 70.0;
    var boardSize = 450.0;

    var spacing = 5;
    var eachBoxSize = (boardSize / _puzzleSize) - (spacing * (_puzzleSize - 1));

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // backgroundColor: Palette.blue.darken(0.3),
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
                MovesTilesWidget(solverClient: _solverClient),
                const SizedBox(height: 32),
                GameButtonWidget(
                  solverClient: _solverClient,
                  initialPuzzleData: _initialPuzzleData,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const TimerWidget(
                  fontSize: 40,
                ),
                const SizedBox(height: 36),
                PuzzleWidget(
                  solverClient: _solverClient,
                  boardSize: boardSize,
                  eachBoxSize: eachBoxSize,
                  initialPuzzleData: _initialPuzzleData,
                  fontSize: fontSize,
                  kInitialSpeed: kInitialSpeed,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              CountdownWidget(
                isStartPressed: _isStartPressed,
                onFinish: () {
                  ref.read(timerNotifierProvider.notifier).startTimer();
                  setState(() {
                    _isStartPressed = false;
                  });
                },
                initialSpeed: kInitialSpeed,
              ),
              const Spacer(),
              AnimatedDash(
                boardSize: boardSize * 0.8,
                riveController: _riveController,
                onInit: (_) => setState(() {}),
              ),
            ],
          ),
          // SizedBox(),
        ],
      ),
    );
  }
}
