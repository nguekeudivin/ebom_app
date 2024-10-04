import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _receivedNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Parametres',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              SettingsItem(
                  text: 'Notifications',
                  value: _receivedNotification,
                  setValue: (value) {
                    setState(
                      () {
                        _receivedNotification = value;
                      },
                    );
                  }),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget SettingsItem({
  required String text,
  required bool value,
  required void Function(bool) setValue,
}) {
  return SizedBox(
    height: 48,
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        Switch(
            value: value,
            onChanged: (value) {
              setValue(value);
              // setState(() {
              //   isSwitched = value;
              // });
            },
            activeColor: AppColors.primary,
            activeTrackColor: const Color.fromARGB(255, 143, 209, 250),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.borderGray),
      ],
    ),
  );
}
