import 'package:equatable/equatable.dart';

abstract class TrainingEvent extends Equatable {
  const TrainingEvent();

  @override
  List<Object?> get props => [];
}

class TrainingStartedEvent extends TrainingEvent {
  final Duration duration;
  const TrainingStartedEvent({required this.duration});
}

class TrainingNextRoundEvent extends TrainingEvent {
  const TrainingNextRoundEvent();
}

class TrainingTickEvent extends TrainingEvent {
  final int remaining;
  final List<String> words;
  final int round;
  const TrainingTickEvent({
    required this.remaining,
    required this.words,
    required this.round,
  });

  @override
  List<Object?> get props => [remaining, words, round];
}

class TrainingPausedEvent extends TrainingEvent {
  const TrainingPausedEvent();
}

class TrainingResumedEvent extends TrainingEvent {
  const TrainingResumedEvent();
}

class TrainingStoppedEvent extends TrainingEvent {
  const TrainingStoppedEvent();
}
