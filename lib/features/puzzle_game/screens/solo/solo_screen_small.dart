import 'package:autism_empowering/features/puzzle_game/application/states/puzzle_state.dart';
import 'package:autism_empowering/features/puzzle_game/models/puzzle_data.dart';
import 'package:autism_empowering/features/puzzle_game/providers.dart';
import 'package:autism_empowering/features/puzzle_game/res/puzzle_constants.dart';
import 'package:autism_empowering/features/puzzle_game/screens/puzzle/top_bar.dart';
import 'package:autism_empowering/features/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/puzzle_widgets/solo/timer_widget.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/solo_screen/animated_dash.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/solo_screen/countdown_overlay.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/solo_screen/game_button_widget.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/solo_screen/moves_tiles_widget.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/solo_screen/puzzle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class SoloScreenSmall extends ConsumerStatefulWidget {
  const SoloScreenSmall({
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

class _SoloScreenLargeState extends ConsumerState<SoloScreenSmall> {
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

    var fontSize = 48.0;
    var boardSize = 300.0;

    var spacing = 3;
    var eachBoxSize = (boardSize / _puzzleSize) - (spacing * (_puzzleSize - 1));

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Stack(
            children: [
              Row(
                children: [
                  const Spacer(),
                  AnimatedDash(
                    boardSize: boardSize / 1.5,
                    riveController: _riveController,
                    onInit: (_) => setState(() {}),
                    padding: const EdgeInsets.only(right: 16.0, bottom: 30),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(),
                    const SizedBox(height: 30),
                    const Text(
                      'Puzzle Challenge',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MovesTilesWidget(
                      solverClient: _solverClient,
                      fontSize: 22,
                    ),
                    const SizedBox(height: 8),
                    const TimerWidget(fontSize: 24),
                    PreferredSize(
                      preferredSize: const Size(double.maxFinite, 100),
                      child: TopBar(
                        puzzleSize: _puzzleSize,
                        puzzleType: _puzzleType,
                        color: Theme.of(context).colorScheme.surface,
                        tileGap: 4,
                        padding: const EdgeInsets.only(top: 10, bottom: 8),
                        isCentered: true,
                      ),
                    ),
                    // const SizedBox(height: 36),
                    PuzzleWidget(
                      solverClient: _solverClient,
                      boardSize: boardSize,
                      eachBoxSize: eachBoxSize,
                      initialPuzzleData: _initialPuzzleData,
                      fontSize: fontSize,
                      kInitialSpeed: kInitialSpeed,
                      borderRadius: 16,
                    ),
                    const SizedBox(height: 24),
                    GameButtonWidget(
                      solverClient: _solverClient,
                      initialPuzzleData: _initialPuzzleData,
                      padding: const EdgeInsets.only(top: 10.0, bottom: 9.0),
                      width: 130,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
        CountdownOverlay(
          isStartPressed: _isStartPressed,
          onFinish: () {
            ref.read(timerNotifierProvider.notifier).startTimer();
            setState(() {
              _isStartPressed = false;
            });
          },
          initialSpeed: kInitialSpeed,
        ),
      ],
    );
  }
}
