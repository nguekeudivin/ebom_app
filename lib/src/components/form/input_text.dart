import 'package:ebom/src/components/form/input_text_field.dart';
import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;

  const InputText({
    required this.label,
    required this.placeholder,
    required this.controller,
    super.key,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        InputTextField(
          controller: widget.controller,
          hintText: widget.placeholder, // Use the placeholder argument
        ),
      ],
    );
  }
}
