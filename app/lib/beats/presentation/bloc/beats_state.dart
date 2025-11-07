import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';

enum BeatsStatus { initial, loading, playing, paused, stopped, error }

final class BeatsState extends Equatable {
  const BeatsState({
    this.status = BeatsStatus.initial,
    this.sources = const [],
    this.currentIndex = 0,
    this.errorMessage,
  });

  final BeatsStatus status;
  final List<AssetSource> sources;
  final int currentIndex;
  final String? errorMessage;

  AssetSource? get currentTrack =>
      sources.isNotEmpty && currentIndex < sources.length
      ? sources[currentIndex]
      : null;

  BeatsState copyWith({
    BeatsStatus? status,
    List<AssetSource>? sources,
    int? currentIndex,
    String? errorMessage,
  }) {
    return BeatsState(
      status: status ?? this.status,
      sources: sources ?? this.sources,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sources, currentIndex, errorMessage];
}
