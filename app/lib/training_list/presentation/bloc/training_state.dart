import 'package:equatable/equatable.dart';

abstract class TrainingState extends Equatable {
  const TrainingState();

  @override
  List<Object?> get props => [];
}

class TrainingInitial extends TrainingState {
  const TrainingInitial();
}

class TrainingCountdown extends TrainingState {
  final int countdown;
  final String message;
  const TrainingCountdown({required this.countdown, required this.message});

  @override
  List<Object?> get props => [countdown, message];
}

class TrainingRunning extends TrainingState {
  final List<String> words;
  final int remainingSeconds;
  final String formattedTime;
  final int round;

  const TrainingRunning({
    required this.words,
    required this.remainingSeconds,
    required this.formattedTime,
    required this.round,
  });

  @override
  List<Object?> get props => [words, remainingSeconds, formattedTime, round];
}

class TrainingPaused extends TrainingState {
  final int remainingSeconds;
  final String formattedTime;
  const TrainingPaused({
    required this.remainingSeconds,
    required this.formattedTime,
  });

  @override
  List<Object?> get props => [remainingSeconds, formattedTime];
}

class TrainingFinished extends TrainingState {
  const TrainingFinished();
}
