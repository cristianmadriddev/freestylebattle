import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/beats_use_case.dart';
import 'beats_event.dart';
import 'beats_state.dart';

class BeatsBloc extends Bloc<BeatsEvent, BeatsState> {
  BeatsBloc(this._useCase) : super(const BeatsState()) {
    on<BeatsLoadEvent>(_onLoad);
    on<BeatsPlayEvent>(_onPlay);
    on<BeatsPauseEvent>(_onPause);
    on<BeatsStopEvent>(_onStop);
    on<BeatsNextEvent>(_onNext);
    on<BeatsPreviousEvent>(_onPrevious);
  }

  final BeatsUseCase _useCase;
  final AudioPlayer _player = AudioPlayer();

  Future<void> _onLoad(BeatsLoadEvent event, Emitter<BeatsState> emit) async {
    emit(state.copyWith(status: BeatsStatus.loading));
    try {
      final sources = _useCase.call();
      emit(
        state.copyWith(
          status: BeatsStatus.paused,
          sources: sources,
          currentIndex: 0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: BeatsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onPlay(BeatsPlayEvent event, Emitter<BeatsState> emit) async {
    final source = event.source ?? state.currentTrack;
    if (source == null) return;

    await _player.play(source);
    emit(state.copyWith(status: BeatsStatus.playing));
  }

  Future<void> _onPause(BeatsPauseEvent event, Emitter<BeatsState> emit) async {
    await _player.pause();
    emit(state.copyWith(status: BeatsStatus.paused));
  }

  Future<void> _onStop(BeatsStopEvent event, Emitter<BeatsState> emit) async {
    await _player.stop();
    emit(state.copyWith(status: BeatsStatus.stopped));
  }

  Future<void> _onNext(BeatsNextEvent event, Emitter<BeatsState> emit) async {
    if (state.sources.isEmpty) return;

    final nextIndex = (state.currentIndex + 1) % state.sources.length;
    final nextTrack = state.sources[nextIndex];

    await _player.play(nextTrack);
    emit(state.copyWith(currentIndex: nextIndex, status: BeatsStatus.playing));
  }

  Future<void> _onPrevious(
    BeatsPreviousEvent event,
    Emitter<BeatsState> emit,
  ) async {
    if (state.sources.isEmpty) return;

    final prevIndex =
        (state.currentIndex - 1 + state.sources.length) % state.sources.length;
    final prevTrack = state.sources[prevIndex];

    await _player.play(prevTrack);
    emit(state.copyWith(currentIndex: prevIndex, status: BeatsStatus.playing));
  }

  @override
  Future<void> close() async {
    await _player.dispose();
    return super.close();
  }
}
