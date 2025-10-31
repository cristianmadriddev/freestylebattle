import 'package:flutter/material.dart';
import '../../battle.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grita: Hip Hop!'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(children: [Expanded(child: BattleSubscriptionContainer())]),
    );
  }
}
