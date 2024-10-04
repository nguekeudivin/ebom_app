import 'package:flutter/material.dart';

class CustomListRow extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final double px;
  final int cols;

  const CustomListRow({
    required this.children,
    this.gap = 0,
    this.px = 0,
    this.cols = 2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: List.generate(cols, (index) {
        EdgeInsets margin;
        if (index == 0) {
          margin = EdgeInsets.only(
            left: px,
            right: gap / 2,
            top: gap / 2,
            bottom: gap / 2,
          );
        } else if (index == cols - 1) {
          margin = EdgeInsets.only(
            left: gap / 2,
            right: px,
            top: gap / 2,
            bottom: gap / 2,
          );
        } else {
          margin = EdgeInsets.all(gap / 2);
        }

        return Container(
          width: (width - gap * (cols - 1) - 2 * px) / cols,
          margin: margin,
          child: children[index],
        );
      }),
    );
  }
}
