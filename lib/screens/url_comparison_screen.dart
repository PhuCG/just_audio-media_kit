import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import '../providers/audio_providers.dart';

class UrlComparisonScreen extends ConsumerWidget {
  const UrlComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final justAudioPlayer = ref.watch(justAudioPlayerProvider);
    final mediaKitPlayer = ref.watch(mediaKitPlayerProvider);
    final currentUrlIndex = ref.watch(currentUrlIndexProvider);

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
                    const SizedBox(height: 20),
                    Wrap(
                      children: sampleUrls.map(
                        (url) {
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () async {
                              await justAudioPlayer.setUrl(
                                url,
                              );
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
                    const SizedBox(height: 20),
                    Wrap(
                      children: sampleUrls.map(
                        (url) {
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () async {
                              await mediaKitPlayer.open(
                                Media(url),
                              );
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
