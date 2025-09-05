import 'package:app/data/services/hanoi_solver_service.dart';
import 'package:app/domain/models/move.dart';
import 'package:app/domain/models/solution.dart';
import 'package:result_dart/result_dart.dart';

class HanoiSolverRepository {
  late HanoiSolverService _hanoisolverService;

  HanoiSolverRepository({required HanoiSolverService hanoiSolverService}) {
    _hanoisolverService = hanoiSolverService;
  }

  Future<Result<Solution>> solveHanoi(int disks) async {
    final apiResult = await _hanoisolverService.solveHanoi(disks);

    return apiResult.fold(
      (success) => Success(
        // One of the roles of the repository is to translate API to domain models
        Solution(
          success.disks,
          success.movesCount,
          success.moves
              .map((m) => Move(m.description, m.disk, m.from, m.to))
              .toList(),
        ),
      ),
      (failure) => Failure(
        // Domain specific error should be parsed and thrown here
        Exception("An error ocurred, please try again later."),
      ),
    );
  }
}
