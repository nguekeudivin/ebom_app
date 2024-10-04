import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class ContactInfo extends StatelessWidget {
  final String userName;
  final String phoneNumber;
  final String address;
  final String email;

  const ContactInfo({
    required this.userName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the logo at the top

          // User name
          _contactDetail(
            icon: Icons.person,
            label: 'Name',
            value: userName,
          ),

          const SizedBox(height: 12),

          // Phone number
          _contactDetail(
            icon: Icons.phone,
            label: 'Phone',
            value: phoneNumber,
          ),

          const SizedBox(height: 12),

          // Address
          _contactDetail(
            icon: Icons.location_on,
            label: 'Address',
            value: address,
          ),

          const SizedBox(height: 12),

          // Email address
          _contactDetail(
            icon: Icons.email,
            label: 'Email',
            value: email,
          ),
        ],
      ),
    );
  }

  // Helper widget for contact details
  Widget _contactDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
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
