import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_kit/media_kit.dart';
import 'package:rxdart/rxdart.dart';
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

  @override
  void initState() {
    super.initState();
    _setupJustAudioListener();
    _setupMediaKitListener();
  }

  void _setupJustAudioListener() {
    final player = ref.read(justAudioPlayerProvider);
    player.processingStateStream.listen((state) {
      ref.read(justAudioProcessingStateProvider.notifier).state = state;

      if (state == ProcessingState.idle) {
        // justAudioStartTime = DateTime.now();
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

    // Create streams for each state we want to track
    // final bufferingStream = player.stream.buffering;
    // final playingStream = player.stream.playing;
    final errorStream = player.stream.error;

    player.stream.playing.listen((isPlaying) {
      print('[log] MediaKit isPlaying: $isPlaying');
      if (isPlaying) {
        final duration = DateTime.now().difference(mediaKitStartTime!);
        ref.read(mediaKitLoadingTimeProvider.notifier).state =
            'Loaded in ${duration.inMilliseconds}ms';
      }
    });
    // Combine buffering and playing states
    // Rx.combineLatest2(
    //   bufferingStream,
    //   playingStream,
    //   (bool isBuffering, bool isPlaying) => _MediaKitState(
    //     isBuffering: isBuffering,
    //     isPlaying: isPlaying,
    //   ),
    // ).listen((state) {
    //   print(
    //       '[log] MediaKit State: buffering=${state.isBuffering}, playing=${state.isPlaying}');

    //   if (state.isBuffering) {
    //     // mediaKitStartTime = DateTime.now();
    //     ref.read(mediaKitLoadingTimeProvider.notifier).state = 'Loading...';
    //   } else if (state.isPlaying && mediaKitStartTime != null) {}
    // });

    // Handle errors separately
    errorStream.listen((error) {
      if (error.isNotEmpty) {
        print('[log] MediaKit Error: $error');
        ref.read(mediaKitLoadingTimeProvider.notifier).state = 'Error: $error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final justAudioPlayer = ref.watch(justAudioPlayerProvider);
    final mediaKitPlayer = ref.watch(mediaKitPlayerProvider);
    final justAudioLoadingTime = ref.watch(justAudioLoadingTimeProvider);
    final mediaKitLoadingTime = ref.watch(mediaKitLoadingTimeProvider);
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
