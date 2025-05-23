import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import '../providers/audio_providers.dart';

class SourceComparisonScreen extends ConsumerWidget {
  const SourceComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaKitPlayer = ref.watch(mediaKitPlayerProvider);
    final audioPlayersPlayer = ref.watch(audioPlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Source Comparison'),
      ),
      body: Column(
        children: [
          // // MediaKit Player
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Column(
          //       children: [
          //         const Text('MediaKit Player'),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             IconButton(
          //               icon: const Icon(Icons.play_arrow),
          //               onPressed: () async {
          //                 final url = sampleUrls[currentUrlIndex];
          //                 final media = Media(url);
          //                 await mediaKitPlayer.open(media);
          //                 await mediaKitPlayer
          //                     .setPlaylistMode(PlaylistMode.none);
          //                 await mediaKitPlayer.play();
          //               },
          //             ),
          //             IconButton(
          //               icon: const Icon(Icons.pause),
          //               onPressed: () => mediaKitPlayer.pause(),
          //             ),
          //             IconButton(
          //               icon: const Icon(Icons.stop),
          //               onPressed: () => mediaKitPlayer.stop(),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // // AudioPlayers
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Column(
          //       children: [
          //         const Text('AudioPlayers'),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             IconButton(
          //               icon: const Icon(Icons.play_arrow),
          //               onPressed: () async {
          //                 final url = sampleUrls[currentUrlIndex];
          //                 await audioPlayersPlayer.setSource(
          //                   audio_players.UrlSource(url),
          //                 );
          //                 await audioPlayersPlayer.play();
          //               },
          //             ),
          //             IconButton(
          //               icon: const Icon(Icons.pause),
          //               onPressed: () => audioPlayersPlayer.pause(),
          //             ),
          //             IconButton(
          //               icon: const Icon(Icons.stop),
          //               onPressed: () => audioPlayersPlayer.stop(),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // // URL Navigation
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       icon: const Icon(Icons.arrow_back),
          //       onPressed: currentUrlIndex > 0
          //           ? () => ref.read(currentUrlIndexProvider.notifier).state =
          //               currentUrlIndex - 1
          //           : null,
          //     ),
          //     Text('URL ${currentUrlIndex + 1}/${sampleUrls.length}'),
          //     IconButton(
          //       icon: const Icon(Icons.arrow_forward),
          //       onPressed: currentUrlIndex < sampleUrls.length - 1
          //           ? () => ref.read(currentUrlIndexProvider.notifier).state =
          //               currentUrlIndex + 1
          //           : null,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
