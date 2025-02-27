import 'package:autism_empowering/View/puzzle_game/application/states/image_splitter_state.dart';
import 'package:autism_empowering/View/puzzle_game/application/states/puzzle_state.dart';
import 'package:autism_empowering/View/puzzle_game/models/puzzle_data.dart';
import 'package:autism_empowering/View/puzzle_game/providers.dart';
import 'package:autism_empowering/View/puzzle_game/res/puzzle_constants.dart';
import 'package:autism_empowering/View/puzzle_game/screens/puzzle/top_bar.dart';
import 'package:autism_empowering/View/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/View/puzzle_game/widgets/photo_screen/image_viewer.dart';
import 'package:autism_empowering/View/puzzle_game/widgets/photo_screen/pick_image_button.dart';
import 'package:autism_empowering/View/puzzle_game/widgets/solo_screen/solo_screen_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:rive/rive.dart' as rive;

class PhotoScreenLarge extends ConsumerStatefulWidget {
  const PhotoScreenLarge({
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
  final rive.RiveAnimationController riveController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SoloScreenLargeState();
}

class _SoloScreenLargeState extends ConsumerState<PhotoScreenLarge> {
  late final PuzzleSolverClient _solverClient;
  late final int _puzzleSize;
  late final PuzzleData _initialPuzzleData;
  late final String _puzzleType;
  late final rive.RiveAnimationController _riveController;

  bool _isStartPressed = false;
  final _imagePicker = ImagePicker();

  List<Image>? _previousImages;
  Image? _previousImage;
  PaletteGenerator? _previousPalette;

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

    ref.listen(imageSplitterNotifierProvider, (previous, next) {
      if (next is ImageSplitterComplete) {
        setState(() {
          _previousImages = next.images;
          _previousImage = next.image;
          _previousPalette = next.palette;
        });
      }
    });

    var fontSize = 70.0;
    var boardSize = 450.0;

    var spacing = 5;
    var eachBoxSize = (boardSize / _puzzleSize) - (spacing * (_puzzleSize - 1));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 100),
        child: TopBar(
          puzzleSize: _puzzleSize,
          puzzleType: _puzzleType,
          color: Theme.of(context).colorScheme.surface,
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
                Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(imageSplitterNotifierProvider);

                    return state.maybeWhen(
                      () => PuzzleWidget(
                        solverClient: _solverClient,
                        boardSize: boardSize,
                        eachBoxSize: eachBoxSize,
                        initialPuzzleData: _initialPuzzleData,
                        fontSize: fontSize,
                        images: _previousImages,
                        kInitialSpeed: kInitialSpeed,
                      ),
                      complete: (image, images, palette) {
                        _previousImages = images;
                        _previousImage = image;
                        _previousPalette = palette;

                        return PuzzleWidget(
                          solverClient: _solverClient,
                          boardSize: boardSize,
                          eachBoxSize: eachBoxSize,
                          initialPuzzleData: _initialPuzzleData,
                          fontSize: fontSize,
                          images: images,
                          kInitialSpeed: kInitialSpeed,
                        );
                      },
                      orElse: () => PuzzleWidget(
                        solverClient: _solverClient,
                        boardSize: boardSize,
                        eachBoxSize: eachBoxSize,
                        initialPuzzleData: _initialPuzzleData,
                        fontSize: fontSize,
                        images: _previousImages,
                        kInitialSpeed: kInitialSpeed,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Stack(
            children: [
              AnimatedDash(
                boardSize: boardSize * 0.80,
                riveController: _riveController,
                onInit: (_) => setState(() {}),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  const Row(),
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
                  Visibility(
                    visible: !_isStartPressed,
                    child: Column(
                      children: [
                        ImageViewer(
                          imagePicker: _imagePicker,
                          puzzleSize: _puzzleSize,
                          previousImage: _previousImage,
                          previousPalette: _previousPalette,
                          imageSize: 200,
                        ),
                        PickImageButton(
                          text: 'Pick Image',
                          onTap: ref.read(imageSplitterNotifierProvider)
                                  is ImageSplitterComplete
                              ? () => ref
                                  .read(imageSplitterNotifierProvider.notifier)
                                  .generateImages(
                                    picker: _imagePicker,
                                    puzzleSize: _puzzleSize,
                                  )
                              : null,
                        ),
                      ],
                    ),
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
