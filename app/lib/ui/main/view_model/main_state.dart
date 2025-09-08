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
  final int manualMoveCount;
  final int animationSpeedMs;

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
    this.manualMoveCount = 0,
    this.animationSpeedMs = 300,
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
    int? manualMoveCount,
    int? animationSpeedMs,
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
      manualMoveCount: manualMoveCount ?? this.manualMoveCount,
      animationSpeedMs: animationSpeedMs ?? this.animationSpeedMs,
    );
  }

  bool get isManuallyCompleted {
    // Check if all disks are on tower C (index 2) and game is completed
    return isGameCompleted && 
           towers[2].length == disks && 
           playbackState == PlaybackState.idle;
  }

  int get minimumMoves => (1 << disks) - 1;
  
  String get estimatedCompletionTime {
    if (playbackState != PlaybackState.playing) return "";
    
    int remainingMoves = solution.movesCount - currentMoveIndex;
    int totalTimeMs = remainingMoves * animationSpeedMs;
    
    if (totalTimeMs < 1000) {
      return "~${(totalTimeMs / 1000).toStringAsFixed(1)}s remaining";
    } else if (totalTimeMs < 60000) {
      return "~${(totalTimeMs / 1000).round()}s remaining";
    } else if (totalTimeMs < 3600000) { // Less than 1 hour
      int minutes = (totalTimeMs / 60000).floor();
      int seconds = ((totalTimeMs % 60000) / 1000).round();
      return "~${minutes}m ${seconds}s remaining";
    } else if (totalTimeMs < 86400000) { // Less than 1 day
      int hours = (totalTimeMs / 3600000).floor();
      int minutes = ((totalTimeMs % 3600000) / 60000).round();
      return "~${hours}h ${minutes}m remaining";
    } else if (totalTimeMs < 31536000000) { // Less than 1 year (365 days)
      int days = (totalTimeMs / 86400000).floor();
      int hours = ((totalTimeMs % 86400000) / 3600000).round();
      return "~${days}d ${hours}h remaining";
    } else {
      int years = (totalTimeMs / 31536000000).floor();
      int days = ((totalTimeMs % 31536000000) / 86400000).round();
      return "~${years}y ${days}d remaining";
    }
  }
}
