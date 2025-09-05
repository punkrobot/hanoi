import 'package:app/data/models/solution_api.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'hanoi_solver_rest_client.g.dart';

@RestApi(baseUrl: 'http://192.168.0.2:8080/api')
abstract class HanoiSolverRestClient {
  factory HanoiSolverRestClient(Dio dio, {String? baseUrl}) =
      _HanoiSolverRestClient;

  @GET('/hanoi/{disks}')
  Future<SolutionApi> solveHanoi(@Path('disks') int disks);
}
