// ignore_for_file: non_constant_identifier_names

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/getInfoCustomer.dart';
import 'package:nvs_trading/data/services/transfer_stock/checkBuyingPower.dart';
import 'package:nvs_trading/data/services/transfer_stock/getSendInfo.dart';
import 'package:nvs_trading/data/services/transfer_stock/setLocalTransfer.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class TransferStock extends StatefulWidget {
  const TransferStock({super.key});

  @override
  State<TransferStock> createState() => _TransferStockState();
}

class _TransferStockState extends State<TransferStock> {
  //acctno send
  String acctno = HydratedBloc.storage.read('acctno');
  List<dynamic> AcctnoInfo = [];
  //acctno receive
  dynamic acctnoReceive;
  List<String> listAcctnoReceive = [];
  List<dynamic> AcctnoRecvInfo = [];
  bool changeAcctno = false;

  //send info
  List<dynamic> responseSendInfo = [];
  //
  List<String> listCK = [];
  var _maCK;

  //KL chuyen toi da
  int tradeqtty_max = 0;
  //KL chuyen
  TextEditingController tradeQtty = TextEditingController();
  bool checkIsEditTQ = false;
  String _errorTQ = "";
  //ds chuyen ck
  List<String> listTransferStock = [];

  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    fetchSendInfo();
    fetchAcctnoRecv();
    fetchBuyingPower();
    tradeQtty.addListener(updateValue);
  }

  @override
  void dispose() {
    tradeQtty.removeListener(updateValue);
    super.dispose();
  }

  void updateValue() {
    final text = tradeQtty.text.replaceAll(RegExp(r','), '');
    if (text.isNotEmpty) {
      checkIsEditTQ = true;
      final value = int.parse(text);
      final formattedValue = Utils().formatNumber(value);
      if (tradeQtty.text != formattedValue) {
        tradeQtty.value = tradeQtty.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      }
      if (value == 0) {
        setState(() {
          _errorTQ = "Số tiền gửi phải khác 0";
        });
      } else {
        setState(() {
          _errorTQ = "";
        });
      }
    } else if (checkIsEditTQ == true && text.isEmpty) {
      setState(() {
        _errorTQ = "Số tiền gửi không được để trống";
      });
    }
  }

  void fetchAcctnoRecv() async {
    final response = await GetInfoCustomer(
      HydratedBloc.storage.read('custodycd'),
      HydratedBloc.storage.read('token'),
    );
    for (var i in response) {
      if (i.acctno != acctno) {
        listAcctnoReceive.add(i.acctno);
      }
    }
  }

  void fetchSendInfo() async {
    try {
      final res = await getSendInfo(acctno);
      if (res.isNotEmpty) {
        setState(() {
          responseSendInfo = res;
        });
      }

      for (var i in responseSendInfo) {
        for (var j in i['data']) {
          listCK.add(j['symbol']);
        }
      }
    } catch (e) {
      Future.error(e);
    }
  }

  void fetchBuyingPower() async {
    try {
      final res = await getBuyingPower(acctno, "");

      if (res.isNotEmpty) {
        setState(() {
          AcctnoInfo = res;
        });
      }
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(responseSendInfo.first['data'][0]['seaccount']);
    //print(AcctnoInfo.first['buyingpower']);
    return Scaffold(
      appBar: appBar(text: "Chuyển chứng khoán"),
      body: (responseSendInfo.isEmpty ||
              AcctnoInfo.isEmpty ||
              (changeAcctno && AcctnoRecvInfo.isEmpty))
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 42,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTextStyleBody(
                                      text: "Tài khoản chuyển",
                                      size: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    customTextStyleBody(
                                      text: acctno,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 70,
                                height: 14,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: customTextStyleBody(
                                    text: "---------->",
                                    color: Theme.of(context).primaryColor,
                                    size: 1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: customTextStyleBody(
                                        text: "Tài khoản nhận",
                                        size: 12,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        isDense: true,
                                        isExpanded: true,
                                        onChanged: (value) async {
                                          setState(() {
                                            acctnoReceive = value;
                                            changeAcctno = true;
                                          });
                                          final res = await getBuyingPower(
                                              acctno, acctnoReceive);
                                          if (res.isNotEmpty) {
                                            setState(() {
                                              AcctnoRecvInfo = res;
                                            });
                                          }
                                        },
                                        iconStyleData: IconStyleData(
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          iconSize: 16,
                                          iconEnabledColor:
                                              Theme.of(context).hintColor,
                                        ),
                                        items: [
                                          for (var i in listAcctnoReceive)
                                            DropdownMenuItem(
                                              value: i,
                                              child: customTextStyleBody(
                                                text: i,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w500,
                                                size: 11,
                                              ),
                                            ),
                                        ],
                                        value: acctnoReceive,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: DottedDecoration(
                            dash: const [5, 5],
                            color: Theme.of(context).hintColor,
                            strokeWidth: 1,
                            linePosition: LinePosition.top,
                          ),
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 90,
                                child: customTextStyleBody(
                                  text: Utils().formatNumber(
                                      AcctnoInfo.first['buyingpower']),
                                  color: (AcctnoInfo.first['buyingpower'] > 0)
                                      ? const Color(0xff4fd08a)
                                      : const Color(0xfff04a47),
                                  fontWeight: FontWeight.w500,
                                  txalign: TextAlign.start,
                                ),
                              ),
                              customTextStyleBody(
                                text: "Sức mua dự kiến",
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .color!,
                                size: 12,
                              ),
                              SizedBox(
                                width: 90,
                                child: customTextStyleBody(
                                  text: (acctnoReceive == null)
                                      ? ""
                                      : Utils().formatNumber(AcctnoRecvInfo
                                          .first['recvbuyingpower']),
                                  color: (acctnoReceive == null)
                                      ? Colors.transparent
                                      : (AcctnoRecvInfo
                                                  .first['recvbuyingpower'] >
                                              0)
                                          ? const Color(0xff4fd08a)
                                          : const Color(0xfff04a47),
                                  fontWeight: FontWeight.w500,
                                  txalign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          margin: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 90,
                                child: customTextStyleBody(
                                  text: Utils()
                                      .formatNumber(AcctnoInfo.first['rtt']),
                                  color: const Color(0xff4fd08a),
                                  fontWeight: FontWeight.w500,
                                  txalign: TextAlign.start,
                                ),
                              ),
                              customTextStyleBody(
                                text: "Tỉ lệ TS dự kiến",
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .color!,
                                size: 12,
                              ),
                              SizedBox(
                                width: 90,
                                child: customTextStyleBody(
                                  text: (acctnoReceive == null)
                                      ? ""
                                      : Utils().formatNumber(
                                          AcctnoRecvInfo.first['recvrtt']),
                                  color: const Color(0xff4fd08a),
                                  fontWeight: FontWeight.w500,
                                  txalign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          padding: const EdgeInsets.only(right: 8),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              value: _maCK,
                              onChanged: (value) {
                                setState(() {
                                  _maCK = value;
                                  for (var i in responseSendInfo) {
                                    for (var j in i['data']) {
                                      if (j['symbol'] == _maCK) {
                                        tradeqtty_max = j['tradeqtty'];
                                      }
                                    }
                                  }
                                });
                              },
                              hint: customTextStyleBody(
                                text: "Mã chứng khoán",
                                color: Theme.of(context).hintColor,
                                size: 12,
                              ),
                              items: [
                                for (var i in listCK)
                                  DropdownMenuItem(
                                    value: i,
                                    child: Text(i),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 165.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 18,
                                      child: customTextStyleBody(
                                        text: "KL chuyển tối đa",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        size: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      child: TextField(
                                        readOnly: true,
                                        onTap: null,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: (tradeqtty_max == 0)
                                              ? ""
                                              : Utils()
                                                  .formatNumber(tradeqtty_max),
                                          hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          contentPadding: const EdgeInsets.only(
                                              left: 8, bottom: 8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 165.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 18,
                                      child: customTextStyleBody(
                                        text: "KL chuyển",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        size: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: _errorTQ == "" ? 36 : 56,
                                      child: TextField(
                                        controller: tradeQtty,
                                        cursorColor:
                                            Theme.of(context).primaryColor,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide(
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                          errorText:
                                              _errorTQ == "" ? null : _errorTQ,
                                          errorStyle:
                                              const TextStyle(fontSize: 10),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.only(left: 8),
                                          suffix: Container(
                                            width: 40,
                                            height: 20,
                                            margin: const EdgeInsets.only(
                                                right: 4, top: 4),
                                            child: TextButton(
                                              onPressed: () {
                                                if (tradeqtty_max != 0) {
                                                  setState(() {
                                                    tradeQtty.text =
                                                        tradeqtty_max
                                                            .toString();
                                                  });
                                                }
                                              },
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Theme.of(context)
                                                        .buttonTheme
                                                        .colorScheme!
                                                        .background,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.none,
                                                child: customTextStyleBody(
                                                  text: "Tối đa",
                                                  color: Theme.of(context)
                                                      .secondaryHeaderColor,
                                                  size: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size.fromWidth(166),
                            backgroundColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            if (acctnoReceive == null ||
                                _maCK == null ||
                                tradeQtty.text.isEmpty) {
                              fToast.showToast(
                                gravity: ToastGravity.TOP,
                                toastDuration: const Duration(seconds: 2),
                                child: msgNotification(
                                  color: Colors.red,
                                  icon: Icons.error,
                                  text: "Chưa nhập đủ các trường",
                                ),
                              );
                            } else {
                              setState(() {
                                listTransferStock.add(
                                  "$acctno,$acctnoReceive,$_maCK,${tradeQtty.text.replaceAll(RegExp(r','), '')}",
                                );
                                _maCK = null;
                                tradeQtty.clear();
                                tradeqtty_max = 0;
                                checkIsEditTQ = false;
                                _errorTQ = "";
                              });
                            }
                          },
                          child: customTextStyleBody(
                            text: "Thêm",
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary,
                            size: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: customTextStyleBody(
                      text: "Danh sách chuyển chứng khoán",
                      size: 16,
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < listTransferStock.length; i++)
                            Dismissible(
                              key: ValueKey<int>(i),
                              movementDuration:
                                  const Duration(milliseconds: 500),
                              onDismissed: (direction) {},
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: customTextStyleBody(
                                          text: "Xác nhận chuyển",
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          size: 16,
                                        ),
                                        content: customTextStyleBody(
                                          text:
                                              "Bạn có muốn chuyển chứng khoán này?",
                                          color: Theme.of(context).primaryColor,
                                          size: 12,
                                        ),
                                        actions: [
                                          CupertinoActionSheetAction(
                                            onPressed: () async {
                                              final res =
                                                  await setLocalTransfer(
                                                acctno,
                                                "",
                                                listTransferStock[i]
                                                    .split(',')[3],
                                                listTransferStock[i]
                                                    .split(',')[1],
                                                listTransferStock[i]
                                                    .split(',')[2],
                                              );
                                              if (res.isNotEmpty) {
                                                if (res.first['code'] == 200) {
                                                  fToast.showToast(
                                                    gravity: ToastGravity.TOP,
                                                    toastDuration:
                                                        const Duration(
                                                            seconds: 2),
                                                    child: msgNotification(
                                                      color: Colors.green,
                                                      icon: Icons.check_circle,
                                                      text:
                                                          res.first['message'],
                                                    ),
                                                  );
                                                  setState(() {
                                                    listTransferStock
                                                        .removeAt(i);
                                                  });
                                                } else {
                                                  fToast.showToast(
                                                    gravity: ToastGravity.TOP,
                                                    toastDuration:
                                                        const Duration(
                                                            seconds: 2),
                                                    child: msgNotification(
                                                      color: Colors.red,
                                                      icon: Icons.error,
                                                      text:
                                                          res.first['message'],
                                                    ),
                                                  );
                                                }
                                              } else {
                                                fToast.showToast(
                                                  gravity: ToastGravity.TOP,
                                                  toastDuration: const Duration(
                                                      seconds: 2),
                                                  child: msgNotification(
                                                    color: Colors.red,
                                                    icon: Icons.error,
                                                    text: "Thất bại",
                                                  ),
                                                );
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: customTextStyleBody(
                                              text: "Xác nhận",
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          CupertinoActionSheetAction(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: customTextStyleBody(
                                              text: "Đóng",
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: customTextStyleBody(
                                          text: "Xác nhận xóa",
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        content: customTextStyleBody(
                                            text:
                                                "Bạn có muốn xóa khỏi danh sách?"),
                                        actions: [
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              setState(() {
                                                listTransferStock.removeAt(i);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: customTextStyleBody(
                                              text: "Xác nhận",
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          CupertinoActionSheetAction(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: customTextStyleBody(
                                              text: "Đóng",
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                return null;
                              },
                              secondaryBackground: Container(
                                padding: const EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.red,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: customTextStyleBody(
                                    text: 'Xóa',
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                    txalign: TextAlign.right,
                                  ),
                                ),
                              ),
                              background: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.green,
                                ),
                                padding: const EdgeInsets.only(left: 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: customTextStyleBody(
                                    text: 'Chuyển',
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                    txalign: TextAlign.left,
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    textListShare(
                                      context,
                                      "TK chuyển",
                                      listTransferStock[i].split(',')[0],
                                      4.0,
                                    ),
                                    textListShare(
                                      context,
                                      "TK nhận",
                                      listTransferStock[i].split(',')[1],
                                      4.0,
                                    ),
                                    textListShare(
                                      context,
                                      "Mã CK",
                                      listTransferStock[i].split(',')[2],
                                      4.0,
                                    ),
                                    textListShare(
                                      context,
                                      "KL yêu cầu",
                                      Utils().formatNumber(int.parse(
                                          listTransferStock[i].split(',')[3])),
                                      0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      // FittedBox(
                      //   child: DataTable(
                      //     columns: [
                      //       DataColumn(
                      //         label: customTextStyleBody(
                      //           text: "TK chuyển",
                      //           color: Theme.of(context)
                      //               .textTheme
                      //               .titleSmall!
                      //               .color!,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       ),
                      //       DataColumn(
                      //         label: customTextStyleBody(
                      //           text: "TK nhận",
                      //           color: Theme.of(context)
                      //               .textTheme
                      //               .titleSmall!
                      //               .color!,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       ),
                      //       DataColumn(
                      //         label: customTextStyleBody(
                      //           text: "Mã CK",
                      //           color: Theme.of(context)
                      //               .textTheme
                      //               .titleSmall!
                      //               .color!,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       ),
                      //       DataColumn(
                      //         label: customTextStyleBody(
                      //           text: "KL yêu cầu",
                      //           color: Theme.of(context)
                      //               .textTheme
                      //               .titleSmall!
                      //               .color!,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       ),
                      //       DataColumn(label: customTextStyleBody(text: "")),
                      //     ],
                      //     rows: listTransferStock.map((item) {
                      //       List<String> values = item.split(',');

                      //       return DataRow(
                      //         cells: [
                      //           for (int j = 0; j < 4; j++)
                      //             DataCell(
                      //               customTextStyleBody(
                      //                 text: values.length > j &&
                      //                         values[j].isNotEmpty
                      //                     ? values[j]
                      //                     : '',
                      //                 color: Theme.of(context).primaryColor,
                      //                 fontWeight: FontWeight.w400,
                      //                 size: 14,
                      //               ),
                      //             ),
                      //           DataCell(
                      //             Row(
                      //               children: [
                      //                 IconButton(
                      //                   onPressed: () async {
                      //                     final res = await setLocalTransfer(
                      //                       acctno,
                      //                       "",
                      //                       values[3],
                      //                       values[1],
                      //                       values[2],
                      //                     );
                      //                     if (res.isNotEmpty) {
                      //                       if (res.first['code'] == 200) {
                      //                         fToast.showToast(
                      //                           gravity: ToastGravity.TOP,
                      //                           toastDuration:
                      //                               const Duration(seconds: 2),
                      //                           child: msgNotification(
                      //                             color: Colors.green,
                      //                             icon: Icons.check_circle,
                      //                             text: res.first['message'],
                      //                           ),
                      //                         );
                      //                         setState(() {
                      //                           int index = listTransferStock
                      //                               .indexOf(item);
                      //                           if (index != -1) {
                      //                             listTransferStock
                      //                                 .removeAt(index);
                      //                           }
                      //                         });
                      //                       } else {
                      //                         fToast.showToast(
                      //                           gravity: ToastGravity.TOP,
                      //                           toastDuration:
                      //                               const Duration(seconds: 2),
                      //                           child: msgNotification(
                      //                             color: Colors.red,
                      //                             icon: Icons.error,
                      //                             text: res.first['message'],
                      //                           ),
                      //                         );
                      //                       }
                      //                     } else {
                      //                       fToast.showToast(
                      //                         gravity: ToastGravity.TOP,
                      //                         toastDuration:
                      //                             const Duration(seconds: 2),
                      //                         child: msgNotification(
                      //                           color: Colors.red,
                      //                           icon: Icons.error,
                      //                           text: "Thất bại",
                      //                         ),
                      //                       );
                      //                     }
                      //                   },
                      //                   icon: const Icon(Icons.money),
                      //                   color: const Color(0xff4FD08A),
                      //                 ),
                      //                 const SizedBox(width: 4),
                      //                 IconButton(
                      //                   onPressed: () {
                      //                     setState(() {
                      //                       int index =
                      //                           listTransferStock.indexOf(item);
                      //                       if (index != -1) {
                      //                         listTransferStock.removeAt(index);
                      //                       }
                      //                     });
                      //                   },
                      //                   icon: const Icon(Icons.delete),
                      //                   color: const Color(0xffF04A47),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Padding textListShare(
      BuildContext context, String text1, String text2, double Pbottom) {
    return Padding(
      padding: EdgeInsets.only(bottom: Pbottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: text1,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
          ),
          customTextStyleBody(
            text: text2,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w400,
            size: 14,
          ),
        ],
      ),
    );
  }
}
