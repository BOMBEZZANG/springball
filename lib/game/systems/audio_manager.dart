import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  // Singleton implementation
  static AudioManager? _instance;
  
  factory AudioManager() {
    _instance ??= AudioManager._internal();
    return _instance!;
  }
  
  AudioManager._internal() {
    _initialize();
  }

  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _initialized = false;

  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;

  void _initialize() {
    if (_initialized) return;
    
    // Initialize audio system
    debugPrint('AudioManager initialized');
    _initialized = true;
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    debugPrint('Sound ${enabled ? 'enabled' : 'disabled'}');
  }

  void setHapticEnabled(bool enabled) {
    _hapticEnabled = enabled;
    debugPrint('Haptic feedback ${enabled ? 'enabled' : 'disabled'}');
  }

  // Sound effect methods
  void playSound(SoundEffect sound) {
    if (!_soundEnabled || !_initialized) return;
    
    try {
      // In a full implementation, you would use packages like:
      // - audioplayers
      // - just_audio
      // - flutter_sound
      debugPrint('Playing sound: ${sound.name}');
      
      // For now, we'll use system sounds as placeholder
      switch (sound) {
        case SoundEffect.ballBounce:
        case SoundEffect.obstacleRotate:
          SystemSound.play(SystemSoundType.click);
          break;
        case SoundEffect.levelComplete:
          // Could play a success sound
          break;
        case SoundEffect.levelFailed:
        case SoundEffect.lavaContact:
          SystemSound.play(SystemSoundType.alert);
          break;
        case SoundEffect.ballDrop:
        case SoundEffect.trampolineBounce:
        case SoundEffect.magnetAttract:
        case SoundEffect.iceSlide:
          SystemSound.play(SystemSoundType.click);
          break;
      }
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void playHaptic(HapticEffect effect) {
    if (!_hapticEnabled) return;
    
    try {
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
        case HapticEffect.vibrate:
          HapticFeedback.vibrate();
          break;
      }
    } catch (e) {
      debugPrint('Error playing haptic: $e');
    }
  }

  // Convenience methods for common game events
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
    playHaptic(HapticEffect.light);
  }

  void playTrampolineBounce() {
    playSound(SoundEffect.trampolineBounce);
    playHaptic(HapticEffect.medium);
  }

  void playLavaContact() {
    playSound(SoundEffect.lavaContact);
    playHaptic(HapticEffect.heavy);
  }

  void playMagnetAttract() {
    playSound(SoundEffect.magnetAttract);
  }

  void playIceSlide() {
    playSound(SoundEffect.iceSlide);
  }

  // Cleanup method
  void dispose() {
    // Clean up audio resources if needed
    debugPrint('AudioManager disposed');
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
  vibrate,
}