import 'package:flutter/material.dart';

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