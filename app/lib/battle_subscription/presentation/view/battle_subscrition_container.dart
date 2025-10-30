import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freestylebattle/battle_subscription/presentation/bloc/battle_subscription_bloc.dart';
import 'package:freestylebattle/battle_subscription/presentation/bloc/battle_subscription_event.dart';
import 'package:freestylebattle/battle_subscription/presentation/bloc/battle_subscription_state.dart';

class BattleSubscriptionContainer extends StatefulWidget {
  const BattleSubscriptionContainer({super.key});

  @override
  State<BattleSubscriptionContainer> createState() =>
      _BattleSubscriptionContainerState();
}

class _BattleSubscriptionContainerState
    extends State<BattleSubscriptionContainer> {
  final TextEditingController _nameController = TextEditingController();
  int _currentBattleIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: colorScheme.primary, // amarelo
            unselectedLabelColor: colorScheme.outline, // cinza suave
            indicatorColor: colorScheme.primary,
            tabs: const [
              Tab(icon: Icon(Icons.people_alt_outlined), text: 'Inscritos'),
              Tab(icon: Icon(Icons.sports_martial_arts), text: 'Chaveamentos'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildParticipantsTab(context),
                _buildBattlesTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<BattleSubscriptionBloc, BattleSubscriptionState>(
        builder: (context, state) {
          final bloc = context.read<BattleSubscriptionBloc>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      enabled: state.subscriptions.isEmpty,
                      style: TextStyle(color: colorScheme.onBackground),
                      decoration: InputDecoration(
                        labelText: 'Digite um nome',
                        labelStyle: TextStyle(color: colorScheme.outline),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _addName(bloc),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: state.subscriptions.isEmpty
                        ? () => _addName(bloc)
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (state.names.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Nenhum inscrito ainda 👀',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: state.names.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: colorScheme.outline),
                    itemBuilder: (context, index) {
                      final name = state.names[index];
                      return ListTile(
                        title: Text(
                          name,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: colorScheme.error,
                          onPressed: state.subscriptions.isEmpty
                              ? () => bloc.add(
                                  BattleSubscriptionRemoveEvent(index: index),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          (state.names.length >= 2 &&
                              state.subscriptions.isEmpty)
                          ? () {
                              bloc.add(BattleSubscritionGenerateEvent());
                              DefaultTabController.of(context).animateTo(1);
                            }
                          : null,
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Gerar Chaves'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.all(24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          (state.names.isNotEmpty ||
                              state.subscriptions.isNotEmpty)
                          ? () {
                              bloc.add(BattleSubscriptionClearAllEvent());
                              DefaultTabController.of(context).animateTo(0);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                        padding: const EdgeInsets.all(24),
                      ),
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Limpar tudo'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBattlesTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocConsumer<BattleSubscriptionBloc, BattleSubscriptionState>(
        listener: (context, state) {
          if (state.subscriptions.isNotEmpty) {
            setState(() => _currentBattleIndex = 0);
          }
        },
        builder: (context, state) {
          if (state.subscriptions.isEmpty) {
            return Center(
              child: Text(
                'Kd as inscrições fml?!',
                style: TextStyle(color: colorScheme.outline),
              ),
            );
          }

          final battles = state.subscriptions;

          if (_currentBattleIndex >= battles.length) {
            return Center(
              child: Text(
                'Todas as batalhas foram exibidas 🏁',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    for (int i = 2; i >= 0; i--)
                      if (_currentBattleIndex + i < battles.length)
                        Transform.translate(
                          offset: Offset(0, i * 8),
                          child: Opacity(
                            opacity: i == 0 ? 1 : 0.5,
                            child: Card(
                              color: colorScheme.surface,
                              elevation: 6 - (i * 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                child: Center(
                                  child: Text(
                                    '${battles[_currentBattleIndex + i].$1} 🆚 ${battles[_currentBattleIndex + i].$2}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _currentBattleIndex > 0
                        ? () {
                            setState(() {
                              _currentBattleIndex--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.navigate_before),
                    label: const Text('Batalha Anterior'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.all(24),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _currentBattleIndex < battles.length - 1
                        ? () {
                            setState(() {
                              _currentBattleIndex++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.navigate_next),
                    label: const Text('Próxima Batalha'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.all(24),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _addName(BattleSubscriptionBloc bloc) {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      bloc.add(BattleSubscriptionAddEvent(name: name));
      _nameController.clear();
    }
  }
}
