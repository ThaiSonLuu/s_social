import 'package:flutter/material.dart';

class TextToImage extends StatelessWidget {
  const TextToImage({
    super.key,
    required this.text,
    this.textSize = 30,
  });

  final String text;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: textSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
