import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;

// Sample audio URLs for testing
final sampleUrls = [
  "https://storage-dev.ahaspeak.app/quizzes/phrase/uNafC98sv54JO1BTx1Cx.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/GOmSd6xgbllAGKKgsz0y.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/xyqmTqIzXDE3gAJHr41G.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/xLiTuAfF8Uon3T4gR2DT.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/4VfO0K7nz7ZgqOs7stYk.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/pI5CwxtAcjvgvJyhTpDN.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/4VfO0K7nz7ZgqOs7stYk.mp3",
  "https://storage-dev.ahaspeak.app/quizzes/vocab/aoede/XuqiigA9iPDJP5bfugtQ.mp3"
];

// Media Kit Provider
final mediaKitPlayerProvider = Provider<Player>((ref) {
  final player = Player();
  ref.onDispose(() {
    player.dispose();
  });
  player.setVolume(150);
  return player;
});

// AudioPlayers Provider
final audioPlayersProvider = Provider<audio_players.AudioPlayer>((ref) {
  final player = audio_players.AudioPlayer();

  return player;
});
