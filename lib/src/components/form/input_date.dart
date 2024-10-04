import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ebom/src/config/app_colors.dart';
// For formatting date

class InputDate extends StatefulWidget {
  final String label;
  final String placeholder;
  final void Function(String) onChanged;

  const InputDate({
    required this.onChanged,
    required this.label,
    required this.placeholder,
  });

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  final TextEditingController _dateController = TextEditingController();

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Earliest date for birthdate
      lastDate: DateTime.now(), // Latest date for birthdate (current date)
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate); // Format date
        widget.onChanged(_dateController.text);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _dateController,
          readOnly:
              true, // Make the field read-only so user can't edit manually
          decoration: InputDecoration(
            hintText: widget.placeholder,
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.primary, // Set the color to AppColors.primary
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.borderGray, // Define the border color
                width: 2.0, // Define the border width
              ),
              borderRadius: BorderRadius.circular(16.0), // Set border radius
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color:
                    AppColors.primary, // Define the border color when focused
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(
                16.0,
              ), // Keep the border radius on focus
            ),
          ),
          onTap: () {
            _selectDate(context); // Show date picker when tapped
          },
        ),
      ],
    );
  }
}
