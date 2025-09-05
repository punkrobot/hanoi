import 'package:app/data/repositories/hanoi_solver_repository.dart';
import 'package:app/domain/models/solution.dart';
import 'package:result_dart/result_dart.dart';

/* 
// The main use case of the app, encapsulates the domain logic of calling the repository.
*/
class SolveHanoiUseCase {
  late HanoiSolverRepository _hanoiSolverRepository;

  SolveHanoiUseCase({required HanoiSolverRepository hanoiSolverRepository}) {
    _hanoiSolverRepository = hanoiSolverRepository;
  }

  Future<Result<Solution>> call(int disks) async {
    final solutionResult = await _hanoiSolverRepository.solveHanoi(disks);

    return solutionResult.fold(
      (success) => Success(success),
      (error) => Failure(error),
    );
  }
}
