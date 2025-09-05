import 'package:flutter/material.dart';

class PegWidget extends StatelessWidget {
  const PegWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}