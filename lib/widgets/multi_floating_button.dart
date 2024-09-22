import 'package:flutter/material.dart';

class MultiFloatingButton extends StatelessWidget {
  final List<IconData> icon;
  final int size;
  final void Function(int) onClickListener;

  const MultiFloatingButton({
    super.key,
    required this.icon,
    required this.onClickListener,
    this.size = 30,
  });

  Widget floatingButton(int index) {
    return FloatingActionButton(
      onPressed: () {
        onClickListener(index);
      },
      shape: const CircleBorder(),
      child: Icon(
        icon[index],
        size: size.toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: icon.asMap().entries.map((element) {
      return Align(
          alignment: Alignment(Alignment.bottomRight.x,
              Alignment.bottomRight.y - (0.3 * element.key)),
          child: floatingButton(element.key));
    }).toList());
  }
}
