import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/training_category.dart';
import '../bloc/training_bloc.dart';
import '../bloc/training_event.dart';
import '../bloc/training_state.dart';

class TrainingPage extends StatefulWidget {
  final TrainingCategory category;
  const TrainingPage({super.key, required this.category});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  Duration _selectedDuration = const Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  void _showDurationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Escolha o tempo por rodada"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var s in [15, 20, 30])
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedDuration = Duration(seconds: s);
                  });
                  Navigator.pop(context);
                },
                child: Text("$s s"),
              ),
          ],
        ),
      ),
    );
  }

  void _startAnimation() => _controller.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: CloseButton(),
      ),
      body: BlocConsumer<TrainingBloc, TrainingState>(
        listener: (context, state) {
          if (state is TrainingCountdown) _startAnimation();
        },
        builder: (context, state) {
          final bloc = context.read<TrainingBloc>();
          Widget child;

          if (state is TrainingInitial) {
            child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.category.title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showDurationDialog(context),
                  icon: const Icon(Icons.timer),
                  label: Text("${_selectedDuration.inSeconds}s"),
                ),
                const SizedBox(height: 32),
                IconButton.filled(
                  icon: const Icon(Icons.play_arrow, size: 64),
                  onPressed: () => bloc.add(
                    TrainingStartedEvent(duration: _selectedDuration),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(28),
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            );
          } else if (state is TrainingCountdown) {
            child = ScaleTransition(
              scale: _scale,
              child: Text(
                state.message,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.redAccent,
                ),
              ),
            );
          } else if (state is TrainingRunning) {
            child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Rodada ${state.round}",
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: state.words
                      .map(
                        (w) => Text(
                          w,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.primaries[w.hashCode %
                                    Colors.primaries.length],
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                Text(
                  state.formattedTime,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                IconButton.outlined(
                  onPressed: () => bloc.add(const TrainingStoppedEvent()),
                  icon: const Icon(Icons.stop, size: 36),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(24),
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            );
          } else if (state is TrainingFinished) {
            child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🔥 RIMA ENCERRADA!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                IconButton.filled(
                  icon: const Icon(Icons.replay, size: 48),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(28),
                    shape: const CircleBorder(),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => bloc.add(
                    TrainingStartedEvent(duration: _selectedDuration),
                  ),
                ),
              ],
            );
          } else {
            child = const SizedBox.shrink();
          }

          return Scaffold(
            body: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
