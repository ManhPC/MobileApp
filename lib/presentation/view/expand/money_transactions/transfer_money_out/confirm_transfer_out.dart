import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/generalOTP.dart';
import 'package:nvs_trading/data/services/validateBankTransfer.dart';
import 'package:nvs_trading/presentation/view/shared/otp.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ConfirmTransferOut extends StatefulWidget {
  ConfirmTransferOut({
    super.key,
    required this.moneySend,
    required this.phiGD,
    required this.accountSend,
    required this.bankAccount,
    required this.bankId,
    required this.nameBank,
    required this.contentSend,
  });
  String moneySend;
  String phiGD;
  String accountSend;
  String bankAccount;
  String bankId;
  String nameBank;
  String contentSend;

  @override
  State<ConfirmTransferOut> createState() => _ConfirmTransferOutState();
}

class _ConfirmTransferOutState extends State<ConfirmTransferOut> {
  late FToast fToast;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(
        text: local.localeName == 'vi'
            ? "Thông tin giao dịch"
            : "Transaction information",
      ),
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
                  text: local.transferMoneyToBank('transAmount'),
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
                  text: local.transferMoneyToBank('transFee'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                customTextStyleBody(
                  text: widget.phiGD,
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
                  text: local.transferMoneyToBank('totalAmount'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                customTextStyleBody(
                  text: Utils().formatNumber(
                      int.parse(widget.moneySend.replaceAll(RegExp(r','), '')) +
                          int.parse(widget.phiGD.replaceAll(RegExp(r','), ''))),
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
                  text: local.transferMoneyToBank('fromAccount'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                customTextStyleBody(
                  text: widget.accountSend,
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
                  text: local.transferMoneyToBank('toAccount'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                customTextStyleBody(
                  text: "${widget.bankAccount} - ${widget.bankId}",
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
                  text: local.transferMoneyToBank('recvBank'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                customTextStyleBody(
                  text: widget.nameBank,
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
                  text: local.transferMoneyToBank('transDes'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 48) / 2,
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
            text: local.buttonForm('confirm'),
            size: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
          onPressed: () async {
            final response = await validateBankTransfer(
              widget.accountSend,
              widget.bankAccount,
              widget.bankId,
              widget.moneySend.replaceAll(RegExp(r','), ''),
            );
            if (response == "success") {
              final res = await generalOTPAuth('TRANSFERMONEY', "", "", "",
                  HydratedBloc.storage.read('token'));
              print(res);
              if (response.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OTP(
                      options: 'moneyoutbank',
                      responseData: res,
                      type: "TRANSFERMONEY",
                      acctno: widget.accountSend,
                      bankAccTno: widget.bankAccount,
                      bankId: widget.bankId,
                      feeType: 'T',
                      moneyTranfer:
                          widget.moneySend.replaceAll(RegExp(r','), ''),
                      note: widget.contentSend,
                    ),
                  ),
                );
              }
            } else {
              fToast.showToast(
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(seconds: 2),
                child: msgNotification(
                  color: Colors.red,
                  icon: Icons.error,
                  text: response,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
