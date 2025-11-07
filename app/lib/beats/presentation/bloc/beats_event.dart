import 'package:equatable/equatable.dart';
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';

abstract class BeatsEvent extends Equatable {
  const BeatsEvent();
  @override
  List<Object?> get props => [];
}

final class BeatsLoadEvent extends BeatsEvent {}

final class BeatsPlayEvent extends BeatsEvent {
  const BeatsPlayEvent(this.track);
  final Track track;
}

final class BeatsPauseEvent extends BeatsEvent {}

final class BeatsStopEvent extends BeatsEvent {}

final class BeatsNextEvent extends BeatsEvent {}

final class BeatsPreviousEvent extends BeatsEvent {}
