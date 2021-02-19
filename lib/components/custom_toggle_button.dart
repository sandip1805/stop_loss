import 'package:flutter/material.dart';

class CustomToggleButton extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Function onPressed;

  const CustomToggleButton({Key key, this.data, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(10),
      onPressed: onPressed,
      isSelected: data.map((x) => x['isSelected'] as bool).toList(),
      children: data
          .map(
            (x) => x['widget'] as Widget,
          )
          .toList(),
    );
  }
}
