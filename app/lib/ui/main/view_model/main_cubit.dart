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

  MainCubit({required this.solveHanoiUseCase}) : super(MainState.initial);

  //
  // The cubit only depends on the use case class and does not use the repositories directly.
  //
  void solveHanoi() async {
    emit(state.copyWith(isLoading: true));

    final result = await solveHanoiUseCase(state.disks);

    result.fold(
      (success) => emit(state.copyWith(isLoading: false, solution: success)),
      (error) =>
          emit(state.copyWith(isLoading: false, error: error.toString())),
    );
  }

  void resetError() {
    emit(state.copyWith(error: ""));
  }

  void resetGame() {
    emit(
      state.copyWith(
        disks: state.disks,
        towers: MainState.getInitialTowers(state.disks),
        solution: Solution(0, 0, []),
        error: "",
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

    emit(state.copyWith(towers: newTowers));
  }
}
