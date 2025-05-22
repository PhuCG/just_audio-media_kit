import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_kit/media_kit.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import '../providers/audio_providers.dart';

class UrlComparisonScreen extends ConsumerStatefulWidget {
  const UrlComparisonScreen({super.key});

  @override
  ConsumerState<UrlComparisonScreen> createState() =>
      _UrlComparisonScreenState();
}

class _UrlComparisonScreenState extends ConsumerState<UrlComparisonScreen> {
  DateTime? justAudioStartTime;
  DateTime? mediaKitStartTime;
  DateTime? audioPlayersStartTime;

  // Stream subscriptions
  StreamSubscription<ProcessingState>? _justAudioStateSubscription;
  StreamSubscription<bool>? _mediaKitPlayingSubscription;
  StreamSubscription<String>? _mediaKitErrorSubscription;
  StreamSubscription<audio_players.PlayerState>? _audioPlayersStateSubscription;

  @override
  void initState() {
    super.initState();
    _setupJustAudioListener();
    _setupMediaKitListener();
    _setupAudioPlayersListener();
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions
    _justAudioStateSubscription?.cancel();
    _mediaKitPlayingSubscription?.cancel();
    _mediaKitErrorSubscription?.cancel();
    _audioPlayersStateSubscription?.cancel();
    super.dispose();
  }

  void _setupJustAudioListener() {
    final player = ref.read(justAudioPlayerProvider);
    _justAudioStateSubscription = player.processingStateStream.listen((state) {
      ref.read(justAudioProcessingStateProvider.notifier).state = state;

      if (state == ProcessingState.idle) {
        ref.read(justAudioLoadingTimeProvider.notifier).state = 'Loading...';
      } else if (state == ProcessingState.ready && justAudioStartTime != null) {
        final duration = DateTime.now().difference(justAudioStartTime!);
        ref.read(justAudioLoadingTimeProvider.notifier).state =
            'Loaded in ${duration.inMilliseconds}ms';
      }
    });
  }

  void _setupMediaKitListener() {
    final player = ref.read(mediaKitPlayerProvider);
    final errorStream = player.stream.error;

    _mediaKitPlayingSubscription = player.stream.playing.listen((isPlaying) {
      print('[log] MediaKit isPlaying: $isPlaying');
      if (isPlaying) {
        final duration = DateTime.now().difference(mediaKitStartTime!);
        ref.read(mediaKitLoadingTimeProvider.notifier).state =
            'Loaded in ${duration.inMilliseconds}ms';
      }
    });

    _mediaKitErrorSubscription = errorStream.listen((error) {
      if (error.isNotEmpty) {
        print('[log] MediaKit Error: $error');
        ref.read(mediaKitLoadingTimeProvider.notifier).state = 'Error: $error';
      }
    });
  }

  void _setupAudioPlayersListener() {
    final player = ref.read(audioPlayersProvider);

    _audioPlayersStateSubscription =
        player.onPlayerStateChanged.listen((state) {
      if (state == audio_players.PlayerState.playing &&
          audioPlayersStartTime != null) {
        final duration = DateTime.now().difference(audioPlayersStartTime!);
        ref.read(audioPlayersLoadingTimeProvider.notifier).state =
            'Loaded in ${duration.inMilliseconds}ms';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final justAudioPlayer = ref.watch(justAudioPlayerProvider);
    final mediaKitPlayer = ref.watch(mediaKitPlayerProvider);
    final audioPlayers = ref.watch(audioPlayersProvider);
    final justAudioLoadingTime = ref.watch(justAudioLoadingTimeProvider);
    final mediaKitLoadingTime = ref.watch(mediaKitLoadingTimeProvider);
    final audioPlayersLoadingTime = ref.watch(audioPlayersLoadingTimeProvider);
    final justAudioState = ref.watch(justAudioProcessingStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('URL Playback Comparison')),
      body: Column(
        children: [
          // Just Audio Section
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Just Audio Player',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'State: ${justAudioState?.toString() ?? 'Unknown'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Loading Time: $justAudioLoadingTime',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      children: sampleUrls.map(
                        (url) {
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () async {
                              justAudioStartTime = DateTime.now();
                              ref
                                  .read(justAudioLoadingTimeProvider.notifier)
                                  .state = 'Loading...';
                              await justAudioPlayer.setUrl(url);
                              await justAudioPlayer.play();
                            },
                          );
                        },
                      ).toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Media Kit Section
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Media Kit Player',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Loading Time: $mediaKitLoadingTime',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      children: sampleUrls.map(
                        (url) {
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () async {
                              mediaKitStartTime = DateTime.now();
                              ref
                                  .read(mediaKitLoadingTimeProvider.notifier)
                                  .state = 'Loading...';
                              await mediaKitPlayer.open(Media(url));
                              mediaKitPlayer.play();
                            },
                          );
                        },
                      ).toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
          // AudioPlayers Section
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'AudioPlayers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Loading Time: $audioPlayersLoadingTime',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      children: sampleUrls.map(
                        (url) {
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () async {
                              audioPlayersStartTime = DateTime.now();
                              ref
                                  .read(
                                      audioPlayersLoadingTimeProvider.notifier)
                                  .state = 'Loading...';
                              await audioPlayers
                                  .play(audio_players.UrlSource(url));
                            },
                          );
                        },
                      ).toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class to represent MediaKit state
class _MediaKitState {
  final bool isBuffering;
  final bool isPlaying;

  _MediaKitState({
    required this.isBuffering,
    required this.isPlaying,
  });
}
