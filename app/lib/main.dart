import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'beats/beats.dart';
import 'home/home.dart';
import 'timer/timer.dart';
import 'battle_subscription/battle_subscription.dart';
import 'training_list/data/local_json_training_repository.dart';
import 'training_list/domain/get_training_words_use_case.dart';
import 'training_list/presentation/bloc/training_list_bloc.dart';

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

          BlocProvider<TrainingListBloc>.value(
            value: TrainingListBloc(
              GetTrainingCategoriesUseCaseImpl(TrainingRepositoryImpl()),
            ),
          ),
          BlocProvider<BeatsBloc>.value(
            value: BeatsBloc(BeatsFromLocalAssetsUseCase()),
          ),
          BlocProvider<BattleSubscriptionBloc>.value(
            value: BattleSubscriptionBloc(),
          ),
        ],
        child: HomeTabs(),
      ),
    );
  }
}
