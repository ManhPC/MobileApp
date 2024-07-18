// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/tra_no/payLoan.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class NoDetail extends StatefulWidget {
  NoDetail({
    super.key,
    required this.acctno,
    required this.loanid,
    required this.txdate,
    required this.duedate,
    required this.rate,
    required this.daynumber,
    required this.noGoc,
    required this.noLai,
    required this.sodutien,
    required this.tiencotheTT,
    required this.phiUngTienTamTinh,
  });
  String acctno;
  String loanid;
  String txdate;
  String duedate;
  String rate;
  String daynumber;
  String noGoc;
  String noLai;
  String sodutien;
  String tiencotheTT;
  String phiUngTienTamTinh;

  @override
  State<NoDetail> createState() => _NoDetailState();
}

class _NoDetailState extends State<NoDetail> {
  TextEditingController moneyTraNo = TextEditingController();
  bool checkIsEditMoney = false;
  dynamic _errorMoney;

  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    moneyTraNo.addListener(updateValue);
  }

  void updateValue() {
    final text = moneyTraNo.text.replaceAll(RegExp(r','), '');
    if (text.isNotEmpty) {
      checkIsEditMoney = true;
      final value = int.parse(text);
      final formattedValue = Utils().formatNumber(value);
      if (moneyTraNo.text != formattedValue) {
        moneyTraNo.value = moneyTraNo.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      }
      if (value == 0) {
        setState(() {
          _errorMoney = "Số tiền nhập phải khác 0";
        });
      } else if (value > int.parse(widget.sodutien)) {
        setState(() {
          _errorMoney = "Số tiền nhập phải nhỏ hơn số dư tiền";
        });
      } else if (value > (int.parse(widget.noGoc) + int.parse(widget.noLai))) {
        setState(() {
          _errorMoney = "Số tiền nhập phải nhỏ hơn số tiền nợ còn lại";
        });
      } else {
        setState(() {
          _errorMoney = null;
        });
      }
    } else if (checkIsEditMoney == true && text.isEmpty) {
      setState(() {
        _errorMoney = "Số tiền nhập không được để trống";
      });
    }
  }

  @override
  void dispose() {
    moneyTraNo.removeListener(updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Chi tiết khoản vay"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TraNoInfo(title: "Tài khoản", content: widget.acctno),
            TraNoInfo(title: "Số hiệu món vay", content: widget.loanid),
            TraNoInfo(title: "Ngày vay", content: widget.txdate),
            TraNoInfo(title: "Ngày đáo hạn", content: widget.duedate),
            TraNoInfo(title: "Lãi suất", content: '${widget.rate} %'),
            TraNoInfo(title: "Số ngày vay còn lại", content: widget.daynumber),
            TraNoInfo(
                title: "Nợ gốc còn lại",
                content: Utils().formatNumber(int.parse(widget.noGoc))),
            TraNoInfo(
                title: "Nợ lãi còn lại",
                content: Utils().formatNumber(int.parse(widget.noLai))),
            TraNoInfo(
              title: "Tổng dư nợ còn lại",
              content: Utils().formatNumber(
                  int.parse(widget.noGoc) + int.parse(widget.noLai)),
            ),
            SizedBox(
              height: _errorMoney == null ? 40 : 60,
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textAlign: TextAlign.end,
                controller: moneyTraNo,
                cursorColor: Theme.of(context).primaryColor,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  errorText: _errorMoney,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  hintText: "Số tiền",
                  contentPadding: const EdgeInsets.only(left: 8, right: 8),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TraNoInfo(
                title: "Số dư tiền",
                content: Utils().formatNumber(int.parse(widget.sodutien))),
            TraNoInfo(
                title: "Tiền có thể thanh toán",
                content: Utils().formatNumber(int.parse(widget.tiencotheTT))),
            TraNoInfo(
                title: "Phí ứng tiền tạm tính",
                content:
                    Utils().formatNumber(int.parse(widget.phiUngTienTamTinh))),
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: ElevatedButton(
          onPressed: () async {
            if (_errorMoney == null) {
              final res = await payLoan(
                widget.acctno,
                widget.loanid,
                int.parse(
                  moneyTraNo.text.replaceAll(RegExp(r','), ''),
                ),
              );
              if (res != "") {
                fToast.showToast(
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(seconds: 2),
                  child: msgNotification(
                    color: Colors.green,
                    icon: Icons.check_circle,
                    text: res,
                  ),
                );
                await Future.delayed(const Duration(seconds: 2));

                Navigator.of(context).pop(true);
              } else {
                fToast.showToast(
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(seconds: 2),
                  child: msgNotification(
                    color: Colors.red,
                    icon: Icons.error,
                    text: "Thất bại",
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).buttonTheme.colorScheme!.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              )),
          child: customTextStyleBody(
            text: "Thanh toán",
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
            size: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class TraNoInfo extends StatelessWidget {
  TraNoInfo({
    super.key,
    required this.title,
    required this.content,
  });

  String title;
  String content;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: title,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
            size: 16,
          ),
          customTextStyleBody(
            text: content,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
            size: 16,
          ),
        ],
      ),
    );
  }
}
