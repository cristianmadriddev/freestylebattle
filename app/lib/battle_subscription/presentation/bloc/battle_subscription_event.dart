import 'package:equatable/equatable.dart';

abstract class BattleSubscriptionEvent extends Equatable {
  const BattleSubscriptionEvent();

  @override
  List<Object?> get props => [];
}

final class BattleSubscriptionLoadEvent extends BattleSubscriptionEvent {
  const BattleSubscriptionLoadEvent({this.names = const []});
  final List<String> names;
}

final class BattleSubscriptionAddEvent extends BattleSubscriptionEvent {
  const BattleSubscriptionAddEvent({required this.name});
  final String name;
}

final class BattleSubscriptionRemoveEvent extends BattleSubscriptionEvent {
  const BattleSubscriptionRemoveEvent({required this.index});
  final int index;
}

final class BattleSubscritionGenerateEvent extends BattleSubscriptionEvent {}

final class BattleSubscriptionClearAllEvent extends BattleSubscriptionEvent {}
