import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freestylebattle/timer/presentation/view/set_duration_dialog.dart';
import '../../domain/training_repository.dart';
import '../bloc/training_page_bloc.dart';
import '../bloc/training_page_event.dart';
import '../bloc/traning_page_state.dart';

class TrainingPage extends StatefulWidget {
  @override
  State<TrainingPage> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingPage> {
  TrainingLevel selectedLevel = TrainingLevel.facil;
  Duration currentDuration = const Duration(seconds: 45);

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TrainingBloc>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<TrainingBloc, TrainingState>(
          builder: (context, state) {
            final isRunning = state.isRunning;
            final isPaused = state.isPaused;
            final canStart = state.words.isNotEmpty && !isRunning;
            final canStop = isRunning || isPaused;

            final words = state.words;
            final remainingSeconds = state.remainingSeconds;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final level in TrainingLevel.values)
                      ChoiceChip(
                        label: Text(level.name.toUpperCase()),
                        selected: selectedLevel == level,
                        onSelected: (v) {
                          if (v && !isRunning) {
                            setState(() => selectedLevel = level);
                            bloc.add(TrainingLevelSelectedEvent(level));
                          }
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: isRunning
                          ? Wrap(
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                for (final word in words)
                                  Text(
                                    word,
                                    style: TextStyle(
                                      fontSize:
                                          20 +
                                          Random(
                                            word.hashCode,
                                          ).nextInt(10).toDouble(),
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Colors.primaries[Random(
                                            word.hashCode,
                                          ).nextInt(Colors.primaries.length)],
                                    ),
                                  ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
                Text(
                  _formatDuration(remainingSeconds),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      onPressed: () async {
                        final d = await showDialog<Duration>(
                          context: context,
                          builder: (_) =>
                              SetDurationDialog(initial: currentDuration),
                        );
                        if (d != null) {
                          setState(() => currentDuration = d);
                          bloc.add(TrainingSetDurationEvent(d));
                        }
                      },
                      icon: const Icon(Icons.settings, size: 20),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () {
                        if (canStart) {
                          bloc.add(TrainingStartedEvent(currentDuration));
                        } else if (isRunning) {
                          bloc.add(TrainingPausedEvent());
                        } else if (isPaused) {
                          bloc.add(TrainingResumedEvent());
                        }
                      },
                      icon: Icon(
                        isRunning ? Icons.pause : Icons.play_arrow,
                        size: 32,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      onPressed: canStop
                          ? () => bloc.add(TrainingStoppedEvent())
                          : null,
                      icon: const Icon(Icons.stop, size: 24),
                      style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(
                          color: canStop
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
