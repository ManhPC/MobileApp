import 'package:flutter/material.dart';
import 'package:nvs_trading/common/utils/extensions/string_extensions.dart';
import 'package:nvs_trading/presentation/theme/color.dart';

class HighLightColors {
  final Color bgUp;
  final Color bgDown;
  final Color textUp;
  final Color textDown;

  HighLightColors(
      {required this.bgUp,
      required this.bgDown,
      required this.textUp,
      required this.textDown});
}

enum HighLightType { PRICE, VOLUMN }

class HighLight extends StatefulWidget {
  final Widget child;
  final Alignment? alignment;
  final TextStyle? textStyle;
  final double? value;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final HighLightType type;
  final String? symbol;

  const HighLight({
    super.key,
    this.alignment,
    this.textStyle,
    required this.value,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.symbol,
    required this.type,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return _HighLightState();
  }
}

HighLightColors _getFlashColorsPrice(NvsColor colors) {
  return HighLightColors(
    bgUp: colors.green500,
    bgDown: colors.red500,
    textUp: Colors.white,
    textDown: Colors.white,
  );
}

HighLightColors _getFlashColorsVolumn(NvsColor colors) {
  return HighLightColors(
      bgUp: colors.green500,
      bgDown: colors.red500,
      textUp: Colors.white,
      textDown: Colors.white);
}

HighLightColors _getFlashColorsByType(NvsColor colors, HighLightType type) {
  if (type == HighLightType.PRICE) {
    return _getFlashColorsPrice(colors);
  }
  return _getFlashColorsVolumn(colors);
}

class _HighLightState extends State<HighLight> {
  Color? background;
  Color? textColor;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  didUpdateWidget(oldWidget) {
    final value = widget.value ?? 0;
    final oldValue = oldWidget.value ?? 0;
    final symbol = widget.symbol ?? "";
    final oldSymbol = oldWidget.symbol ?? "";
    if (symbol == "" || oldSymbol == "" || oldSymbol != symbol) return;
    if (widget.value == null ||
        oldWidget.value == null ||
        !"${widget.value}".isValidNumber) return;
    if (widget.value != oldWidget.value) {
      final isUp = value > oldValue;
      setState(() {
        final colors = NvsColor.of(context);
        final flashColors = _getFlashColorsByType(colors, widget.type);
        background = isUp ? flashColors.bgUp : flashColors.bgDown;
        textColor = isUp ? flashColors.textUp : flashColors.textDown;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          background = null;
          textColor = null;
        });
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  _getTextStyle() {
    if (widget.textStyle == null) return TextStyle(color: textColor);
    if (textColor == null) return widget.textStyle;
    return widget.textStyle?.copyWith(color: textColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: widget.alignment,
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3), color: background),
        child: DefaultTextStyle(style: _getTextStyle(), child: widget.child));
  }
}
