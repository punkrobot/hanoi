import 'package:app/data/repositories/hanoi_solver_repository.dart';
import 'package:app/data/services/hanoi_solver_service.dart';
import 'package:app/data/services/network/hanoi_solver_rest_client.dart';
import 'package:app/domain/usecases/solve_hanoi_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

GetIt di = GetIt.instance;

class DI {
  static Future<void> init() async {
    di.registerLazySingleton(() => HanoiSolverRestClient(Dio()));

    di.registerLazySingleton(
      () => HanoiSolverService(hanoiSolverRestClient: di()),
    );

    di.registerLazySingleton(
      () => HanoiSolverRepository(hanoiSolverService: di()),
    );

    di.registerLazySingleton(
      () => SolveHanoiUseCase(hanoiSolverRepository: di()),
    );
  }
}
