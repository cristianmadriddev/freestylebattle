import 'package:equatable/equatable.dart';

final class BattleSubscriptionState extends Equatable {
  const BattleSubscriptionState({
    this.names = const [],
    this.subscriptions = const [],
  });
  final List<String> names;
  final List<(String, String)> subscriptions;

  @override
  List<Object?> get props => [names, subscriptions];

  BattleSubscriptionState copyWith({
    List<String>? names,
    List<(String, String)>? subscriptions,
  }) {
    return BattleSubscriptionState(
      names: names ?? this.names,
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }
}
