import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerService {
  late AudioPlayer instance;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  // Properties
  Duration? _duration;
  Duration? _position;
  bool _isPlaying = false;

  // Getters
  Duration? get duration => _duration;
  Duration? get position => _position;
  bool get isPlaying => _isPlaying;
  Stream<PlayerState> get playerStateStream => instance.playerStateStream;

  AudioPlayerService() {
    instance = AudioPlayer();
    _initStreams();
  }

  void _initStreams() {
    // Duration stream
    _durationSubscription = instance.durationStream.listen(
      (duration) {
        _duration = duration;
      },
    );

    // Position stream
    _positionSubscription = instance.positionStream.listen(
      (position) {
        _position = position;
      },
    );

    // Player state stream
    _playerStateSubscription = instance.playerStateStream.listen(
      (state) {
        _isPlaying = state.playing;
        if (state.processingState == ProcessingState.completed) {
          instance.pause();
          instance.seek(Duration.zero);
          tempFile?.delete();
          tempFile = null;
        }
      },
    );
  }

  File? tempFile;
  Future<File> createTempFile(
    String base64String, {
    String extension = 'mp3',
  }) async {
    // Decode base64 string to bytes
    final bytes = base64Decode(base64String);
    // Create a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_audio.$extension');
    // Write bytes to temporary file
    await tempFile.writeAsBytes(bytes);
    debugPrint('Created temp file: ${tempFile.path}');
    return tempFile;
  }

  Future<void> playFromBase64(
    String base64String, {
    String extension = 'mp3',
  }) async {
    try {
      if (tempFile == null) {
        tempFile = await createTempFile(base64String, extension: extension);
        await instance.setFilePath(tempFile?.path ?? '');
      }
      await instance.play();
    } catch (e) {
      debugPrint('Error playing base64 audio: $e');
      throw Exception('Failed to play base64 audio');
    }
  }

  Future<void> playFromFile(String filePath) async {
    try {
      await instance.setFilePath(filePath);
      await instance.play();
    } catch (e) {
      throw Exception('Failed to play audio');
    }
  }

  Future<void> pause() async {
    try {
      await instance.pause();
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  /// Resume playing
  Future<void> resume(double seek) async {
    try {
      await instance.play();
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }

  /// Stop the audio
  Future<void> stop() async {
    try {
      await instance.stop();
      _position = Duration.zero;
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  /// Seek to specific position
  Future<void> setSeek(double seek) async {
    try {
      await instance.seek(Duration(seconds: seek.toInt()));
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  /// Set playback speed
  Future<void> setSpeed(double speed) async {
    try {
      await instance.setSpeed(speed);
    } catch (e) {
      debugPrint('Error setting speed: $e');
    }
  }

  /// Dispose the player and clean up resources
  Future<void> dispose() async {
    await _durationSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await instance.dispose();
  }
}
