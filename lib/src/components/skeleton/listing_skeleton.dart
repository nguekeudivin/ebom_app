import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListingSkeleton extends StatelessWidget {
  const ListingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(4, (index) {
        // Simulating 4 rows of placeholders
        return CustomListRow(
          px: 16,
          gap: 16,
          children: List.generate(
            2, // Simulating 2 columns per row
            (colIndex) {
              return Container(
                width: 150,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 150,
                        height: 120,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 80,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
