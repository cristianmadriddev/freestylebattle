import 'package:equatable/equatable.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';

enum BeatsStatus { initial, loading, playing, paused, stopped, error }

final class BeatsState extends Equatable {
  const BeatsState({
    this.status = BeatsStatus.initial,
    this.tracks = const [],
    this.currentIndex = 0,
    this.errorMessage,
  });

  final BeatsStatus status;
  final List<Track> tracks;
  final int currentIndex;
  final String? errorMessage;

  Track? get currentTrack => tracks.isNotEmpty && currentIndex < tracks.length
      ? tracks[currentIndex]
      : null;

  BeatsState copyWith({
    BeatsStatus? status,
    List<Track>? tracks,
    int? currentIndex,
    String? errorMessage,
  }) {
    return BeatsState(
      status: status ?? this.status,
      tracks: tracks ?? this.tracks,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tracks, currentIndex, errorMessage];
}
