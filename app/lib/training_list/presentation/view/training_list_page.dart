import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../beats/beats.dart';
import '../bloc/training_bloc.dart';
import '../bloc/training_list_bloc.dart';
import '../bloc/training_list_event.dart';
import '../bloc/training_list_state.dart';
import 'training_page.dart';

class TrainingListPage extends StatefulWidget {
  const TrainingListPage({super.key});

  @override
  State<TrainingListPage> createState() => _TrainingListPageState();
}

class _TrainingListPageState extends State<TrainingListPage> {
  @override
  void initState() {
    super.initState();
    context.read<TrainingListBloc>().add(LoadTrainingListCategories());
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return Scaffold(
      appBar: AppBar(centerTitle: true),
      body: BlocBuilder<TrainingListBloc, TrainingListState>(
        builder: (context, state) {
          if (state is TrainingListLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                final color = Colors
                    .primaries[random.nextInt(Colors.primaries.length)]
                    .shade400;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => TrainingBloc(
                            beatsUseCase: BeatsFromLocalAssetsUseCase(),
                            category: category,
                          ),
                          child: TrainingPage(category: category),
                        ),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Center(
                        child: Text(
                          category.title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (state is TrainingListError) {
            return Center(
              child: Text(
                'Erro ao carregar categorias 😕',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
