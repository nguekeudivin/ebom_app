import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageSkeleton extends StatelessWidget {
  const ImageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 200, // Match your image width
        height: 200, // Match your image height
        color: Colors.white,
      ),
    );
  }
}
