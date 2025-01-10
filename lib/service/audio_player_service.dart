import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  Duration duration = Duration.zero;
  String? currentUrl; // To track the currently playing URL

  factory AudioPlayerService() {
    return _instance;
  }

  AudioPlayerService._internal() {
    _audioPlayer.onDurationChanged.listen((d) {
      duration = d;
    });
    _audioPlayer.onPositionChanged.listen((p) {
      _positionController.add(p);
    });
  }

  Future<void> play(String url) async {
    currentUrl = url; // Update the current URL
    await _audioPlayer.setSource(AssetSource(url));
    await _audioPlayer.resume();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _positionController.add(Duration.zero);
    currentUrl = null; // Reset current URL
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Stream<Duration> get positionStream => _positionController.stream;

  Duration get durationStream => duration;

  void dispose() {
    _positionController.close();
  }
}
