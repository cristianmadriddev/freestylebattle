import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freestylebattle/beats/domain/beats_use_case.dart';
import 'package:freestylebattle/training/data/local_json_training_repository.dart';
import 'package:freestylebattle/training/domain/get_training_words_use_case.dart';
import 'package:freestylebattle/training/domain/training_repository.dart';
import 'package:freestylebattle/training/presentation/bloc/training_page_bloc.dart';

import 'beats/presentation/bloc/beats_bloc.dart';
import 'home/presentation/home_page.dart';
import 'timer/timer.dart';
import 'battle_subscription/battle_subscription.dart';
import 'training/presentation/bloc/training_page_event.dart';

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
          BlocProvider<TrainingBloc>.value(
            value: TrainingBloc(
              GetTrainingWordsUseCaseImpl(TrainingRepositoryImpl()),
            )..add(TrainingLevelSelectedEvent(TrainingLevel.facil)),
          ),
          BlocProvider<BeatsBloc>.value(
            value: BeatsBloc(
              BeatsFromSoundCloudUseCase(
                url: 'https://soundcloud.com/globeats/sets/freestyle-rap-beats',
              ),
            ),
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
