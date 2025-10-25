import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _tickTimer;
  Timer? _startingTimer;

  TimerBloc() : super(TimerState.initial()) {
    on<TimerSetDuration>(_onSetDuration);
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerRestarted>(_onRestarted);
    on<TimerTicked>(_onTicked);
    on<TimerStartingCountdownTicked>(_onStartingCountdownTicked);
  }

  void _onSetDuration(TimerSetDuration event, Emitter<TimerState> emit) {
    _cancelAll();
    emit(
      TimerState(
        initial: event.duration,
        remaining: event.duration,
        status: TimerStatus.idle,
        startingSecondsLeft: 0,
      ),
    );
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    if (state.remaining.inSeconds <= 0) {
      emit(state.copyWith(status: TimerStatus.finished));
      return;
    }

    _cancelAll();
    emit(state.copyWith(status: TimerStatus.starting, startingSecondsLeft: 3));

    _startingTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      add(TimerStartingCountdownTicked());
    });
  }

  void _onStartingCountdownTicked(
    TimerStartingCountdownTicked event,
    Emitter<TimerState> emit,
  ) {
    final next = state.startingSecondsLeft - 1;
    if (next <= 0) {
      _startingTimer?.cancel();
      _startingTimer = null;
      _beginCountdown(emit);
    } else {
      emit(state.copyWith(startingSecondsLeft: next));
    }
  }

  void _beginCountdown(Emitter<TimerState> emit) {
    emit(state.copyWith(status: TimerStatus.running));

    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerTicked());
    });
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (state.status != TimerStatus.running) return;

    final newRemaining = state.remaining - const Duration(seconds: 1);
    if (newRemaining.inSeconds <= 0) {
      _cancelAll();
      emit(
        state.copyWith(remaining: Duration.zero, status: TimerStatus.finished),
      );
    } else {
      emit(state.copyWith(remaining: newRemaining));
    }
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    _tickTimer?.cancel();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    _beginCountdown(emit);
  }

  void _onRestarted(TimerRestarted event, Emitter<TimerState> emit) {
    _cancelAll();
    emit(state.copyWith(remaining: state.initial));
    add(TimerStarted());
  }

  void _cancelAll() {
    _tickTimer?.cancel();
    _startingTimer?.cancel();
    _tickTimer = null;
    _startingTimer = null;
  }

  @override
  Future<void> close() {
    _cancelAll();
    return super.close();
  }
}
