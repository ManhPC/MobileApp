import 'package:flutter/material.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/tra_no/getDebts.dart';

import 'package:nvs_trading/data/services/tra_no/getLoanContract.dart';
import 'package:nvs_trading/presentation/view/expand/QuanLyDuNo/no_detail.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class TraNo extends StatefulWidget {
  const TraNo({super.key});

  @override
  State<TraNo> createState() => _TraNoState();
}

class _TraNoState extends State<TraNo> {
  String custodycd = HydratedBloc.storage.read('custodycd');
  String Acctno = HydratedBloc.storage.read('acctno');

  List<dynamic> responseConFirst = [];
  List<dynamic> responseContract = [];
  List<dynamic> responseData = [];
  @override
  void initState() {
    super.initState();
    fetchContract();
    fetchData();
  }

  void fetchData() async {
    try {
      final res = await getDebts(custodycd, Acctno);
      if (res.isNotEmpty) {
        setState(() {
          responseData = res;
        });
      }
    } catch (e) {
      Future.error(e);
    }
  }

  Future<void> fetchContract() async {
    try {
      final res = await getLoanContract(custodycd, 'ALL', "", "", "", 1, 50);
      if (res.isNotEmpty) {
        setState(() {
          responseConFirst = res;
        });
        responseContract.clear();
        if (chooseType == 0) {
          responseContract = responseConFirst;
        } else if (chooseType == 1) {
          for (var i in responseConFirst) {
            if (i['status'] == 'N' && int.parse(i['daynumber']) > 0) {
              responseContract.add(i);
            }
          }
        } else if (chooseType == 2) {
          for (var i in responseConFirst) {
            if (i['status'] == 'N' && int.parse(i['daynumber']) == 0) {
              responseContract.add(i);
            }
          }
        } else if (chooseType == 3) {
          for (var i in responseConFirst) {
            if (i['status'] == 'A') {
              responseContract.add(i);
            }
          }
        }
      }
    } catch (e) {
      Future.error(e);
    }
  }

