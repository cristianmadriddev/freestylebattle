import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/get_training_words_use_case.dart';
import '../../domain/training_repository.dart';
import 'training_page_event.dart';
import 'traning_page_state.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final GetTrainingWordsUseCase _trainingWordsUseCase;

  Timer? _mainTimer;
  Timer? _countdownTimer;
  List<String> _words = [];
  bool _isPaused = false;
  final Random _random = Random();

  Duration _duration = const Duration(seconds: 45);
  Duration _remaining = const Duration(seconds: 45);

  TrainingBloc(this._trainingWordsUseCase)
    : super(const TrainingState.initial()) {
    on<TrainingLevelSelectedEvent>(_onLevelSelected);
    on<TrainingSetDurationEvent>(_onSetDuration);
    on<TrainingStartedEvent>(_onStarted);
    on<TrainingPausedEvent>(_onPaused);
    on<TrainingResumedEvent>(_onResumed);
    on<TrainingNextGroupEvent>(_onNextGroup);
    on<TrainingTickEvent>(_onTick);
    on<TrainingStoppedEvent>(_onStopped);
  }

  Future<void> _onLevelSelected(
    TrainingLevelSelectedEvent event,
    Emitter<TrainingState> emit,
  ) async {
    if (state.isRunning) return;
    emit(state.copyWith(isLoading: true));
    try {
      final words = await _trainingWordsUseCase(event.level);
      _words = List<String>.from(words);
      emit(
        state.copyWith(
          level: event.level,
          words: _words.take(state.numberOfWords()).toList(),
          isLoading: false,
          remainingSeconds: _duration.inSeconds,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSetDuration(
    TrainingSetDurationEvent event,
    Emitter<TrainingState> emit,
  ) {
    _resetTimers();
    _duration = event.duration;
    _remaining = event.duration;
    emit(state.copyWith(duration: _duration));
  }

  void _onStarted(TrainingStartedEvent event, Emitter<TrainingState> emit) {
    _resetTimers();
    final shuffled = List<String>.from(_words)..shuffle(_random);
    emit(
      state.copyWith(
        words: shuffled.take(state.numberOfWords()).toList(),
        isRunning: true,
        isPaused: false,
        remainingSeconds: _duration.inSeconds,
      ),
    );
    _startCountdown(emit);
  }

  void _onPaused(TrainingPausedEvent event, Emitter<TrainingState> emit) {
    _isPaused = true;
    _countdownTimer?.cancel();
    _mainTimer?.cancel();
    emit(state.copyWith(isPaused: true, isRunning: false));
  }

  void _onResumed(TrainingResumedEvent event, Emitter<TrainingState> emit) {
    if (_isPaused) {
      _isPaused = false;
      emit(state.copyWith(isPaused: false, isRunning: true));
      _startCountdown(emit);
    }
  }

  void _onStopped(TrainingStoppedEvent event, Emitter<TrainingState> emit) {
    _resetTimers();
    _remaining = _duration;
    emit(
      state.copyWith(
        isRunning: false,
        isPaused: false,
        remainingSeconds: _duration.inSeconds,
      ),
    );
  }

  void _onNextGroup(TrainingNextGroupEvent event, Emitter<TrainingState> emit) {
    final shuffled = List<String>.from(_words)..shuffle(_random);
    _remaining = _duration;
    emit(
      state.copyWith(
        words: shuffled.take(state.numberOfWords()).toList(),
        remainingSeconds: _remaining.inSeconds,
      ),
    );
  }

  void _onTick(TrainingTickEvent event, Emitter<TrainingState> emit) {
    if (_isPaused || !state.isRunning) return;
    if (_remaining.inSeconds > 0) {
      _remaining -= const Duration(seconds: 1);
      emit(state.copyWith(remainingSeconds: _remaining.inSeconds));
    } else {
      add(TrainingNextGroupEvent());
    }
  }

  void _startCountdown(Emitter<TrainingState> emit) {
    _countdownTimer?.cancel();
    _mainTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TrainingTickEvent());
    });

    _mainTimer = Timer(_duration, () {
      add(TrainingNextGroupEvent());
    });
  }

  void _resetTimers() {
    _mainTimer?.cancel();
    _countdownTimer?.cancel();
  }

  @override
  Future<void> close() {
    _resetTimers();
    return super.close();
  }
}

extension TrainingStateX on TrainingState {
  int numberOfWords() {
    switch (level) {
      case TrainingLevel.facil:
        return 3;
      case TrainingLevel.medio:
        return 5;
      case TrainingLevel.dificil:
        return 8;
    }
  }
}
