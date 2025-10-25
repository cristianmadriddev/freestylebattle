import 'package:equatable/equatable.dart';

enum TimerStatus { idle, starting, running, paused, finished }

class TimerState extends Equatable {
  final Duration initial;
  final Duration remaining;
  final TimerStatus status;
  final int startingSecondsLeft;

  const TimerState({
    required this.initial,
    required this.remaining,
    required this.status,
    required this.startingSecondsLeft,
  });

  factory TimerState.initial() => const TimerState(
    initial: Duration(minutes: 1),
    remaining: Duration(minutes: 1),
    status: TimerStatus.idle,
    startingSecondsLeft: 0,
  );

  TimerState copyWith({
    Duration? initial,
    Duration? remaining,
    TimerStatus? status,
    int? startingSecondsLeft,
  }) {
    return TimerState(
      initial: initial ?? this.initial,
      remaining: remaining ?? this.remaining,
      status: status ?? this.status,
      startingSecondsLeft: startingSecondsLeft ?? this.startingSecondsLeft,
    );
  }

  @override
  List<Object?> get props => [initial, remaining, status, startingSecondsLeft];
}
