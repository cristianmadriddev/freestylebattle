import '../../domain/training_repository.dart';

class TrainingState {
  final List<String> words;
  final bool isRunning;
  final bool isPaused;
  final bool isLoading;
  final Duration duration;
  final int remainingSeconds;
  final TrainingLevel level;
  final String? error;

  const TrainingState({
    required this.words,
    required this.isRunning,
    required this.isPaused,
    required this.isLoading,
    required this.duration,
    required this.remainingSeconds,
    required this.level,
    this.error,
  });

  const TrainingState.initial()
    : words = const [],
      isRunning = false,
      isPaused = false,
      isLoading = false,
      duration = const Duration(seconds: 45),
      remainingSeconds = 45,
      level = TrainingLevel.facil,
      error = null;

  TrainingState copyWith({
    List<String>? words,
    bool? isRunning,
    bool? isPaused,
    bool? isLoading,
    Duration? duration,
    int? remainingSeconds,
    TrainingLevel? level,
    String? error,
  }) {
    return TrainingState(
      words: words ?? this.words,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      isLoading: isLoading ?? this.isLoading,
      duration: duration ?? this.duration,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      level: level ?? this.level,
      error: error ?? this.error,
    );
  }
}
