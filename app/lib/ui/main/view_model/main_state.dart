import 'package:app/domain/models/solution.dart';

enum PlaybackState { idle, playing, paused, completed }

class MainState {
  final int disks;
  final List<List<int>> towers;
  final Solution solution;
  final String error;
  final bool isLoading;
  final PlaybackState playbackState;
  final int currentMoveIndex;
  final String currentMoveDescription;
  final bool isGameCompleted;

  const MainState({
    required this.disks,
    required this.towers,
    required this.solution,
    required this.error,
    required this.isLoading,
    this.playbackState = PlaybackState.idle,
    this.currentMoveIndex = 0,
    this.currentMoveDescription = "",
    this.isGameCompleted = false,
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
    PlaybackState? playbackState,
    int? currentMoveIndex,
    String? currentMoveDescription,
    bool? isGameCompleted,
  }) {
    return MainState(
      towers: towers ?? this.towers,
      disks: disks ?? this.disks,
      solution: solution ?? this.solution,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      playbackState: playbackState ?? this.playbackState,
      currentMoveIndex: currentMoveIndex ?? this.currentMoveIndex,
      currentMoveDescription: currentMoveDescription ?? this.currentMoveDescription,
      isGameCompleted: isGameCompleted ?? this.isGameCompleted,
    );
  }

  bool get isManuallyCompleted {
    // Check if all disks are on tower C (index 2) and game is completed
    return isGameCompleted && 
           towers[2].length == disks && 
           playbackState == PlaybackState.idle;
  }
}
