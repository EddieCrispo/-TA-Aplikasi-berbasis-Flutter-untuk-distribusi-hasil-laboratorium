import 'package:flutter/material.dart';

class BottomTitlesWidget extends StatelessWidget {
  final List<String> bottomTitles;

  const BottomTitlesWidget({required this.bottomTitles});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: bottomTitles.map((title) {
        return Text(
          title,
          style: style,
        );
      }).toList(),
    );
  }
}
