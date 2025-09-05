import 'package:app/data/models/solution_api.dart';
import 'package:app/data/services/network/hanoi_solver_rest_client.dart';
import 'package:result_dart/result_dart.dart';

class HanoiSolverService {
  late HanoiSolverRestClient _hanoiSolverRestClient;

  HanoiSolverService({required HanoiSolverRestClient hanoiSolverRestClient}) {
    _hanoiSolverRestClient = hanoiSolverRestClient;
  }

  Future<Result<SolutionApi>> solveHanoi(int disks) async {
    try {
      final result = await _hanoiSolverRestClient.solveHanoi(disks);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e));
    }
  }
}
