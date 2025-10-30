import 'package:equatable/equatable.dart';

enum TimerStatus { idle, running, paused, finished }

class TimerState extends Equatable {
  final Duration initial;
  final Duration remaining;
  final TimerStatus status;

  const TimerState({
    required this.initial,
    required this.remaining,
    required this.status,
  });

  factory TimerState.initial() => const TimerState(
    initial: Duration(seconds: 45),
    remaining: Duration(seconds: 45),
    status: TimerStatus.idle,
  );

  TimerState copyWith({
    Duration? initial,
    Duration? remaining,
    TimerStatus? status,
  }) {
    return TimerState(
      initial: initial ?? this.initial,
      remaining: remaining ?? this.remaining,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [initial, remaining, status];
}
