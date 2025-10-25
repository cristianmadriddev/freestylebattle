import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';
import 'set_duration_dialog.dart';

class TimerCard extends StatelessWidget {
  const TimerCard({super.key});

  String _formatDuration(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final bloc = context.read<TimerBloc>();

        final canStart =
            state.status == TimerStatus.idle ||
            state.status == TimerStatus.paused ||
            state.status == TimerStatus.finished;

        final isRunning = state.status == TimerStatus.running;
        final isStarting = state.status == TimerStatus.starting;
        final isPaused = state.status == TimerStatus.paused;

        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isStarting)
                  Text(
                    'Starting ${state.startingSecondsLeft}',
                    style: const TextStyle(fontSize: 18, color: Colors.orange),
                  )
                else if (state.status == TimerStatus.finished)
                  const Text(
                    'Finished',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  )
                else if (isPaused)
                  const Text(
                    'Paused',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )
                else if (state.status == TimerStatus.idle)
                  const Text(
                    'Ready',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                const SizedBox(height: 8),
                Text(
                  _formatDuration(state.remaining),
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: canStart
                          ? () => bloc.add(TimerStarted())
                          : null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: isRunning || isPaused
                          ? () => bloc.add(
                              isRunning ? TimerPaused() : TimerResumed(),
                            )
                          : null,
                      icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(
                        isRunning ? 'Pause' : (isPaused ? 'Resume' : 'Pause'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: state.status != TimerStatus.idle
                          ? () => bloc.add(TimerRestarted())
                          : null,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Restart'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () async {
                        final d = await showDialog<Duration>(
                          context: context,
                          builder: (_) =>
                              SetDurationDialog(initial: state.initial),
                        );
                        if (d != null) {
                          bloc.add(TimerSetDuration(d));
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Set'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