  int chooseType = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Nợ"),
      body: (responseData.isEmpty)
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 32) / 2,
                          child: customTextStyleBody(
                            text: "Số tiền cần nộp để đảm bảo tỷ lệ Rtt",
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            size: 14,
                            fontWeight: FontWeight.w400,
                            txalign: TextAlign.start,
                          ),
                        ),
                        customTextStyleBody(
                          text: Utils()
                              .formatNumber(responseData.first['needpay']),
                          color: Theme.of(context).primaryColor,
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width - 32) / 3,
                              child: customTextStyleBody(
                                text: "Hạn mức đã dùng",
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .color!,
                                size: 14,
                                fontWeight: FontWeight.w400,
                                txalign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 32,
                              //width: (MediaQuery.of(context).size.width - 32) / 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.only(),
                                ),
                                onPressed: () {},
                                child: customTextStyleBody(
                                  text: "Thay đổi",
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 32) / 3,
                          child: customTextStyleBody(
                            text: Utils().formatNumber(
                                responseData.first['margiN_USED']),
                            color: Theme.of(context).primaryColor,
                            size: 14,
                            fontWeight: FontWeight.w500,
                            txalign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              fetchContract();
                              setState(() {
                                chooseType = 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                color: chooseType == 0
                                    ? Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .background
                                    : Colors.transparent,
                              ),
                              height: 20,
                              alignment: Alignment.center,
                              width:
                                  (MediaQuery.of(context).size.width - 32) / 4,
                              child: customTextStyleBody(
                                text: "Tất cả",
                                color: chooseType == 0
                                    ? Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .primary
                                    : Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              fetchContract();
                              setState(() {
                                chooseType = 1;
                              });
                            },
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width - 32) / 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                color: chooseType == 1
                                    ? Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .background
                                    : Colors.transparent,
                              ),
                              height: 20,
                              alignment: Alignment.center,
                              child: customTextStyleBody(
                                text: "Trong hạn",
                                color: chooseType == 1
                                    ? Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .primary
                                    : Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                fetchContract();
                                chooseType = 2;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                color: chooseType == 2
                                    ? Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .background
                                    : Colors.transparent,
                              ),
                              height: 20,
                              alignment: Alignment.center,
                              width:
                                  (MediaQuery.of(context).size.width - 32) / 4,
                              child: customTextStyleBody(
                                text: "Quá hạn",
                                color: chooseType == 2
                                    ? Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .primary
                                    : Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              fetchContract();
                              setState(() {
                                chooseType = 3;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                color: chooseType == 3
                                    ? Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .background
                                    : Colors.transparent,
                              ),
                              height: 20,
                              alignment: Alignment.center,
                              width:
                                  (MediaQuery.of(context).size.width - 32) / 4,
                              child: customTextStyleBody(
                                text: "Đã trả",
                                color: chooseType == 3
                                    ? Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .primary
                                    : Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    for (var i = 0; i < responseContract.length; i++)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: responseContract[i]['loanid'],
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      customTextStyleBody(
                                        text: responseContract[i]['afacctno'],
                                        size: 14,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            64) /
                                        4,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .buttonTheme
                                            .colorScheme!
                                            .background,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: responseContract[i]
                                                  ['status'] ==
                                              "A"
                                          ? null
                                          : () async {
                                              final ressult =
                                                  await Navigator.of(context)
                                                      .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoDetail(
                                                    acctno: responseContract[i]
                                                        ['afacctno'],
                                                    loanid: responseContract[i]
                                                        ['loanid'],
                                                    txdate: responseContract[i]
                                                        ['txdate'],
                                                    duedate: responseContract[i]
                                                        ['duedate'],
                                                    rate: responseContract[i]
                                                        ['intrate'],
                                                    daynumber:
                                                        responseContract[i]
                                                            ['daynumber'],
                                                    noGoc: responseContract[i]
                                                        ['remain_loanamt'],
                                                    noLai: responseContract[i]
                                                        ['remain_acrintamt'],
                                                    sodutien:
                                                        responseContract[i]
                                                            ['cash_balance'],
                                                    tiencotheTT:
                                                        responseContract[i]
                                                            ['payamount'],
                                                    phiUngTienTamTinh:
                                                        responseContract[i]
                                                            ['feeadv'],
                                                  ),
                                                ),
                                              );
                                              if (ressult == true) {
                                                await fetchContract();
                                                setState(() {});
                                              }
                                            },
                                      child: FittedBox(
                                        fit: BoxFit.none,
                                        child: customTextStyleBody(
                                          text: "Thanh toán",
                                          size: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .buttonTheme
                                              .colorScheme!
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: "Ngày vay",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      customTextStyleBody(
                                        text: responseContract[i]['txdate'],
                                        color: Theme.of(context).primaryColor,
                                        size: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      customTextStyleBody(
                                        text: "Ngày đáo hạn",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      customTextStyleBody(
                                        text: responseContract[i]['duedate'],
                                        color: Theme.of(context).primaryColor,
                                        size: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: "Số ngày vay còn lại",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      customTextStyleBody(
                                        text: responseContract[i]['daynumber'],
                                        color: Theme.of(context).primaryColor,
                                        size: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      customTextStyleBody(
                                        text: "Dư nợ đã TT",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      customTextStyleBody(
                                        text: Utils().formatNumber(int.parse(
                                                responseContract[i]
                                                    ['orgpaidamt']) +
                                            int.parse(responseContract[i]
                                                ['acrintamt'])),
                                        color: Theme.of(context).primaryColor,
                                        size: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: "Nợ gốc còn lại",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      customTextStyleBody(
                                        text: responseContract[i]
                                                    ['remain_loanamt'] !=
                                                "0"
                                            ? Utils().formatNumber(int.parse(
                                                responseContract[i]
                                                    ['remain_loanamt']))
                                            : responseContract[i]
                                                ['remain_loanamt'],
                                        color: Theme.of(context).primaryColor,
                                        size: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      customTextStyleBody(
                                        text: "Nợ lãi còn lại",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      customTextStyleBody(
                                        text: responseContract[i]
                                                    ['acrintamt'] !=
                                                "0"
                                            ? Utils().formatNumber(int.parse(
                                                responseContract[i]
                                                    ['remain_acrintamt']))
                                            : responseContract[i]
                                                ['remain_loanamt'],
                                        color: Theme.of(context).primaryColor,
                                        size: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTextStyleBody(
                                      text: "Tổng dư nợ còn lại",
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    customTextStyleBody(
                                      text: (responseContract[i]
                                                      ['remain_loanamt'] ==
                                                  "0" &&
                                              responseContract[i]
                                                      ['acrintamt'] ==
                                                  "0")
                                          ? "0"
                                          : Utils().formatNumber(int.parse(
                                                  responseContract[i]
                                                      ['remain_loanamt']) +
                                              int.parse(responseContract[i]
                                                  ['remain_acrintamt'])),
                                      color: Theme.of(context).primaryColor,
                                      size: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    customTextStyleBody(
                                      text: "Trạng thái",
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    customTextStyleBody(
                                      text: responseContract[i]['status'],
                                      color: Theme.of(context).primaryColor,
                                      size: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
