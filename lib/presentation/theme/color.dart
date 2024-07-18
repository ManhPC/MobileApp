import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    var hexColorConverted = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColorConverted.length == 6) {
      hexColorConverted = 'FF$hexColorConverted';
    }
    return int.parse(hexColorConverted, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

final nvsColorsLight = NvsColor(
    backgroundLight: HexColor('#FFFFFF'),
    backgroundDark: HexColor('#F2F3F4'),
    green200: HexColor('#0FB159').withOpacity(0.15),
    green500: HexColor('#0FB159'),
    primary200: HexColor('#744A9D').withOpacity(0.15),
    primary500: HexColor('#744A9D'),
    red200: HexColor('#DD2E16').withOpacity(0.15),
    red500: HexColor('##DD2E16'),
    teal200: HexColor('#03B8B8').withOpacity(0.15),
    teal500: HexColor('#03B8B8'),
    white: Colors.white,
    text: Colors.black,
    text100: HexColor('##F5F6F6'),
    text200: HexColor('#E5E7E8'),
    text300: HexColor('#A6ACB2'),
    text400: HexColor('#808890'),
    text500: HexColor('#22313F'),
    violet200: HexColor('#BB33DD').withOpacity(0.15),
    violet500: HexColor('#BB33DD'),
    yellow200: HexColor('#F5BF00').withOpacity(0.15),
    yellow500: HexColor('#F5BF00'),
    backgroundAppbar: HexColor('#744A9D'));

final nvsColorsDark = NvsColor(
    backgroundLight: HexColor('#200F2E'),
    backgroundDark: HexColor('#14071F'),
    green200: HexColor('#4FD08A').withOpacity(0.15),
    green500: HexColor('#4FD08A'),
    primary200: HexColor('#C06FFF').withOpacity(0.15),
    primary500: HexColor('#C06FFF'),
    red200: HexColor('#FF4342').withOpacity(0.15),
    red500: HexColor('##FF4342'),
    teal200: HexColor('#00CCCC').withOpacity(0.15),
    teal500: HexColor('#00CCCC'),
    white: Colors.white,
    text: Colors.white,
    text100: HexColor('#2D1B3A'),
    text200: HexColor('#371F55'),
    text300: HexColor('#6B527C'),
    text400: HexColor('#907E9D'),
    text500: HexColor('#FCF8FF'),
    violet200: HexColor('#7D34B5').withOpacity(0.15),
    violet500: HexColor('#BB33DD'),
    yellow200: HexColor('#CCAC3D').withOpacity(0.15),
    yellow500: HexColor('#CCAC3D'),
    backgroundAppbar: HexColor('#480B83'));

class NvsColor {
  final Color primary500;
  final Color primary200;
  final Color green500;
  final Color green200;
  final Color red500;
  final Color red200;
  final Color violet500;
  final Color violet200;
  final Color yellow500;
  final Color yellow200;
  final Color teal500;
  final Color teal200;
  final Color text500;
  final Color text400;
  final Color text300;
  final Color text200;
  final Color text100;
  final Color text;
  final Color white;
  final Color backgroundLight;
  final Color backgroundDark;
  final Color backgroundAppbar;

  const NvsColor({
    required this.primary500,
    required this.white,
    required this.primary200,
    required this.green500,
    required this.green200,
    required this.red500,
    required this.red200,
    required this.violet500,
    required this.violet200,
    required this.yellow500,
    required this.yellow200,
    required this.teal500,
    required this.teal200,
    required this.text500,
    required this.text400,
    required this.text300,
    required this.text200,
    required this.text100,
    required this.text,
    required this.backgroundLight,
    required this.backgroundDark,
    required this.backgroundAppbar,
  });

  static bool isDarkTheme(context) {
    try {
      final brightness = MediaQuery.of(context).platformBrightness;

      return brightness == Brightness.dark;
    } catch (_) {
      return false;
    }
  }

  factory NvsColor.of(BuildContext context) {
    return isDarkTheme(context) ? nvsColorsDark : nvsColorsLight;
  }
}

final colorRealTime = {
  // 0: gemColorsLight.text,
  1: nvsColorsLight.violet500,
  2: nvsColorsLight.teal500,
  3: nvsColorsLight.yellow500,
  4: nvsColorsLight.red500,
  5: nvsColorsLight.green500,
};
final backgroundColorRealTime = {
  0: Colors.transparent,
  1: nvsColorsLight.violet200,
  2: nvsColorsLight.teal200,
  3: nvsColorsLight.yellow200,
  4: nvsColorsLight.red200,
  5: nvsColorsLight.green200,
};
