import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _tickTimer;

  TimerBloc() : super(TimerState.initial()) {
    on<TimerSetDuration>(_onSetDuration);
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerStopped>(_onStopped);
    on<TimerTicked>(_onTicked);
  }

  void _onSetDuration(TimerSetDuration event, Emitter<TimerState> emit) {
    _cancelTimer();
    emit(
      TimerState(
        initial: event.duration,
        remaining: event.duration,
        status: TimerStatus.idle,
      ),
    );
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    if (state.remaining.inSeconds <= 0) {
      emit(state.copyWith(status: TimerStatus.finished));
      return;
    }

    _cancelTimer();
    emit(state.copyWith(status: TimerStatus.running));

    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerTicked());
    });
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (state.status != TimerStatus.running) return;

    final newRemaining = state.remaining - const Duration(seconds: 1);
    if (newRemaining.inSeconds <= 0) {
      _cancelTimer();
      emit(
        state.copyWith(remaining: Duration.zero, status: TimerStatus.finished),
      );
    } else {
      emit(state.copyWith(remaining: newRemaining));
    }
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    _cancelTimer();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    emit(state.copyWith(status: TimerStatus.running));
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerTicked());
    });
  }

  void _onStopped(TimerStopped event, Emitter<TimerState> emit) {
    _cancelTimer();
    emit(TimerState.initial());
  }

  void _cancelTimer() {
    _tickTimer?.cancel();
    _tickTimer = null;
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
