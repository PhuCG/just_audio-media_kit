import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  var startTimeMediaKit = DateTime.now();
  var startTimeAudioPlayers = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final mediaKitPlayer = ref.watch(mediaKitPlayerProvider);
    final audioPlayersPlayer = ref.watch(audioPlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Comparison'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // MediaKit Player
            Column(
              children: [
                const Text('MediaKit Player'),
                Consumer(
                  builder: (context, ref, child) {
                    var loadingTime = '';
                    var endTime = '';
                    mediaKitPlayer.stream.playing.listen((state) {
                      if (state == true) {
                        loadingTime =
                            '${DateTime.now().difference(startTimeMediaKit).inMilliseconds}ms';

                        log('[log] MediaKit Load $loadingTime');
                      }
                    });
                    mediaKitPlayer.stream.completed.listen((state) {
                      if (state == true) {
                        endTime =
                            '${DateTime.now().difference(startTimeMediaKit).inMilliseconds}ms';

                        log('[log] MediaKit End $endTime');
                      }
                    });
                    return Column(
                      children: [
                        Text('Loading Time: $loadingTime'),
                        Text('End Time: $endTime'),
                      ],
                    );
                  },
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: sampleUrls.map(
                    (url) {
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () async {
                          startTimeMediaKit = DateTime.now();
                          await mediaKitPlayer.open(Media(url));
                          await mediaKitPlayer.play();
                        },
                      );
                    },
                  ).toList(),
                ),
              ],
            ),

            const SizedBox(height: 100),
            // AudioPlayers
            Column(
              children: [
                const Text('AudioPlayers'),
                Consumer(
                  builder: (context, ref, child) {
                    var loadingTime = '';
                    var endTime = '';
                    audioPlayersPlayer.onPlayerStateChanged.listen((state) {
                      if (state == audio_players.PlayerState.playing) {
                        loadingTime =
                            '${DateTime.now().difference(startTimeAudioPlayers).inMilliseconds}ms';
                        log('[log] AudioPlayers Load $loadingTime');
                      } else if (state == audio_players.PlayerState.completed) {
                        endTime =
                            '${DateTime.now().difference(startTimeAudioPlayers).inMilliseconds}ms';
                        log('[log] AudioPlayers End $endTime');
                      }
                    });
                    return Column(
                      children: [
                        Text('Loading Time: $loadingTime'),
                        Text('End Time: $endTime'),
                      ],
                    );
                  },
                ),
                Wrap(
                  children: sampleUrls.map(
                    (url) {
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () async {
                          startTimeAudioPlayers = DateTime.now();
                          await audioPlayersPlayer.play(
                            audio_players.UrlSource(url),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
