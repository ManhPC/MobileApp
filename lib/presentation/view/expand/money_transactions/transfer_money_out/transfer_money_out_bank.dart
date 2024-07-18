// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/bank_acctno_info.dart';
import 'package:nvs_trading/data/model/get_account_detail.dart';
import 'package:nvs_trading/data/services/getAccountDetail.dart';
import 'package:nvs_trading/data/services/getBankAcctnoInfo.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/transfer_money_out/confirm_transfer_out.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransferMoneyOutBank extends StatefulWidget {
  TransferMoneyOutBank({
    super.key,
    this.bankId,
  });

  String? bankId;

  @override
  State<TransferMoneyOutBank> createState() => _TransferMoneyOutBankState();
}

class _TransferMoneyOutBankState extends State<TransferMoneyOutBank> {
  String acctno = HydratedBloc.storage.read('acctno');
  String custodycd = HydratedBloc.storage.read('custodycd');

  dynamic accountSend;
  List<GetAccountDetailModel> listAccountDetail = [];

  dynamic bankReceive;
  List<BankAcctnoInfo> listBankAI = [];

  TextEditingController moneySend = TextEditingController();
  bool checkMoney = true;
  bool checkIsEditMoney = false;
  String _errorMoneySend = "";

  TextEditingController contentSend = TextEditingController();
  String feeSend = "0";

