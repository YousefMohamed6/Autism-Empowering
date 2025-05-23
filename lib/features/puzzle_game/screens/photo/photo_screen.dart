import 'package:autism_empowering/features/puzzle_game/application/states/image_splitter_state.dart';
import 'package:autism_empowering/features/puzzle_game/application/states/puzzle_state.dart';
import 'package:autism_empowering/features/puzzle_game/models/puzzle_data.dart';
import 'package:autism_empowering/features/puzzle_game/providers.dart';
import 'package:autism_empowering/features/puzzle_game/res/palette.dart';
import 'package:autism_empowering/features/puzzle_game/screens/photo/photo_screen_large.dart';
import 'package:autism_empowering/features/puzzle_game/screens/photo/photo_screen_medium.dart';
import 'package:autism_empowering/features/puzzle_game/screens/photo/photo_screen_small.dart';
import 'package:autism_empowering/features/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/features/puzzle_game/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class PhotoScreen extends ConsumerStatefulWidget {
  const PhotoScreen({
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
  ConsumerState<ConsumerStatefulWidget> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends ConsumerState<PhotoScreen> {
  late final PuzzleSolverClient _solverClient;
  late final int _puzzleSize;
  late final PuzzleData _initialPuzzleData;
  late final String _puzzleType;
  late final RiveAnimationController _riveController;
  late ThemeData _themeData = Theme.of(context);

  @override
  void initState() {
    _solverClient = widget.solverClient;
    _puzzleSize = widget.puzzleSize;
    _initialPuzzleData = widget.initialPuzzleData;
    _puzzleType = widget.puzzleType;
    _riveController = widget.riveController;
    // _themeData = Theme.of(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(puzzleNotifierProvider(_solverClient),
        (previous, PuzzleState next) {
      if (next is PuzzleSolved) {
        ref.read(timerNotifierProvider.notifier).stopTimer();
      }
    });

    ref.listen(imageSplitterNotifierProvider, (previous, next) {
      if (next is ImageSplitterComplete) {
        _themeData = Theme.of(context).copyWith(
          colorScheme: ColorScheme(
            brightness: Theme.of(context).brightness,
            primary: next.palette.vibrantColor?.color ?? Palette.blue,
            onPrimary: next.palette.lightVibrantColor?.color ?? Colors.white,
            secondary: Theme.of(context).colorScheme.secondary,
            onSecondary: Theme.of(context).colorScheme.onSecondary,
            error: Theme.of(context).colorScheme.error,
            onError: Theme.of(context).colorScheme.onError,
            surface: Theme.of(context).colorScheme.surface,
            onSurface: Theme.of(context).colorScheme.onSurface,
          ),
        );

        setState(() {});
      }
    });

    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(imageSplitterNotifierProvider);

        return state.maybeWhen(
          () => Theme(
            data: _themeData,
            child: ResponsiveLayout(
              largeChild: PhotoScreenLarge(
                solverClient: _solverClient,
                puzzleType: _puzzleType,
                initialPuzzleData: _initialPuzzleData,
                puzzleSize: _puzzleSize,
                riveController: _riveController,
              ),
              mediumChild: PhotoScreenMedium(
                solverClient: _solverClient,
                initialPuzzleData: _initialPuzzleData,
                puzzleSize: _puzzleSize,
                puzzleType: _puzzleType,
                riveController: _riveController,
              ),
              smallChild: PhotoScreenSmall(
                solverClient: _solverClient,
                initialPuzzleData: _initialPuzzleData,
                puzzleSize: _puzzleSize,
                puzzleType: _puzzleType,
                riveController: _riveController,
              ),
            ),
          ),
          complete: (image, images, palette) {
            _themeData = Theme.of(context).copyWith(
              colorScheme: ColorScheme(
                brightness: Theme.of(context).brightness,
                primary: palette.vibrantColor?.color ?? Palette.blue,
                onPrimary: palette.lightVibrantColor?.color ?? Colors.white,
                secondary: Theme.of(context).colorScheme.secondary,
                onSecondary: Theme.of(context).colorScheme.onSecondary,
                error: Theme.of(context).colorScheme.error,
                onError: Theme.of(context).colorScheme.onError,
                surface: Theme.of(context).colorScheme.surface,
                onSurface: Theme.of(context).colorScheme.onSurface,
              ),
            );
            return Theme(
              data: _themeData,
              child: ResponsiveLayout(
                largeChild: PhotoScreenLarge(
                  solverClient: _solverClient,
                  puzzleType: _puzzleType,
                  initialPuzzleData: _initialPuzzleData,
                  puzzleSize: _puzzleSize,
                  riveController: _riveController,
                ),
                mediumChild: PhotoScreenMedium(
                  solverClient: _solverClient,
                  initialPuzzleData: _initialPuzzleData,
                  puzzleSize: _puzzleSize,
                  puzzleType: _puzzleType,
                  riveController: _riveController,
                ),
                smallChild: PhotoScreenSmall(
                  solverClient: _solverClient,
                  initialPuzzleData: _initialPuzzleData,
                  puzzleSize: _puzzleSize,
                  puzzleType: _puzzleType,
                  riveController: _riveController,
                ),
              ),
            );
          },
          orElse: () => Theme(
            data: _themeData,
            child: ResponsiveLayout(
              largeChild: PhotoScreenLarge(
                solverClient: _solverClient,
                puzzleType: _puzzleType,
                initialPuzzleData: _initialPuzzleData,
                puzzleSize: _puzzleSize,
                riveController: _riveController,
              ),
              mediumChild: PhotoScreenMedium(
                solverClient: _solverClient,
                initialPuzzleData: _initialPuzzleData,
                puzzleSize: _puzzleSize,
                puzzleType: _puzzleType,
                riveController: _riveController,
              ),
              smallChild: PhotoScreenSmall(
                solverClient: _solverClient,
                initialPuzzleData: _initialPuzzleData,
                puzzleSize: _puzzleSize,
                puzzleType: _puzzleType,
                riveController: _riveController,
              ),
            ),
          ),
        );
      },
    );
  }
}
