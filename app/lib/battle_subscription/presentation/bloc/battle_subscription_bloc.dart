import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'battle_subscription_event.dart';
import 'battle_subscription_state.dart';

class BattleSubscriptionBloc
    extends Bloc<BattleSubscriptionEvent, BattleSubscriptionState> {
  BattleSubscriptionBloc() : super(BattleSubscriptionState()) {
    on<BattleSubscriptionLoadEvent>((event, emit) {
      emit(state.copyWith(names: event.names));
    });
    on<BattleSubscriptionClearAllEvent>(
      (_, emit) => emit(BattleSubscriptionState()),
    );
    on<BattleSubscritionGenerateEvent>(_onGenerateEvent);
    on<BattleSubscriptionAddEvent>(
      (event, emit) => emit(
        state.copyWith(
          names: [
            ...state.names,
            if (!state.names.contains(event.name)) event.name,
          ],
        ),
      ),
    );
    on<BattleSubscriptionRemoveEvent>((event, emit) {
      if (event.index >= 0 && event.index < state.names.length) {
        final newNames = List<String>.from(state.names);
        newNames.removeAt(event.index);
        emit(state.copyWith(names: newNames));
      }
    });
  }

  void _onGenerateEvent(
    BattleSubscritionGenerateEvent event,
    Emitter<BattleSubscriptionState> emit,
  ) {
    final random = Random();
    final shuffledNames = [...state.names]..shuffle(random);

    final newSubscriptions = <(String, String)>[];

    for (var i = 0; i < shuffledNames.length; i += 2) {
      if (i + 1 < shuffledNames.length) {
        newSubscriptions.add((shuffledNames[i], shuffledNames[i + 1]));
      } else {
        newSubscriptions.add((shuffledNames[i], 'BYE'));
      }
    }

    emit(state.copyWith(subscriptions: newSubscriptions));
  }
}
