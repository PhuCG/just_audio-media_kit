import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'package:media_kit/media_kit.dart';

// Sample audio URLs for testing
final sampleUrls = [
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/GOmSd6xgbllAGKKgsz0y.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/xyqmTqIzXDE3gAJHr41G.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/xLiTuAfF8Uon3T4gR2DT.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/4VfO0K7nz7ZgqOs7stYk.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/pI5CwxtAcjvgvJyhTpDN.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/4VfO0K7nz7ZgqOs7stYk.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/XuqiigA9iPDJP5bfugtQ.mp3"
];

// Just Audio Provider
final justAudioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() {
    player.dispose();
  });
  return player;
});

// Media Kit Provider
final mediaKitPlayerProvider = Provider<Player>((ref) {
  final player = Player();
  ref.onDispose(() {
    player.dispose();
  });
  return player;
});

// Provider for current URL index
final currentUrlIndexProvider = StateProvider<int>((ref) => 0);

// Provider for current audio source
final currentAudioSourceProvider = StateProvider<AudioSource?>((ref) => null);

// Provider for Just Audio loading time
final justAudioLoadingTimeProvider =
    StateProvider<String>((ref) => 'Not started');

// Provider for Media Kit loading time
final mediaKitLoadingTimeProvider =
    StateProvider<String>((ref) => 'Not started');

// Provider for Just Audio processing state
final justAudioProcessingStateProvider =
    StateProvider<ProcessingState?>((ref) => null);

// Provider for Media Kit processing state
final mediaKitProcessingStateProvider =
    StateProvider<PlayerState?>((ref) => null);
