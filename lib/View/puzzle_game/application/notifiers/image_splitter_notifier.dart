import 'dart:developer';

import 'package:autism_empowering/View/puzzle_game/application/states/image_splitter_state.dart';
import 'package:autism_empowering/View/puzzle_game/res/strings.dart';
import 'package:autism_empowering/View/puzzle_game/utils/image_splitter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageSplitterNotifier extends StateNotifier<ImageSplitterState> {
  final ImageSplitter _splitter;

  ImageSplitterNotifier(this._splitter) : super(const ImageSplitterState());

  getInitialImages({required int puzzleSize}) async {
    state = const ImageSplitterState.generating();

    try {
      final data = await rootBundle.load(defaultImagePath);
      final imageBytes = data.buffer.asUint8List();
      final splitter = ImageSplitter();

      final palette =
          await splitter.getImagePalette(const AssetImage(defaultImagePath));
      final images = await splitter.runSplitterIsolate(imageBytes, puzzleSize);

      state = ImageSplitterState.complete(
          Image.asset(defaultImagePath), images, palette);
    } catch (e) {
      state = ImageSplitterState.error(message: e.toString());
    }
  }

  generateImages({required ImagePicker picker, required int puzzleSize}) async {
    state = const ImageSplitterState.generating();

    try {
      final imageBytesPalette = await _splitter.getImage(picker: picker);

      if (imageBytesPalette != null) {
        final image = imageBytesPalette.item1;
        final imageBytes = imageBytesPalette.item2;
        final palette = imageBytesPalette.item3;
        log('Image tuple retrieved');
        final images =
            await _splitter.runSplitterIsolate(imageBytes, puzzleSize);
        state = ImageSplitterState.complete(image, images, palette);
      }
    } catch (e) {
      debugPrint('Error: $e');
      state = ImageSplitterState.error(message: e.toString());
    }
  }
}
