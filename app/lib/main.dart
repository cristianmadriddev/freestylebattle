import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freestylebattle/battle/presentation/view/battle_page.dart';

import 'timer/timer.dart';
import 'battle_subscription/battle_subscription.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFFD700),
          onPrimary: Colors.black,
          secondary: Color(0xFFFF5252),
          onSecondary: Colors.white,
          surface: Color(0xFF121212),
          onSurface: Colors.white,
          error: Color(0xFFFF5252),
          onError: Colors.white,
          outline: Color(0xFF555555),
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TimerBloc>.value(value: TimerBloc()),
          BlocProvider<BattleSubscriptionBloc>.value(
            value: BattleSubscriptionBloc(),
          ),
        ],
        child: BattlePage(),
      ),
    );
  }
}
