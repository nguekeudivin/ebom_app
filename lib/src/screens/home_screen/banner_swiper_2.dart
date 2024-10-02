import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/resources/app_assets.dart';
import 'package:flutter/material.dart';

class BannerSwiper2 extends StatelessWidget {
  const BannerSwiper2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderGray),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                index % 2 == 0 ? AppAssets.bannerGirl : AppAssets.bannerSamsung,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
