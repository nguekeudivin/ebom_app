import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class ContactDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const ContactDetail(
      {required this.icon,
      required this.label,
      required this.value,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24), // Icon for the detail
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
