import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class SnapshotLoader extends StatelessWidget {
  final Widget Function() builder;
  final AsyncSnapshot<dynamic> snapshot;
  final String errorMessage;
  final String notFoundMessage;
  const SnapshotLoader({
    required this.builder,
    required this.snapshot,
    this.errorMessage = "Une erreur c'est produite",
    this.notFoundMessage = 'Une information disponible',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(errorMessage),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Container(
        width: double.infinity,
        color: AppColors.gray200,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(notFoundMessage),
      );
    }
    return builder();
  }
}
