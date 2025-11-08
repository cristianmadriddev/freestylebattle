import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../beats/domain/beats_use_case.dart';
import '../../domain/entity/training_category.dart';
import 'training_event.dart';
import 'training_state.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final BeatsFromLocalAssetsUseCase beatsUseCase;
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;
  List<AssetSource> _beatPaths = [];
  int _currentBeatIndex = 0;

  final TrainingCategory category;
  final int totalRounds = 10;
  int _round = 0;
  Duration _roundDuration = const Duration(seconds: 20);
  final Set<String> _usedWords = {};

  TrainingBloc({required this.category, required this.beatsUseCase})
    : super(const TrainingInitial()) {
    on<TrainingStartedEvent>(_onStarted);
    on<TrainingNextRoundEvent>(_onNextRound);
    on<TrainingTickEvent>(_onTick);
    on<TrainingPausedEvent>(_onPaused);
    on<TrainingResumedEvent>(_onResumed);
    on<TrainingStoppedEvent>(_onStopped);
  }

  Future<void> _onStarted(
    TrainingStartedEvent event,
    Emitter<TrainingState> emit,
  ) async {
    _timer?.cancel();
    await _player.stop();

    _round = 0;
    _roundDuration = event.duration;
    _usedWords.clear();

    _beatPaths = beatsUseCase();
    _beatPaths.shuffle(Random());
    _currentBeatIndex = 0;

    final messages = [
      const TrainingCountdown(countdown: 3, message: "🎤 RIMAS EM 3..."),
      const TrainingCountdown(countdown: 2, message: "🎤 RIMAS EM 2..."),
      const TrainingCountdown(countdown: 1, message: "🎤 RIMAS EM 1..."),
      const TrainingCountdown(countdown: 0, message: "🔥 RIMA!"),
    ];

    for (final msg in messages) {
      if (emit.isDone) return;
      emit(msg);
      await Future.delayed(const Duration(seconds: 1));
    }

    await _startBeatPlayback();
    if (!emit.isDone) add(const TrainingNextRoundEvent());
  }

  Future<void> _onNextRound(
    TrainingNextRoundEvent event,
    Emitter<TrainingState> emit,
  ) async {
    if (_round >= totalRounds) {
      if (!emit.isDone) emit(const TrainingFinished());
      await _player.stop();
      return;
    }

    _round++;
    int remaining = _roundDuration.inSeconds;

    final rand = Random();
    final available =
        category.words.where((w) => !_usedWords.contains(w)).toList()
          ..shuffle(rand);

    if (available.isEmpty) _usedWords.clear();

    final words = available.take(4).toList();
    _usedWords.addAll(words);

    if (emit.isDone) return;
    emit(
      TrainingRunning(
        words: words,
        remainingSeconds: remaining,
        formattedTime: _formatDuration(remaining),
        round: _round,
      ),
    );

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      remaining--;
      if (remaining <= 0) {
        _timer?.cancel();
        await Future.delayed(const Duration(milliseconds: 100));
        if (!isClosed) add(const TrainingNextRoundEvent());
      } else {
        if (!isClosed) {
          add(
            TrainingTickEvent(
              remaining: remaining,
              words: words,
              round: _round,
            ),
          );
        }
      }
    });
  }

  void _onTick(TrainingTickEvent event, Emitter<TrainingState> emit) {
    emit(
      TrainingRunning(
        words: event.words,
        remainingSeconds: event.remaining,
        formattedTime: _formatDuration(event.remaining),
        round: event.round,
      ),
    );
  }

  Future<void> _startBeatPlayback() async {
    if (_beatPaths.isEmpty) return;

    await _player.play(_beatPaths[_currentBeatIndex]);
    _player.onPlayerComplete.listen((_) async {
      _currentBeatIndex = (_currentBeatIndex + 1) % _beatPaths.length;
      await _player.play(_beatPaths[_currentBeatIndex]);
    });
  }

  void _onPaused(TrainingPausedEvent event, Emitter<TrainingState> emit) {
    if (state is TrainingRunning) {
      _timer?.cancel();
      _player.pause();
      final s = state as TrainingRunning;
      emit(
        TrainingPaused(
          remainingSeconds: s.remainingSeconds,
          formattedTime: s.formattedTime,
        ),
      );
    }
  }

  void _onResumed(TrainingResumedEvent event, Emitter<TrainingState> emit) {
    if (state is TrainingPaused) {
      final s = state as TrainingPaused;
      _player.resume();
      add(
        TrainingStartedEvent(duration: Duration(seconds: s.remainingSeconds)),
      );
    }
  }

  void _onStopped(TrainingStoppedEvent event, Emitter<TrainingState> emit) {
    _timer?.cancel();
    _player.stop();
    emit(const TrainingFinished());
  }

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _player.dispose();
    return super.close();
  }
}
