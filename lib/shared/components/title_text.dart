import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;

  const TitleText({
    required this.title,
  });
  
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'avenir',
        fontSize: 32,
        fontWeight: FontWeight.w900),
    );
  }
}