// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class titleText extends StatelessWidget {
  titleText({
    super.key,
    required this.text,
  });
  String text;
  @override
  Widget build(BuildContext context) {
    return customTextStyleBody(
      text: text,
      size: 10,
      color: Theme.of(context).textTheme.titleSmall!.color!,
    );
  }
}
