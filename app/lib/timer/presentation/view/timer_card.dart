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

        final isRunning = state.status == TimerStatus.running;
        final isPaused = state.status == TimerStatus.paused;
        final isIdleOrFinished =
            state.status == TimerStatus.idle ||
            state.status == TimerStatus.finished;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                _formatDuration(state.remaining),
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(
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
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                    ),
                    icon: const Icon(Icons.settings, size: 20),
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  IconButton.filled(
                    onPressed: isIdleOrFinished
                        ? () => bloc.add(TimerStarted())
                        : isRunning
                        ? () => bloc.add(TimerPaused())
                        : () => bloc.add(TimerResumed()),
                    icon: Icon(
                      isIdleOrFinished || isPaused
                          ? Icons.play_arrow
                          : Icons.pause,
                      size: 32,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton.outlined(
                    onPressed: !isIdleOrFinished
                        ? () => bloc.add(TimerStopped())
                        : null,
                    icon: const Icon(Icons.stop, size: 24),
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                        color: isIdleOrFinished
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                      ),
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
