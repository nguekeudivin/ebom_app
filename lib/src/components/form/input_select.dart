import 'package:flutter/material.dart';
import 'package:ebom/src/config/app_colors.dart';

// Make this component parametric. The parametter represent the value.

class SelectOption {
  final dynamic value;
  final String label;
  SelectOption({this.label = '', this.value});
}

class InputSelect extends StatefulWidget {
  final String label;
  final String placeholder;
  final List<SelectOption> options;
  final dynamic value;
  final void Function(dynamic) onChanged;

  const InputSelect({
    required this.onChanged,
    required this.label,
    required this.options,
    this.placeholder = '',
    this.value,
    super.key,
  });

  @override
  State<InputSelect> createState() => _InputSelectState();
}

class _InputSelectState extends State<InputSelect> {
  dynamic _selectedValue;

  @override
  Widget build(BuildContext context) {
    if (_selectedValue != widget.value) {
      setState(() {
        _selectedValue = widget.value;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label, // Use the label argument
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        DropdownButtonFormField(
          hint: Text(widget.placeholder),
          decoration: InputDecoration(
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          value: _selectedValue, // Define the selected value
          items: widget.options.map((SelectOption option) {
            return DropdownMenuItem<String>(
              value: option.value,
              child: Text(option.label),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
