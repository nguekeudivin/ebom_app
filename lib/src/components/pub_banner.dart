import 'package:flutter/material.dart';

class PubBanner extends StatelessWidget {
  final String image;
  final BorderRadius borderRadius;
  const PubBanner({
    required this.image,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: AppColors.borderGray, // Set the border color
        //   width: 2, // Set the border width
        // ),
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
