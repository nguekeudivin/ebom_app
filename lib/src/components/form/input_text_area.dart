import 'package:ebom/src/components/form/input_text_area_field.dart';
import 'package:flutter/material.dart';

class InputTextArea extends StatefulWidget {
  final String label;
  final String? placeholder;
  final TextEditingController controller;
  final int maxLines;

  const InputTextArea({
    required this.label,
    required this.controller,
    this.maxLines = 4,
    this.placeholder = '',
    super.key,
  });

  @override
  State<InputTextArea> createState() => _InputTextAreaState();
}

class _InputTextAreaState extends State<InputTextArea>
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
        InputTextAreaField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          hintText: widget.placeholder ?? '', // Use the placeholder argument
        ),
      ],
    );
  }
}
