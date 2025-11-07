import '../../domain/training_repository.dart';

abstract class TrainingEvent {}

class TrainingLevelSelectedEvent extends TrainingEvent {
  final TrainingLevel level;
  TrainingLevelSelectedEvent(this.level);
}

class TrainingSetDurationEvent extends TrainingEvent {
  final Duration duration;
  TrainingSetDurationEvent(this.duration);
}

class TrainingStartedEvent extends TrainingEvent {
  final Duration duration;
  TrainingStartedEvent(this.duration);
}

class TrainingPausedEvent extends TrainingEvent {}

class TrainingResumedEvent extends TrainingEvent {}

class TrainingStoppedEvent extends TrainingEvent {}

class TrainingNextGroupEvent extends TrainingEvent {}

class TrainingTickEvent extends TrainingEvent {}
