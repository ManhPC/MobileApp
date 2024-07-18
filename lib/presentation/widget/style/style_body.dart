// ignore_for_file: must_be_immutable, camel_case_types

import 'package:flutter/material.dart';

class customTextStyleBody extends StatelessWidget {
  customTextStyleBody({
    super.key,
    required this.text,
    this.size = 14,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.white,
    this.txalign = TextAlign.center,
    this.maxLines,
    this.textOverflow,
  });

  String text;
  double size;
  FontWeight fontWeight;
  Color color;
  TextAlign txalign;
  int? maxLines;
  TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: txalign,
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
