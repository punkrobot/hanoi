import 'package:flutter/material.dart';

class HanoiGameWidget extends StatefulWidget {
  final int numberOfDisks;
  final List<List<int>> towers;
  final Function(int from, int to)? onDiskMove;
  final bool Function(int from, int to)? canMoveDisk;

  const HanoiGameWidget({
    super.key,
    this.numberOfDisks = 6,
    required this.towers,
    this.onDiskMove,
    this.canMoveDisk,
  });

  @override
  State<HanoiGameWidget> createState() => _HanoiGameWidgetState();
}

class _HanoiGameWidgetState extends State<HanoiGameWidget> {
  int? draggedTower;
  int? hoveredTower;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTower(context, 0, 'A'),
                _buildTower(context, 1, 'B'),
                _buildTower(context, 2, 'C'),
              ],
            ),
          ),
          _buildBase(),
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Text("A"), Text("B"), Text("C")],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTower(BuildContext context, int towerIndex, String label) {
    bool isValidDropZone = draggedTower != null && 
        draggedTower != towerIndex && 
        widget.canMoveDisk?.call(draggedTower!, towerIndex) == true;
    bool isHovered = hoveredTower == towerIndex;

    return Expanded(
      child: DragTarget<int>(
        onWillAccept: (data) {
          if (data == null) return false;
          return widget.canMoveDisk?.call(data, towerIndex) ?? false;
        },
        onAccept: (fromTower) {
          widget.onDiskMove?.call(fromTower, towerIndex);
          setState(() {
            draggedTower = null;
            hoveredTower = null;
          });
        },
        onMove: (details) {
          setState(() {
            hoveredTower = towerIndex;
          });
        },
        onLeave: (data) {
          setState(() {
            hoveredTower = null;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isValidDropZone
                  ? Border.all(color: Colors.green, width: 2)
                  : isHovered && draggedTower != null
                      ? Border.all(color: Colors.red, width: 2)
                      : null,
              color: isValidDropZone && isHovered
                  ? Colors.green.withOpacity(0.1)
                  : isHovered && draggedTower != null
                      ? Colors.red.withOpacity(0.1)
                      : null,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildPeg(),
                ...widget.towers[towerIndex].asMap().entries.map((entry) {
                  int diskIndex = entry.key;
                  int diskSize = entry.value;
                  bool isTopDisk = diskIndex == widget.towers[towerIndex].length - 1;
                  
                  return Positioned(
                    bottom: diskIndex * 25.0,
                    child: isTopDisk
                        ? Draggable<int>(
                            data: towerIndex,
                            onDragStarted: () {
                              setState(() {
                                draggedTower = towerIndex;
                              });
                            },
                            onDragEnd: (details) {
                              setState(() {
                                draggedTower = null;
                                hoveredTower = null;
                              });
                            },
                            feedback: DiskWidget(
                              size: diskSize,
                              totalDisks: widget.numberOfDisks,
                              isDragging: true,
                            ),
                            childWhenDragging: DiskWidget(
                              size: diskSize,
                              totalDisks: widget.numberOfDisks,
                              isPlaceholder: true,
                            ),
                            child: DiskWidget(
                              size: diskSize,
                              totalDisks: widget.numberOfDisks,
                            ),
                          )
                        : DiskWidget(
                            size: diskSize,
                            totalDisks: widget.numberOfDisks,
                          ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeg() {
    return Container(
      width: 8,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildBase() {
    return Container(
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class DiskWidget extends StatelessWidget {
  final int size;
  final int totalDisks;
  final VoidCallback? onTap;
  final bool isDragging;
  final bool isPlaceholder;

  const DiskWidget({
    super.key,
    required this.size,
    required this.totalDisks,
    this.onTap,
    this.isDragging = false,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.pink[300]!,
      Colors.yellow[600]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.blue[400]!,
      Colors.teal[400]!,
    ];

    final double baseWidth = 40.0;
    final double maxWidth = 140.0;
    final double diskWidth =
        baseWidth + (maxWidth - baseWidth) * (size / totalDisks);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: diskWidth,
        height: 20,
        decoration: BoxDecoration(
          color: isPlaceholder 
              ? colors[(size - 1) % colors.length].withOpacity(0.3)
              : colors[(size - 1) % colors.length],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDragging 
                ? Colors.white
                : Colors.white.withOpacity(0.3), 
            width: isDragging ? 2 : 1
          ),
          boxShadow: isDragging ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Center(
          child: Text(
            size.toString(),
            style: TextStyle(
              color: isPlaceholder ? Colors.white.withOpacity(0.5) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}