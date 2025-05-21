import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:media_kit/media_kit.dart';
import '../providers/audio_providers.dart';

class SourceComparisonScreen extends ConsumerWidget {
  const SourceComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final justAudioPlayer = ref.watch(justAudioPlayerProvider);
    final mediaKitPlayer = ref.watch(mediaKitPlayerProvider);
    final currentSource = ref.watch(currentAudioSourceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Audio Source Comparison')),
      body: Column(
        children: [
          // // Just Audio Section
          // Expanded(
          //   child: Card(
          //     margin: const EdgeInsets.all(8),
          //     child: Padding(
          //       padding: const EdgeInsets.all(16),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Text(
          //             'Just Audio Player',
          //             style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           const SizedBox(height: 20),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               IconButton(
          //                 icon: const Icon(Icons.play_arrow),
          //                 onPressed: () async {
          //                   if (currentSource != null) {
          //                     await justAudioPlayer.setAudioSource(
          //                       currentSource,
          //                     );
          //                     justAudioPlayer.play();
          //                   }
          //                 },
          //               ),
          //               IconButton(
          //                 icon: const Icon(Icons.pause),
          //                 onPressed: () => justAudioPlayer.pause(),
          //               ),
          //               IconButton(
          //                 icon: const Icon(Icons.stop),
          //                 onPressed: () => justAudioPlayer.stop(),
          //               ),
          //             ],
          //           ),
          //           const SizedBox(height: 10),
          //           Text('Current Source: ${currentSource?.uri ?? 'None'}'),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // // Media Kit Section
          // Expanded(
          //   child: Card(
          //     margin: const EdgeInsets.all(8),
          //     child: Padding(
          //       padding: const EdgeInsets.all(16),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Text(
          //             'Media Kit Player',
          //             style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           const SizedBox(height: 20),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               IconButton(
          //                 icon: const Icon(Icons.play_arrow),
          //                 onPressed: () async {
          //                   if (currentSource != null) {
          //                     await mediaKitPlayer.open(
          //                       Media(currentSource.uri),
          //                     );
          //                     mediaKitPlayer.play();
          //                   }
          //                 },
          //               ),
          //               IconButton(
          //                 icon: const Icon(Icons.pause),
          //                 onPressed: () => mediaKitPlayer.pause(),
          //               ),
          //               IconButton(
          //                 icon: const Icon(Icons.stop),
          //                 onPressed: () => mediaKitPlayer.stop(),
          //               ),
          //             ],
          //           ),
          //           const SizedBox(height: 10),
          //           Text('Current Source: ${currentSource?.uri ?? 'None'}'),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          // Source Selection
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Example: Create an audio source from a local file
                    final source = AudioSource.uri(
                      Uri.parse('asset:///assets/audio/sample.mp3'),
                    );
                    ref.read(currentAudioSourceProvider.notifier).state =
                        source;
                  },
                  child: const Text('Load Local Audio Source'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    // Example: Create an audio source from a network URL
                    final source = AudioSource.uri(
                      Uri.parse(
                        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                      ),
                    );
                    ref.read(currentAudioSourceProvider.notifier).state =
                        source;
                  },
                  child: const Text('Load Network Audio Source'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
