import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategorieSkeleton extends StatelessWidget {
  const CategorieSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130, // Match the width of the original widget
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular icon placeholder
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30), // Circular shape
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Text placeholder
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 14,
                width: 100, // Approximate width for text
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