  late FToast fToast;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.bankId != null) {
      bankReceive = widget.bankId;
    }
    fToast = FToast();
    fToast.init(context);
    accountSend = acctno;
    moneySend.addListener(updateValue);
    fetchAccount();
    fetchBankAcctno();
  }

  void fetchAccount() async {
    try {
      final response = await GetAccountDetail(custodycd);
      if (response.isNotEmpty) {
        setState(() {
          listAccountDetail = response;
        });
        contentSend.text =
            "${listAccountDetail.first.fullname} TK $accountSend CHUYEN KHOAN";
      } else {
        print("Lỗi account!");
      }
    } catch (e) {
      Future.error(e);
    }
  }

  void fetchBankAcctno() async {
    try {
      final response = await getBankAcctnoInfo(acctno, 'ALL', 'ALL');
      setState(() {
        listBankAI = response;
      });
    } catch (e) {
      Future.error(e);
    }
  }

  void updateValue() {
    final text = moneySend.text.replaceAll(RegExp(r','), '');
    if (text.isNotEmpty) {
      checkIsEditMoney = true;
      final value = int.parse(text);
      final formattedValue = Utils().formatNumber(value);
      if (moneySend.text != formattedValue) {
        moneySend.value = moneySend.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      }
      if (value == 0) {
        setState(() {
          _errorMoneySend = "Số tiền gửi phải khác 0";
          checkMoney = true;
        });
      } else {
        setState(() {
          _errorMoneySend = "";
          checkMoney = false;
        });
      }
      if (checkMoney == false) {
        if (value > 10000000) {
          setState(() {
            checkMoney = true;
          });
        } else {
          setState(() {
            checkMoney = false;
          });
        }
      }
    } else if (checkIsEditMoney == true && text.isEmpty) {
      setState(() {
        _errorMoneySend = "Số tiền gửi không được để trống";
        checkMoney = true;
      });
    }
  }

  @override
  void dispose() {
    moneySend.removeListener(updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: local.transferMoneyToBank('tmtb')),
      body: (listAccountDetail.isEmpty)
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding: const EdgeInsets.only(
                  top: 16, right: 16, left: 16, bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: customTextStyleBody(
                        text: local.transferMoneyToBank('senderInfo'),
                        size: 18,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: local.transferMoneyToBank('sendAccount'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            height: 36,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            padding: const EdgeInsets.only(right: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                value: accountSend,
                                hint: const Text("Chọn tài khoản"),
                                onChanged: (value) {
                                  setState(() {
                                    accountSend = value;
                                    moneySend.clear();
                                    _errorMoneySend = "";
                                    contentSend.text =
                                        "${listAccountDetail.first.fullname} TK $value CHUYEN KHOAN";
                                  });
                                },
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                                isExpanded: true,
                                iconStyleData: IconStyleData(
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconEnabledColor: Theme.of(context).hintColor,
                                  iconSize: 16,
                                ),
                                items: [
                                  for (var i in listAccountDetail)
                                    DropdownMenuItem(
                                      value: i.acctno,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          "${i.acctno} - ${i.fullname}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: local.transferMoneyToBank('aaft'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          customTextStyleBody(
                            text: Utils().formatNumber(listAccountDetail[
                                    listAccountDetail.indexWhere((element) =>
                                        element.acctno == accountSend)]
                                .balance),
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: customTextStyleBody(
                        text: local.transferMoneyToBank('recInfo'),
                        size: 18,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: local.transferMoneyToBank('recvAccount'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            height: 36,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            padding: const EdgeInsets.only(right: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                value: bankReceive,
                                hint: Text(
                                  local.localeName == "vi"
                                      ? "Chọn tài khoản"
                                      : "Choose accout",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    bankReceive = value;
                                  });
                                },
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconEnabledColor: Theme.of(context).hintColor,
                                  iconSize: 16,
                                ),
                                items: [
                                  for (var i in listBankAI)
                                    DropdownMenuItem(
                                      value: i.bankId,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          "${i.bankAccount} - ${i.bankId}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: local.transferMoneyToBank('recvBank'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: customTextStyleBody(
                              text: (bankReceive != null)
                                  ? listBankAI[listBankAI.indexWhere(
                                          (element) =>
                                              element.bankId == bankReceive)]
                                      .bankName
                                  : "",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              txalign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: local.transferMoneyToBank('recName'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: customTextStyleBody(
                              text: (bankReceive != null)
                                  ? listBankAI[listBankAI.indexWhere(
                                          (element) =>
                                              element.bankId == bankReceive)]
                                      .fullName
                                  : "",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              txalign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: local.transferMoneyToBank('transAmount'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            height: (_errorMoneySend != "") ? 56 : 36,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              controller: moneySend,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                hintText: local.localeName == 'vi'
                                    ? "Nhập tiền..."
                                    : "Typing...",
                                hintStyle: const TextStyle(fontSize: 12),
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
                                errorText: (_errorMoneySend != "")
                                    ? _errorMoneySend
                                    : null,
                                errorStyle: const TextStyle(fontSize: 10),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                suffix: Container(
                                  height: 20,
                                  width: 40,
                                  margin:
                                      const EdgeInsets.only(right: 4, top: 4),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          moneySend.text = Utils().formatNumber(
                                              listAccountDetail[
                                                      listAccountDetail
                                                          .indexWhere(
                                                              (element) =>
                                                                  element
                                                                      .acctno ==
                                                                  accountSend)]
                                                  .balance);
                                        },
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .buttonTheme
                                                .colorScheme!
                                                .background),
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.none,
                                      child: customTextStyleBody(
                                        text: (local.localeName == 'vi')
                                            ? "Tối đa"
                                            : "Max",
                                        size: 10,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                                  ),
                                ),
                                isDense: false,
                                contentPadding: const EdgeInsets.only(left: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !checkMoney,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 22,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    moneySend.text =
                                        "${moneySend.value.text}000";
                                  });
                                },
                                child: customTextStyleBody(
                                  text: Utils().formatNumber(int.parse(
                                      "${moneySend.value.text}000"
                                          .replaceAll(',', ''))),
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              height: 22,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    moneySend.text =
                                        "${moneySend.value.text}00000";
                                  });
                                },
                                child: customTextStyleBody(
                                  text: Utils().formatNumber(int.parse(
                                      "${moneySend.value.text}00000"
                                          .replaceAll(',', ''))),
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              height: 22,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    moneySend.text =
                                        "${moneySend.value.text}000000";
                                  });
                                },
                                child: customTextStyleBody(
                                  text: Utils().formatNumber(int.parse(
                                      "${moneySend.value.text}000000"
                                          .replaceAll(',', ''))),
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: local.transferMoneyToBank('transFee'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: customTextStyleBody(
                              text: moneySend.text.isEmpty
                                  ? "0 VND"
                                  : (int.parse(moneySend.text
                                              .replaceAll(RegExp(r','), '')) <
                                          250000)
                                      ? "5,000 VND"
                                      : "${(Utils().formatNumber(((int.parse(moneySend.text.replaceAll(RegExp(r','), '')) * 0.02)).toInt()))} VND",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              txalign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: local.transferMoneyToBank('transDes'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).hintColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextField(
                              cursorColor: Theme.of(context).primaryColor,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              controller: contentSend,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 4, top: 4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
            text: local.buttonForm('continue'),
            size: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
          onPressed: () {
            if (bankReceive == null) {
              fToast.showToast(
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(seconds: 2),
                child: msgNotification(
                  color: Colors.red,
                  icon: Icons.error,
                  text: "Thất bại! Chưa chọn số TK nhận",
                ),
              );
            } else if (moneySend.text.isEmpty) {
              fToast.showToast(
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(seconds: 2),
                child: msgNotification(
                  color: Colors.red,
                  icon: Icons.error,
                  text: "Thất bại! Số tiền chuyển không hợp lệ",
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ConfirmTransferOut(
                    moneySend: moneySend.text,
                    phiGD: moneySend.text.isEmpty
                        ? "0"
                        : (int.parse(moneySend.text
                                    .replaceAll(RegExp(r','), '')) <
                                250000)
                            ? "5,000"
                            : Utils().formatNumber(((int.parse(moneySend.text
                                        .replaceAll(RegExp(r','), '')) *
                                    0.02))
                                .toInt()),
                    accountSend: accountSend,
                    bankAccount: listBankAI[listBankAI.indexWhere(
                            (element) => element.bankId == bankReceive)]
                        .bankAccount,
                    bankId: listBankAI[listBankAI.indexWhere(
                            (element) => element.bankId == bankReceive)]
                        .bankId,
                    nameBank: listBankAI[listBankAI.indexWhere(
                            (element) => element.bankId == bankReceive)]
                        .bankName,
                    contentSend: contentSend.text,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
