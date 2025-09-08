import 'package:app/data/services/hanoi_solver_service.dart';
import 'package:app/domain/models/move.dart';
import 'package:app/domain/models/solution.dart';
import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

class HanoiSolverRepository {
  late HanoiSolverService _hanoisolverService;

  HanoiSolverRepository({required HanoiSolverService hanoiSolverService}) {
    _hanoisolverService = hanoiSolverService;
  }

  Future<Result<Solution>> solveHanoi(int disks) async {
    final apiResult = await _hanoisolverService.solveHanoi(disks);

    if (apiResult.isSuccess()) {
      final success = apiResult.getOrNull()!;
      return Success(
        // One of the roles of the repository is to translate API to domain models
        Solution(
          success.disks,
          success.movesCount,
          success.moves
              .map((m) => Move(
                    m.description, 
                    m.disk, 
                    m.from, 
                    m.to, 
                    _parseTowerName(m.from), 
                    _parseTowerName(m.to)
                  ))
              .toList(),
        ),
      );
    } else {
      // Use local solver as fallback for any API failure (network issues, server errors, etc.)
      try {
        final localSolution = await solveHanoiLocally(disks);
        return Success(localSolution);
      } catch (e) {
        return Failure(Exception("API unavailable and local solver failed: $e"));
      }
    }
  }

  Future<Solution> solveHanoiLocally(int disks) async {
    final movesList = await compute(_solveHanoiInIsolate, disks);
    final moves = <Move>[];
    
    for (final move in movesList) {
      moves.add(Move(
        move['description'],
        move['disk'],
        move['from'],
        move['to'],
        _parseTowerName(move['from']),
        _parseTowerName(move['to']),
      ));
    }
    
    return Solution(disks, moves.length, moves);
  }

  static List<Map<String, dynamic>> _solveHanoiInIsolate(int disks) {
    return _solveHanoiRecursive(disks, 'A', 'C', 'B');
  }

  static List<Map<String, dynamic>> _solveHanoiRecursive(int n, String source, String destination, String auxiliary) {
    if (n == 1) {
      return [{'description': 'Move disk $n from $source to $destination', 'disk': n, 'from': source, 'to': destination}];
    }
    
    final moves = <Map<String, dynamic>>[];
    moves.addAll(_solveHanoiRecursive(n-1, source, auxiliary, destination));
    moves.add({'description': 'Move disk $n from $source to $destination', 'disk': n, 'from': source, 'to': destination});
    moves.addAll(_solveHanoiRecursive(n-1, auxiliary, destination, source));
    
    return moves;
  }

  int _parseTowerName(String towerName) {
    switch (towerName.toUpperCase()) {
      case 'A': return 0;
      case 'B': return 1;
      case 'C': return 2;
      default: return 0;
    }
  }
}
