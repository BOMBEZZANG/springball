import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  bool _soundEnabled = true;
  bool _hapticEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    debugPrint('Sound ${enabled ? 'enabled' : 'disabled'}');
  }

  void setHapticEnabled(bool enabled) {
    _hapticEnabled = enabled;
    debugPrint('Haptic ${enabled ? 'enabled' : 'disabled'}');
  }

  void playSound(SoundEffect sound) {
    if (!_soundEnabled) return;
    
    // Placeholder for sound playing logic
    // In a real implementation, you would use packages like:
    // - flutter_audio_manager
    // - just_audio
    // - audioplayers
    debugPrint('Playing sound: $sound');
  }

  void playHaptic(HapticEffect effect) {
    if (!_hapticEnabled) return;
    
    switch (effect) {
      case HapticEffect.light:
        HapticFeedback.lightImpact();
        break;
      case HapticEffect.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticEffect.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticEffect.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  void playBallBounce() {
    playSound(SoundEffect.ballBounce);
    playHaptic(HapticEffect.light);
  }

  void playObstacleRotate() {
    playSound(SoundEffect.obstacleRotate);
    playHaptic(HapticEffect.selection);
  }

  void playLevelComplete() {
    playSound(SoundEffect.levelComplete);
    playHaptic(HapticEffect.heavy);
  }

  void playLevelFailed() {
    playSound(SoundEffect.levelFailed);
    playHaptic(HapticEffect.medium);
  }

  void playBallDrop() {
    playSound(SoundEffect.ballDrop);
  }

  void playTrampolineBounce() {
    playSound(SoundEffect.trampolineBounce);
    playHaptic(HapticEffect.medium);
  }

  void playLavaContact() {
    playSound(SoundEffect.lavaContact);
    playHaptic(HapticEffect.heavy);
  }
}

enum SoundEffect {
  ballBounce,
  obstacleRotate,
  levelComplete,
  levelFailed,
  ballDrop,
  trampolineBounce,
  lavaContact,
  magnetAttract,
  iceSlide,
}

enum HapticEffect {
  light,
  medium,
  heavy,
  selection,
}