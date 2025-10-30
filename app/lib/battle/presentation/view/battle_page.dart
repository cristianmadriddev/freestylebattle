import 'package:flutter/material.dart';
import '../../battle.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assistente de Batalha')),
      body: Column(
        children: [
          TimerCard(),
          Expanded(child: BattleSubscriptionContainer()),
        ],
      ),
    );
  }
}
