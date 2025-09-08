import 'package:flutter/material.dart';

class PegWidget extends StatelessWidget {
  final int disks;

  const PegWidget({super.key, required this.disks});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 50 + disks * 22,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
