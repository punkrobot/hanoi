import 'package:app/ui/main/widgets/base_widget.dart';
import 'package:app/ui/main/widgets/disk_widget.dart';
import 'package:app/ui/main/widgets/peg_widget.dart';
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
      padding: const EdgeInsets.only(left: 16, bottom: 60, right: 16, top: 16),
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
          const BaseWidget(),
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
    bool isValidDropZone =
        draggedTower != null &&
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
                PegWidget(disks: widget.numberOfDisks),
                ...widget.towers[towerIndex].asMap().entries.map((entry) {
                  int diskIndex = entry.key;
                  int diskSize = entry.value;
                  bool isTopDisk =
                      diskIndex == widget.towers[towerIndex].length - 1;

                  return Positioned(
                    bottom: diskIndex * 22.0,
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
}
