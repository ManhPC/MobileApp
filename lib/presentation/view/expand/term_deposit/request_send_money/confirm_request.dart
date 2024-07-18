// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/data/services/insertMoneySaving.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/list_send_money/list_send_money.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/request_send_money/request_send_money.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmRequest extends StatefulWidget {
  ConfirmRequest({
    super.key,
    required this.acctno,
    required this.moneySend,
    required this.bankChoice,
    required this.busDate,
    required this.kyhan,
    required this.nameKyhan,
    required this.httaituc,
    required this.nameHttt,
    required this.rate,
    required this.ngaydaohan,
  });

  String acctno;
  String moneySend;
  String bankChoice;
  String busDate;
  String kyhan;
  String nameKyhan;
  String httaituc;
  String nameHttt;
  double rate;
  String ngaydaohan;

  @override
  State<ConfirmRequest> createState() => _ConfirmRequestState();
}

class _ConfirmRequestState extends State<ConfirmRequest> {
  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    String localename = appLocal.localeName;
    return Scaffold(
      appBar: appBar(text: appLocal.requestSendMoney('title')),
      body: Container(
        // height: 278,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text2(
                titleText: appLocal.requestSendMoney('account'),
                contentText: widget.acctno),
            Text2(
                titleText: appLocal.requestSendMoney('depositamount'),
                contentText: widget.moneySend),
            Text2(
                titleText: appLocal.requestSendMoney('bank'),
                contentText: widget.bankChoice),
            Text2(
                titleText: appLocal.requestSendMoney('daterequest'),
                contentText: DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(widget.busDate))),
            Text2(
              titleText: appLocal.requestSendMoney('depositterm'),
              contentText: widget.nameKyhan,
            ),
            Text2(
              titleText: appLocal.requestSendMoney('renewal'),
              contentText: widget.nameHttt,
            ),
            Text2(
              titleText: appLocal.requestSendMoney('interestRate'),
              contentText: "${widget.rate} %/1 năm",
            ),
            Text2(
                titleText: appLocal.requestSendMoney('maturitydate'),
                contentText: DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(widget.ngaydaohan))),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 180,
                  child: customTextStyleBody(
                    text: appLocal.requestSendMoney('receiveAccount'),
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w400,
                    txalign: TextAlign.start,
                    maxLines: 2,
                  ),
                ),
                customTextStyleBody(
                  text: widget.acctno,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(163.5),
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color:
                        Theme.of(context).buttonTheme.colorScheme!.background,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: customTextStyleBody(
                text: appLocal.buttonForm('cancel'),
                size: 14,
                color: Theme.of(context).buttonTheme.colorScheme!.background,
                fontWeight: FontWeight.w500,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(163.5),
                backgroundColor:
                    Theme.of(context).buttonTheme.colorScheme!.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final response = await InsertMoneySaving(
                    widget.acctno,
                    int.parse(widget.moneySend.replaceAll(',', '')),
                    widget.bankChoice,
                    "",
                    widget.acctno.replaceRange(
                        widget.acctno.length - 2, widget.acctno.length, ""),
                    widget.httaituc,
                    widget.kyhan,
                    "");
                if (response.statusCode == 200 &&
                    response.data['errorCode'] == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 40),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            customTextStyleBody(
                              text: localename == 'vi'
                                  ? "Giao dịch thành công"
                                  : "Successful transaction",
                              size: 18,
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: 311,
                              height: 158,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Column(
                                children: [
                                  Text2(
                                      titleText: appLocal
                                          .requestSendMoney('depositamount'),
                                      contentText: widget.moneySend),
                                  Text2(
                                      titleText:
                                          appLocal.requestSendMoney('bank'),
                                      contentText: widget.bankChoice),
                                  Text2(
                                      titleText: appLocal
                                          .requestSendMoney('interestRate'),
                                      contentText: "${widget.rate} %/1 năm"),
                                  Text2(
                                      titleText: appLocal
                                          .requestSendMoney('depositterm'),
                                      contentText: widget.nameKyhan),
                                  SizedBox(
                                    height: 22,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        customTextStyleBody(
                                          text: appLocal
                                              .requestSendMoney('maturitydate'),
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .color!,
                                          fontWeight: FontWeight.w400,
                                          size: 14,
                                        ),
                                        customTextStyleBody(
                                          text: DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(widget.ngaydaohan),
                                          ),
                                          fontWeight: FontWeight.w500,
                                          size: 14,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .background,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fixedSize: const Size(180, 36),
                              ),
                              onPressed: () {
                                for (var i = 0; i < 2; i++) {
                                  Navigator.of(context).pop();
                                }
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => RequestSendMoney(
                                        bankName: "", kyhan: ""),
                                  ),
                                );
                              },
                              child: customTextStyleBody(
                                text: localename == 'vi'
                                    ? "Chuyển thêm"
                                    : "Transfer more",
                                size: 14,
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextButton(
                              onPressed: () {
                                for (var i = 0; i < 2; i++) {
                                  Navigator.of(context).pop();
                                }
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const ListSendMoney(),
                                  ),
                                );
                              },
                              child: customTextStyleBody(
                                text: localename == 'vi'
                                    ? "Lịch sử giao dịch"
                                    : "Transaction history",
                                size: 14,
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  print("Lỗi");
                }
              },
              child: customTextStyleBody(
                text: appLocal.buttonForm('confirm'),
                size: 14,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Text2 extends StatelessWidget {
  Text2({
    super.key,
    required this.titleText,
    required this.contentText,
  });
  String titleText;
  String contentText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: titleText,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
          ),
          customTextStyleBody(
            text: contentText,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
