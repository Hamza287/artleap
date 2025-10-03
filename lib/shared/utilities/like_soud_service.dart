// utils/sound_service.dart
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playLikeSound() async {
    try {
      await _player.play(AssetSource('sounds/like_sound.mp3'));
    } catch (e) {
      // Sound file not found, continue without sound
    }
  }

  static Future<void> playUnlikeSound() async {
    try {
      await _player.play(AssetSource('sounds/unlike_sound.mp3'));
    } catch (e) {
      // Sound file not found, continue without sound
    }
  }
}