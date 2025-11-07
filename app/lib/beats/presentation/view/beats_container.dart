import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/beats_bloc.dart';
import '../bloc/beats_event.dart';
import '../bloc/beats_state.dart';

class BeatsContainer extends StatefulWidget {
  const BeatsContainer({super.key});

  @override
  State<BeatsContainer> createState() => _BeatsContainerState();
}

class _BeatsContainerState extends State<BeatsContainer> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<BeatsBloc>();
    bloc.add(BeatsLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeatsBloc, BeatsState>(
      builder: (context, state) {
        final bloc = context.read<BeatsBloc>();

        if (state.status == BeatsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == BeatsStatus.error) {
          return Center(child: Text('Erro: ${state.errorMessage}'));
        }

        return SizedBox(
          height: 100,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () => bloc.add(BeatsPreviousEvent()),
                  ),
                  IconButton(
                    icon: Icon(
                      state.status == BeatsStatus.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 36,
                    ),
                    onPressed: () {
                      if (state.status == BeatsStatus.playing) {
                        bloc.add(BeatsPauseEvent());
                      } else {
                        bloc.add(BeatsPlayEvent(state.currentTrack));
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () => bloc.add(BeatsNextEvent()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: () => bloc.add(BeatsStopEvent()),
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
