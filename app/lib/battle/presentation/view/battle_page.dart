import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freestylebattle/battle_subscription/presentation/bloc/battle_subscription_event.dart';
import 'package:freestylebattle/battle_subscription/presentation/bloc/battle_subscription_state.dart';
import '../../battle.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BattleSubscriptionBloc, BattleSubscriptionState>(
      builder: (_, state) {
        final bloc = context.read<BattleSubscriptionBloc>();
        final canDelete =
            state.names.isNotEmpty || state.subscriptions.isNotEmpty;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: canDelete
                  ? () {
                      bloc.add(BattleSubscriptionClearAllEvent());
                      DefaultTabController.of(context).animateTo(0);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),

              icon: const Icon(Icons.delete_outline),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 32,
                  color: Colors.yellow,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ],
            ),
            actions: const [SizedBox(width: 48)],
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Column(
            children: [Expanded(child: BattleSubscriptionContainer())],
          ),
        );
      },
    );
  }
}
