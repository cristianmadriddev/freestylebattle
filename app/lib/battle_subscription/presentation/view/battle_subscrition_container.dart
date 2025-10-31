import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freestylebattle/battle_subscription/presentation/bloc/battle_subscription_bloc.dart';
import 'package:freestylebattle/battle_subscription/presentation/bloc/battle_subscription_event.dart';
import 'package:freestylebattle/timer/timer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/battle_subscription_state.dart';

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
  bool _showMatches = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<BattleSubscriptionBloc, BattleSubscriptionState>(
        builder: (context, state) {
          final bloc = context.read<BattleSubscriptionBloc>();

          if (_showMatches) {
            final battles = state.subscriptions;

            if (battles.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _showMatches = false);
              });
              return const SizedBox();
            }

            if (_currentBattleIndex >= battles.length) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Todas as batalhas foram exibidas 🏁',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showMatches = false;
                          _currentBattleIndex = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: const Text('Voltar para inscrições'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _currentBattleIndex > 0
                            ? () => setState(() => _currentBattleIndex--)
                            : null,
                        icon: Icon(
                          Icons.skip_previous,
                          size: 36,
                          color: _currentBattleIndex > 0
                              ? colorScheme.primary
                              : colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              battles[_currentBattleIndex].$1,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.bungeeSpice(
                                fontSize: 44,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'VS',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.butterflyKids(
                                fontSize: 22,
                                color: colorScheme.error,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              battles[_currentBattleIndex].$2,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: GoogleFonts.bungeeSpice(
                                fontSize: 44,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _currentBattleIndex < battles.length - 1
                            ? () => setState(() => _currentBattleIndex++)
                            : null,
                        icon: Icon(
                          Icons.skip_next,
                          size: 36,
                          color: _currentBattleIndex < battles.length - 1
                              ? colorScheme.primary
                              : colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                TimerCard(),
                const SizedBox(height: 24),
              ],
            );
          }

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
                        labelText: 'Digite o Vulgo',
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
                  IconButton(
                    onPressed: state.subscriptions.isEmpty
                        ? () => _addName(bloc)
                        : null,
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.all(16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (state.names.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Adicione as inscrições',
                      style: TextStyle(color: colorScheme.error, fontSize: 24),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: state.names.length,
                    separatorBuilder: (_, index) =>
                        Divider(color: colorScheme.outline),
                    itemBuilder: (context, index) {
                      final name = state.names[index];
                      return ListTile(
                        title: Text(
                          '${index + 1}. $name',
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

              ElevatedButton.icon(
                onPressed:
                    (state.names.length >= 2 && state.subscriptions.isEmpty)
                    ? () {
                        bloc.add(BattleSubscritionGenerateEvent());
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context
                              .read<BattleSubscriptionBloc>()
                              .state
                              .subscriptions
                              .isNotEmpty) {
                            setState(() => _showMatches = true);
                          }
                        });
                      }
                    : null,
                icon: const Icon(Icons.shuffle),
                label: const Text('Gerar Chaves'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.all(20),
                  textStyle: const TextStyle(fontSize: 18),
                ),
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
