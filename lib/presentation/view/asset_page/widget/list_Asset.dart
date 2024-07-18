import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class ListAsset extends StatelessWidget {
  ListAsset({
    super.key,
    required this.text,
    required this.money,
  });
  String text;
  String money;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: text,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: money,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "  VND",
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
