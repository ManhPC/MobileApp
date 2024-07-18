// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

Future<dynamic> dialog_request(BuildContext context, String titleText,
    String contentText, VoidCallback handleOK) {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: customTextStyleBody(
        text: titleText,
        size: 16,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      content: customTextStyleBody(
        text: contentText,
        color: Theme.of(context).primaryColor,
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: customTextStyleBody(
            text: "Đóng",
            color: Theme.of(context).secondaryHeaderColor,
            size: 16,
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            handleOK();
            Navigator.of(context).pop();
          },
          child: customTextStyleBody(
            text: "Xác nhận",
            color: Theme.of(context).secondaryHeaderColor,
            size: 16,
          ),
        ),
      ],
    ),
  );
}
