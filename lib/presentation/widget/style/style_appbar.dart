// ignore_for_file: must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/theme/themeProvider.dart';
import 'package:provider/provider.dart';

class customTextStyleAppbar extends StatelessWidget {
  customTextStyleAppbar(
      {super.key,
      required this.text,
      this.size = 20,
      this.color = const Color(0xFFFFFFFF),
      this.fontWeight = FontWeight.w700});

  String text;
  double size;
  Color color;
  FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    bool themeMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: themeMode ? color : Colors.black,
        fontWeight: fontWeight,
      ),
    );
  }
}
