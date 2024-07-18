// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/moneySaving.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/request_send_money/request_send_money.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendMoneyDetail extends StatefulWidget {
  SendMoneyDetail({
    super.key,
    required this.pSavingId,
    required this.bankCode,
    required this.bankname,
    required this.afacctno,
    required this.moneySend,
    required this.rate_val,
    required this.rate,
    required this.period_Name,
    required this.frDate,
    required this.toDate,
    required this.hinhThucDaoHan_Name,
    required this.numReNew,
    required this.status,
    required this.status_Name,
  });
  String pSavingId;
  String bankCode;
  String bankname;
  String afacctno;
  String moneySend;
  int rate_val;
  double rate;
  String period_Name;
  String frDate;
  String toDate;
  String hinhThucDaoHan_Name;
  int numReNew;
  String status;
  String status_Name;

  @override
  State<SendMoneyDetail> createState() => _SendMoneyDetailState();
}

class _SendMoneyDetailState extends State<SendMoneyDetail> {
  bool checkRut = false;
  bool checkGui = false;
  bool checkHuy = false;
  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    if (widget.status == "P") {
      setState(() {
        checkHuy = true;
      });
    } else if (widget.status == "A") {
      setState(() {
        checkRut = true;
      });
    } else {
      setState(() {
        checkGui = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocal.listSendMoney('title2')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary,
            ),
            margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/bank/${widget.bankCode}.svg',
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextStyleBody(
                              text: appLocal.listSendMoney('account'),
                              size: 12,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .color!,
                              fontWeight: FontWeight.w400,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            customTextStyleBody(
                              text: widget.afacctno,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        )
                      ],
                    ),
                    customTextStyleBody(
                      text:
                          "${Utils().formatNumber(int.parse(widget.moneySend))} VND",
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: appLocal.listSendMoney('maturitydate'),
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(widget.toDate)),
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: appLocal.listSendMoney('interestRate'),
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: "${widget.rate} %/năm",
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.onBackground,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.background,
                ),
                onPressed: checkRut
                    ? () {
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: customTextStyleBody(
                                text: "Rút tiền tiết kiệm trước hạn",
                                color: Theme.of(context).secondaryHeaderColor,
                                size: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  RutTienDetail(
                                    contentTitle: "Tài khoản",
                                    contentContent: widget.afacctno,
                                  ),
                                  RutTienDetail(
                                    contentTitle: "Số tiền gửi",
                                    contentContent: Utils().formatNumber(
                                        int.parse(widget.moneySend)),
                                  ),
                                  RutTienDetail(
                                    contentTitle: "Lãi",
                                    contentContent: "${widget.rate_val}",
                                  ),
                                  RutTienDetail(
                                    contentTitle: "Tổng tiền nhận",
                                    contentContent: Utils().formatNumber(
                                        int.parse(widget.moneySend) +
                                            widget.rate_val),
                                  ),
                                ],
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: customTextStyleBody(
                                    text: "Đóng",
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    size: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () async {
                                    final res = await WithdrawMoneyBeforePeriod(
                                        "", widget.pSavingId, "");
                                    if (res.statusCode == 200 &&
                                        res.data['errorCode'] == 0) {
                                      fToast.showToast(
                                        child: msgNotification(
                                          color: Colors.green,
                                          icon: Icons.check_circle,
                                          text: "Thành công",
                                        ),
                                        gravity: ToastGravity.TOP,
                                        toastDuration:
                                            const Duration(seconds: 2),
                                      );
                                      Navigator.of(context).pop();
                                    } else {
                                      fToast.showToast(
                                        child: msgNotification(
                                          color: Colors.red,
                                          icon: Icons.error,
                                          text: res.data['errorMsg'],
                                        ),
                                        gravity: ToastGravity.TOP,
                                        toastDuration:
                                            const Duration(seconds: 2),
                                      );
                                    }
                                  },
                                  child: customTextStyleBody(
                                    text: "Xác nhận",
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    size: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : null,
                child: customTextStyleBody(
                  text: appLocal.buttonForm('withdrawsMoney'),
                  color: checkRut
                      ? Theme.of(context).buttonTheme.colorScheme!.primary
                      : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.onBackground,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.background,
                ),
                onPressed: checkGui
                    ? () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => RequestSendMoney(
                              bankName: "",
                              kyhan: null,
                            ),
                          ),
                        );
                      }
                    : null,
                child: customTextStyleBody(
                  text: appLocal.buttonForm('sendMoney'),
                  color: checkGui
                      ? Theme.of(context).buttonTheme.colorScheme!.primary
                      : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.onBackground,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.background,
                ),
                onPressed: checkHuy
                    ? () async {
                        final response = await RefuseMoneySaving(
                            widget.pSavingId, widget.afacctno);
                        if (response.statusCode == 200 &&
                            response.data['errorCode'] == 0) {
                          fToast.showToast(
                            child: msgNotification(
                              color: Colors.green,
                              icon: Icons.check_circle,
                              text: "Thành công",
                            ),
                            gravity: ToastGravity.TOP,
                            toastDuration: const Duration(seconds: 2),
                          );
                          for (var i = 0; i < 2; i++) {
                            Navigator.of(context).pop();
                          }
                        } else {
                          fToast.showToast(
                            child: msgNotification(
                              color: Colors.red,
                              icon: Icons.error,
                              text: response.data['errorMessage'],
                            ),
                            gravity: ToastGravity.TOP,
                            toastDuration: const Duration(seconds: 2),
                          );
                        }
                      }
                    : null,
                child: customTextStyleBody(
                  text: appLocal.buttonForm('cancel2'),
                  color: checkHuy
                      ? Theme.of(context).buttonTheme.colorScheme!.primary
                      : Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary,
            ),
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text1(
                  text: appLocal.listSendMoney('accountdetail'),
                  color: Theme.of(context).primaryColor,
                  size: 18,
                  fw: FontWeight.w700,
                  bottom: 8,
                ),
                text1(
                  text: appLocal.listSendMoney('account'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text: widget.afacctno,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                  fw: FontWeight.w500,
                ),
                SizedBox(
                  height: 8,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                text1(
                  text: appLocal.listSendMoney('bank'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text: widget.bankname,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                  fw: FontWeight.w500,
                ),
                SizedBox(
                  height: 8,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                text1(
                  text: appLocal.listSendMoney('depositamount'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text:
                      "${Utils().formatNumber(int.parse(widget.moneySend))} VND",
                  color: Theme.of(context).primaryColor,
                  size: 16,
                  fw: FontWeight.w500,
                ),
                SizedBox(
                  height: 8,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                text1(
                  text: appLocal.listSendMoney('interest'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text: "${widget.rate_val} VND",
                  color: Theme.of(context).primaryColor,
                  size: 16,
                  fw: FontWeight.w500,
                ),
                SizedBox(
                  height: 8,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                text1(
                  text: appLocal.listSendMoney('interestRate'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text: "${widget.rate} %/năm",
                  color: Theme.of(context).primaryColor,
                  size: 16,
                  fw: FontWeight.w500,
                ),
                SizedBox(
                  height: 8,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                text1(
                  text: appLocal.listSendMoney('term'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text: widget.period_Name,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                  fw: FontWeight.w500,
                ),
                SizedBox(
                  height: 8,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                text1(
                  text: appLocal.listSendMoney('renewal'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text: widget.hinhThucDaoHan_Name,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                  fw: FontWeight.w500,
                ),
                SizedBox(
                  height: 8,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                text1(
                  text: appLocal.listSendMoney('maturitydate'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text: DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(widget.toDate)),
                  color: Theme.of(context).primaryColor,
                  size: 16,
                  fw: FontWeight.w500,
                ),
                SizedBox(
                  height: 8,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                text1(
                  text: appLocal.listSendMoney('renewalNumber'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text: "${widget.numReNew}",
                  color: Theme.of(context).primaryColor,
                  size: 16,
                  fw: FontWeight.w500,
                ),
                SizedBox(
                  height: 8,
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                text1(
                  text: appLocal.listSendMoney('status'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fw: FontWeight.w400,
                ),
                text1(
                  text: widget.status_Name,
                  color: (widget.status == "A")
                      ? Colors.green
                      : (widget.status == "P")
                          ? Colors.orange
                          : (widget.status == "C")
                              ? Theme.of(context).primaryColor
                              : Colors.red, // R:tuchoi U:huybo X: xoa
                  size: 16,
                  fw: FontWeight.w500,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RutTienDetail extends StatelessWidget {
  RutTienDetail({
    super.key,
    required this.contentTitle,
    required this.contentContent,
  });

  String contentTitle;
  String contentContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: contentTitle,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 160) / 2,
            child: customTextStyleBody(
              text: contentContent,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              txalign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class text1 extends StatelessWidget {
  text1({
    super.key,
    required this.text,
    required this.color,
    required this.size,
    required this.fw,
    this.bottom = 0,
  });
  String text;
  Color color;
  double size;

  FontWeight fw;
  double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom, left: 16, right: 16),
      child: customTextStyleBody(
        text: text,
        color: color,
        size: size,
        fontWeight: fw,
      ),
    );
  }
}
