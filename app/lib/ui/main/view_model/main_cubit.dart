import 'dart:async';

import 'package:app/domain/models/solution.dart';
import 'package:app/domain/usecases/solve_hanoi_usecase.dart';
import 'package:app/ui/main/view_model/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//
// A cubit is used for simplicity since the view is not very complex, but using
// this architecture is simple to replace cubit with other libraries since all
// the domain logic is in the use case class.
//
class MainCubit extends Cubit<MainState> {
  final SolveHanoiUseCase solveHanoiUseCase;
  Timer? _playbackTimer;

  MainCubit({required this.solveHanoiUseCase}) : super(MainState.initial);

  //
  // The cubit only depends on the use case class and does not use the repositories directly.
  //
  void solveHanoi() async {
    emit(state.copyWith(isLoading: true));

    final result = await solveHanoiUseCase(state.disks);

    result.fold(
      (success) {
        emit(state.copyWith(isLoading: false, solution: success));
        // Auto-start playback immediately after solution is loaded
        startSolutionPlayback();
      },
      (error) =>
          emit(state.copyWith(isLoading: false, error: error.toString())),
    );
  }

  void resetError() {
    emit(state.copyWith(error: ""));
  }

  void resetGame() {
    _stopPlayback();
    emit(
      state.copyWith(
        disks: state.disks,
        towers: MainState.getInitialTowers(state.disks),
        solution: Solution(0, 0, []),
        error: "",
        playbackState: PlaybackState.idle,
        currentMoveIndex: 0,
        currentMoveDescription: "",
        isGameCompleted: false,
        manualMoveCount: 0,
      ),
    );
  }

  void updateDiskCount(int newDiskCount) {
    _stopPlayback();
    emit(
      state.copyWith(
        disks: newDiskCount,
        towers: MainState.getInitialTowers(newDiskCount),
        solution: Solution(0, 0, []),
        error: "",
        playbackState: PlaybackState.idle,
        currentMoveIndex: 0,
        currentMoveDescription: "",
        isGameCompleted: false,
        manualMoveCount: 0,
      ),
    );
  }

  void updateAnimationSpeed(int newAnimationSpeedMs) {
    emit(state.copyWith(animationSpeedMs: newAnimationSpeedMs));
  }

  void updateSettings({int? diskCount, int? animationSpeedMs}) {
    _stopPlayback();
    emit(
      state.copyWith(
        disks: diskCount ?? state.disks,
        towers: diskCount != null ? MainState.getInitialTowers(diskCount) : state.towers,
        solution: diskCount != null ? Solution(0, 0, []) : state.solution,
        error: "",
        playbackState: PlaybackState.idle,
        currentMoveIndex: diskCount != null ? 0 : state.currentMoveIndex,
        currentMoveDescription: diskCount != null ? "" : state.currentMoveDescription,
        isGameCompleted: diskCount != null ? false : state.isGameCompleted,
        manualMoveCount: diskCount != null ? 0 : state.manualMoveCount,
        animationSpeedMs: animationSpeedMs ?? state.animationSpeedMs,
      ),
    );
  }

  bool canMoveDisk(int fromTower, int toTower) {
    if (fromTower == toTower) return false;
    if (state.towers[fromTower].isEmpty) return false;
    if (state.towers[toTower].isEmpty) return true;

    int movingDisk = state.towers[fromTower].last;
    int topDisk = state.towers[toTower].last;
    return movingDisk < topDisk;
  }

  void moveDisk(int fromTower, int toTower) {
    if (!canMoveDisk(fromTower, toTower)) return;

    List<List<int>> newTowers = state.towers
        .map((tower) => List<int>.from(tower))
        .toList();
    int disk = newTowers[fromTower].removeLast();
    newTowers[toTower].add(disk);

    bool gameCompleted = _isGameCompleted(newTowers);

    emit(
      state.copyWith(
        towers: newTowers,
        isGameCompleted: gameCompleted,
        manualMoveCount: state.manualMoveCount + 1,
      ),
    );
  }

  bool _isGameCompleted(List<List<int>> towers) {
    if (towers[2].length != state.disks) return false;

    for (int i = 0; i < towers[2].length; i++) {
      if (towers[2][i] != state.disks - i) return false;
    }

    return true;
  }

  void startSolutionPlayback() {
    if (state.solution.moves.isEmpty) return;

    // Reset to initial state
    emit(
      state.copyWith(
        towers: MainState.getInitialTowers(state.disks),
        playbackState: PlaybackState.playing,
        currentMoveIndex: 0,
        currentMoveDescription: "",
      ),
    );

    _startPlaybackTimer();
  }

  void _startPlaybackTimer() {
    _playbackTimer = Timer.periodic(Duration(milliseconds: state.animationSpeedMs), (timer) {
      _executeNextMove();
    });
  }

  void _stopPlayback() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
  }

  void _executeNextMove() {
    if (state.currentMoveIndex >= state.solution.moves.length) {
      _stopPlayback();
      emit(
        state.copyWith(
          playbackState: PlaybackState.completed,
          currentMoveDescription: "Solution completed!",
        ),
      );
      return;
    }

    final move = state.solution.moves[state.currentMoveIndex];

    int fromTower = move.fromIndex;
    int toTower = move.toIndex;

    // Execute the move
    List<List<int>> newTowers = state.towers
        .map((tower) => List<int>.from(tower))
        .toList();

    if (newTowers[fromTower].isNotEmpty) {
      int disk = newTowers[fromTower].removeLast();
      newTowers[toTower].add(disk);
    }

    emit(
      state.copyWith(
        towers: newTowers,
        currentMoveIndex: state.currentMoveIndex + 1,
        currentMoveDescription: move.description,
      ),
    );
  }

  @override
  Future<void> close() {
    _stopPlayback();
    return super.close();
  }
}
