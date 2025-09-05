import 'package:app/config/dependency_injection.dart';
import 'package:app/domain/usecases/solve_hanoi_usecase.dart';
import 'package:app/ui/main/view_model/main_cubit.dart';
import 'package:app/ui/main/view_model/main_state.dart';
import 'package:app/ui/main/widgets/hanoi_game_widget.dart';
import 'package:app/ui/main/widgets/settings_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MainCubit(solveHanoiUseCase: di<SolveHanoiUseCase>()),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
          if (state.error.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
            context.read<MainCubit>().resetError();
          }

          if (state.isManuallyCompleted) {
            _triggerConfetti(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Towers of Hanoi'),
              actions: [
                IconButton(
                  onPressed: () => SettingsModal.show(context),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<MainCubit>().resetGame();
                            },
                            child: const Text('New Game'),
                          ),
                          ElevatedButton(
                            onPressed: state.playbackState == PlaybackState.idle
                                ? () {
                                    context.read<MainCubit>().solveHanoi();
                                  }
                                : null,
                            child: const Text('Auto Solve'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (state.isLoading)
                        const CircularProgressIndicator()
                      else if (state.solution.moves.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Move ${state.currentMoveIndex}/${state.solution.movesCount}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.currentMoveDescription,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else if (state.isGameCompleted)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green, width: 2),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '🎉  Puzzle Solved!  🎉',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Moves: ${state.manualMoveCount} / Minimum: ${state.minimumMoves}",
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else if (state.manualMoveCount > 0)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Moves: ${state.manualMoveCount} / Minimum: ${state.minimumMoves}",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        Text(
                          "Drag the disks to play",
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: HanoiGameWidget(
                    numberOfDisks: state.disks,
                    towers: state.towers,
                    onDiskMove: (from, to) {
                      context.read<MainCubit>().moveDisk(from, to);
                    },
                    canMoveDisk: (from, to) {
                      return context.read<MainCubit>().canMoveDisk(from, to);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _triggerConfetti(BuildContext context) {
    Confetti.launch(
      context,
      options: const ConfettiOptions(particleCount: 100, spread: 85, y: 0.7),
    );
  }
}
