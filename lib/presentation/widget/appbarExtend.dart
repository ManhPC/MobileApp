// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  appBar({super.key, required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: customTextStyleAppbar(
        text: text,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w400,
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          text == "Tra cứu số tài khoản"
              ? Navigator.of(context).popUntil((route) => route.isFirst)
              : Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 14,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
