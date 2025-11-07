import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';

abstract class BeatsEvent extends Equatable {
  const BeatsEvent();
  @override
  List<Object?> get props => [];
}

final class BeatsLoadEvent extends BeatsEvent {}

final class BeatsPlayEvent extends BeatsEvent {
  const BeatsPlayEvent([this.source]);
  final AssetSource? source;
  @override
  List<Object?> get props => [source];
}

final class BeatsPauseEvent extends BeatsEvent {}

final class BeatsStopEvent extends BeatsEvent {}

final class BeatsNextEvent extends BeatsEvent {}

final class BeatsPreviousEvent extends BeatsEvent {}
