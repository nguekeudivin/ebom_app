import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/service.dart';
import 'package:ebom/src/screens/services/service_details_screen.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';

class ServiceResultItem extends StatelessWidget {
  final int index;
  final ResultItem item;
  const ServiceResultItem({required this.index, required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: index == 0
          ? const EdgeInsets.only(top: 24, bottom: 12)
          : const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailsScreen(
                service: Service.fromDynamic(item.data),
              ),
            ),
          );
        },
        child: Row(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  item.data['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.data['nom'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  truncate(item.data['description'] ?? '', 30),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  item.data['prix'] != null ? '${item.data['prix']} XAF' : '',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
