import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

class TimerStarted extends TimerEvent {}

class TimerPaused extends TimerEvent {}

class TimerResumed extends TimerEvent {}

class TimerRestarted extends TimerEvent {}

class TimerTicked extends TimerEvent {}

class TimerSetDuration extends TimerEvent {
  final Duration duration;
  const TimerSetDuration(this.duration);

  @override
  List<Object?> get props => [duration];
}

class TimerStartingCountdownTicked extends TimerEvent {}
