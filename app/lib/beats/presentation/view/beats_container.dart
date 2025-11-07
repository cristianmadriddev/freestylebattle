import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/beats_bloc.dart';
import '../bloc/beats_event.dart';
import '../bloc/beats_state.dart';

class BeatsContainer extends StatelessWidget {
  const BeatsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeatsBloc, BeatsState>(
      builder: (context, state) {
        final bloc = context.read<BeatsBloc>();

        if (state.status == BeatsStatus.initial) {
          return Center(
            child: ElevatedButton.icon(
              onPressed: () => bloc.add(BeatsLoadEvent()),
              icon: const Icon(Icons.cloud_download),
              label: const Text('Carregar Playlist 🎵'),
            ),
          );
        }

        if (state.status == BeatsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == BeatsStatus.error) {
          return Center(child: Text('Erro: ${state.errorMessage}'));
        }

        return Column(
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
                    } else if (state.currentTrack != null) {
                      bloc.add(BeatsPlayEvent(state.currentTrack!));
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
            Expanded(
              child: ListView.builder(
                itemCount: state.tracks.length,
                itemBuilder: (context, index) {
                  final track = state.tracks[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(track.title),
                    subtitle: Text(track.user.username),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
