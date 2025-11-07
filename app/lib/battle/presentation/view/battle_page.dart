import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freestylebattle/battle_subscription/presentation/bloc/battle_subscription_event.dart';
import 'package:freestylebattle/battle_subscription/presentation/bloc/battle_subscription_state.dart';
import '../../battle.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              icon: const Icon(Icons.delete_outline),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: BattleSubscriptionContainer(),
        );
      },
    );
  }
}
