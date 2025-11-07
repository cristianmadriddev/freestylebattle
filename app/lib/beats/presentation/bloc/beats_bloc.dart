import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';
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
  final SoundcloudClient _client = SoundcloudClient();

  Future<void> _onLoad(BeatsLoadEvent event, Emitter<BeatsState> emit) async {
    emit(state.copyWith(status: BeatsStatus.loading));

    try {
      final tracks = await _useCase.call();
      final playlistSource = ConcatenatingAudioSource(children: []);

      // Build the queue with actual streaming URLs
      for (final track in tracks) {
        final streamUrl = await _client.tracks.getStreams(track.id);
        playlistSource.add(AudioSource.uri(Uri.parse(streamUrl.toString())));
      }

      await _player.setAudioSource(playlistSource);

      emit(state.copyWith(status: BeatsStatus.paused, tracks: tracks));
    } catch (e) {
      emit(
        state.copyWith(status: BeatsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onPlay(BeatsPlayEvent event, Emitter<BeatsState> emit) async {
    if (state.tracks.isEmpty) return;

    await _player.play();
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
    await _player.seekToNext();
  }

  Future<void> _onPrevious(
    BeatsPreviousEvent event,
    Emitter<BeatsState> emit,
  ) async {
    await _player.seekToPrevious();
  }

  @override
  Future<void> close() async {
    await _player.dispose();
    return super.close();
  }
}
