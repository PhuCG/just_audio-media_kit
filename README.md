# Audio Player Comparison App

This Flutter application demonstrates a comparison between two popular audio player packages: `just_audio` and `media_kit`. The app allows you to compare their performance and features when playing audio from different sources.

## Features

1. URL Playback Comparison
   - Compare playback of audio from different URLs
   - Test switching between different audio sources
   - Compare loading times and playback performance

2. Audio Source Comparison
   - Compare playback of local and network audio sources
   - Test different audio source types
   - Compare loading and switching performance

## Setup

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Add a sample audio file to `assets/audio/sample.mp3`
4. Run the app using `flutter run`

## Usage

### URL Comparison Screen
- The screen is split into two sections: Just Audio Player and Media Kit Player
- Use the URL buttons at the bottom to switch between different audio URLs
- Compare the loading and playback performance between both players

### Source Comparison Screen
- Similar layout to the URL comparison screen
- Use the buttons at the bottom to load different types of audio sources
- Compare how each player handles different source types

## Dependencies

- flutter_riverpod: ^2.4.9
- just_audio: ^0.9.36
- media_kit: ^1.1.10
- media_kit_libs_audio: ^1.3.8

## Notes

- Make sure to add your own audio files to the assets directory
- The app uses sample URLs from soundhelix.com for testing
- Both players are properly disposed when the app is closed
#   j u s t _ a u d i o - m e d i a _ k i t  
 