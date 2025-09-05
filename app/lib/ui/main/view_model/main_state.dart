import 'package:app/domain/models/solution.dart';

class MainState {
  final int disks;
  final List<List<int>> towers;
  final Solution solution;
  final String error;
  final bool isLoading;

  const MainState({
    required this.disks,
    required this.towers,
    required this.solution,
    required this.error,
    required this.isLoading,
  });

  static MainState initial = MainState(
    towers: getInitialTowers(3),
    disks: 3,
    solution: Solution(0, 0, []),
    error: "",
    isLoading: false,
  );

  static List<List<int>> getInitialTowers(int n) {
    List<int> initial = [];
    for (int i = 0; i < n; i++) {
      initial.add(n - i);
    }

    return [
      initial, // Tower A with all disks (largest to smallest, bottom to top)
      [], // Tower B (empty)
      [], // Tower C (empty)
    ];
  }

  MainState copyWith({
    int? disks,
    List<List<int>>? towers,
    Solution? solution,
    String? error,
    bool? isLoading,
  }) {
    return MainState(
      towers: towers ?? this.towers,
      disks: disks ?? this.disks,
      solution: solution ?? this.solution,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
