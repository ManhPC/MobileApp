import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nvs_trading/data/services/localTransfer.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ConfirmTransferIn extends StatefulWidget {
  ConfirmTransferIn({
    super.key,
    required this.moneySend,
    required this.acctnoRecv,
    required this.acctnoSend,
    required this.contentSend,
  });

  String moneySend;
  String acctnoSend;
  String acctnoRecv;
  String contentSend;
  @override
  State<ConfirmTransferIn> createState() => _ConfirmTransferInState();
}

class _ConfirmTransferInState extends State<ConfirmTransferIn> {
  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: "Thông tin giao dịch"),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).colorScheme.primary,
        ),
        margin: const EdgeInsets.only(
          top: 16,
          right: 16,
          left: 16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextStyleBody(
                  text: appLocal.transferMoneyIn('transAmount'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                customTextStyleBody(
                  text: widget.moneySend,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextStyleBody(
                  text: appLocal.transferMoneyIn('transFee'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(width: 12),
                customTextStyleBody(
                  text: '0 VND',
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                customTextStyleBody(
                  text: appLocal.transferMoneyIn('totalAmount'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(width: 12),
                customTextStyleBody(
                  text: widget.moneySend,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                customTextStyleBody(
                  text: appLocal.transferMoneyIn('fromAccount'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(width: 12),
                customTextStyleBody(
                  text: widget.acctnoSend,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextStyleBody(
                  text: appLocal.transferMoneyIn('toAccount'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(width: 12),
                customTextStyleBody(
                  text: widget.acctnoRecv,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextStyleBody(
                  text: appLocal.transferMoneyIn('transDes'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: customTextStyleBody(
                    text: widget.contentSend,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    txalign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).buttonTheme.colorScheme!.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: customTextStyleBody(
            text: appLocal.buttonForm('confirm'),
            size: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
          onPressed: () async {
            final response = await LocalTransfer(
                widget.acctnoSend,
                widget.moneySend.replaceAll(RegExp(r','), ''),
                widget.contentSend,
                widget.acctnoRecv);
            print("code : ${response.statusCode}");
            if (response.statusCode == 200) {
              fToast.showToast(
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(seconds: 2),
                child: msgNotification(
                  color: Colors.green,
                  icon: Icons.check_circle,
                  text: "Thành công! ${response.data['message']}",
                ),
              );
              await Future.delayed(const Duration(seconds: 2));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              fToast.showToast(
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(seconds: 2),
                child: msgNotification(
                  color: Colors.red,
                  icon: Icons.error,
                  text: "Thất bại! ${response.data['message']}",
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
