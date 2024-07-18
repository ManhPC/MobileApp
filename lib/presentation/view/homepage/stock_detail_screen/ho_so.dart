// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/stock_detail/getProfile.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:html/parser.dart';
import 'package:d_chart/d_chart.dart';

class HoSo extends StatefulWidget {
  HoSo({
    super.key,
    required this.symbol,
  });
  String symbol;

  @override
  State<HoSo> createState() => _HoSoState();
}

class _HoSoState extends State<HoSo> {
  int chooseType = 0;
  dynamic data;
  @override
  void initState() {
    super.initState();
    getDataSymbol();
  }

  var document;
  void getDataSymbol() async {
    try {
      final res = await getProfile(widget.symbol);
      if (res.statusCode == 200) {
        setState(() {
          data = res.data;
        });
        document = parse(data['objOrganization']['companyprofile']);
      }
    } catch (e) {
      Future.error(e);
    }
  }

  List<OrdinalData> ordinalDataList = [
    OrdinalData(domain: 'Nước ngoài', measure: 1, color: Colors.amber[300]),
    OrdinalData(domain: 'Trong nước', measure: 0.5, color: Colors.blue[300]),
    OrdinalData(domain: 'Khác', measure: 9, color: Colors.grey),
  ];
  @override
  Widget build(BuildContext context) {
    return (data == null)
        ? Container()
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chooseType = 0;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: (chooseType == 0)
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            child: customTextStyleBody(
                              text: "Giới thiệu",
                              color: (chooseType == 0)
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chooseType = 1;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: (chooseType == 1)
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            child: customTextStyleBody(
                              text: "Công ty cùng ngành",
                              color: (chooseType == 1)
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chooseType = 2;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: (chooseType == 2)
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            child: customTextStyleBody(
                              text: "Lãnh đạo",
                              color: (chooseType == 2)
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chooseType = 3;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: (chooseType == 3)
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            child: customTextStyleBody(
                              text: "Cổ đông",
                              color: (chooseType == 3)
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                (chooseType == 0)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: customTextStyleBody(
                              text: document.body!.text.toString().trim(),
                              color: Theme.of(context).primaryColor,
                              txalign: TextAlign.start,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  color: Theme.of(context).colorScheme.tertiary,
                                  child: customTextStyleBody(
                                    text: "TT cơ bản",
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                    txalign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Column(
                                    children: [
                                      WidgetThongTin(
                                        title: "Mã",
                                        content: widget.symbol,
                                      ),
                                      WidgetThongTin(
                                        title: "Tên ngành ICB",
                                        content: data['objOrganization']
                                            ['descript'],
                                      ),
                                      WidgetThongTin(
                                        title: "Mã ngành ICB",
                                        content: data['objOrganization']
                                            ['icbcode'],
                                      ),
                                      WidgetThongTin(
                                        title: "Năm thành lập",
                                        content: DateFormat('dd/MM/yyyy')
                                            .format(DateTime.parse(
                                                data['objOrganization']
                                                    ['foundingdate'])),
                                      ),
                                      WidgetThongTin(
                                        title: "Vốn điều lệ",
                                        content:
                                            "${Utils().formatBillion(data['objOrganization']['chartercapital'].toString())} tỷ",
                                      ),
                                      WidgetThongTin(
                                        title: "Số lượng nhân viên",
                                        content:
                                            "${data['objOrganization']['numberofemployee'].toStringAsFixed(0)}",
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customTextStyleBody(
                                            text: "Số lượng chi nhánh",
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          customTextStyleBody(
                                            text: data['objOrganization']
                                                    ['numberofshareholder']
                                                .toStringAsFixed(0),
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  color: Theme.of(context).colorScheme.tertiary,
                                  child: customTextStyleBody(
                                    text: "TT niêm yết",
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                    txalign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Column(
                                    children: [
                                      WidgetThongTin(
                                        title: "Ngày niêm yết",
                                        content: DateFormat('dd/MM/yyyy')
                                            .format(DateTime.parse(
                                                data['objOrganization']
                                                    ['listingdate'])),
                                      ),
                                      WidgetThongTin(
                                        title: "Nơi niêm yết",
                                        content: data['objOrganization']
                                            ['comgroupcode'],
                                      ),
                                      WidgetThongTin(
                                        title: "Giá chào sàn (x1000 VNĐ)",
                                        content:
                                            "${data['objOrganization']['firstprice'] / 1000}",
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customTextStyleBody(
                                            text: "KL đang niêm yết",
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          customTextStyleBody(
                                            text: Utils().formatNumber(
                                              data['objOrganization']
                                                      ['issueshare']
                                                  .toInt(),
                                            ),
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                      // WidgetThongTin(
                                      //   title: "KL đang niêm yết",
                                      //   content: Utils().formatNumber(
                                      //     data['objOrganization']['issueshare']
                                      //         .toInt(),
                                      //   ),
                                      // ),
                                      // WidgetThongTin(
                                      //   title: "Thị giá vốn",
                                      //   content: "",
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Column(
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      //         customTextStyleBody(
                                      //           text: "SLCP lưu hành",
                                      //           color: Theme.of(context)
                                      //               .textTheme
                                      //               .titleSmall!
                                      //               .color!,
                                      //           fontWeight: FontWeight.w400,
                                      //         ),
                                      //         customTextStyleBody(
                                      //           text:
                                      //               "Đã bao gồm KL dự kiến phát\nhành tối đa từ sự kiện quyền",
                                      //           size: 10,
                                      //           color: Theme.of(context)
                                      //               .textTheme
                                      //               .titleSmall!
                                      //               .color!,
                                      //           fontWeight: FontWeight.w400,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     customTextStyleBody(
                                      //       text: "",
                                      //       color:
                                      //           Theme.of(context).primaryColor,
                                      //       fontWeight: FontWeight.w500,
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  color: Theme.of(context).colorScheme.tertiary,
                                  child: customTextStyleBody(
                                    text: "Công ty con",
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                    txalign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : (chooseType == 1)
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    customTextStyleBody(
                                      text: "Mã công ty",
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    customTextStyleBody(
                                      text: "Giá",
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    customTextStyleBody(
                                      text: "KLGD",
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : (chooseType == 2)
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var i in data['lstBoardOfDirector'])
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customTextStyleBody(
                                            text: i['fullname'],
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          customTextStyleBody(
                                            text: i['positionname'],
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Divider(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              height: 1,
                                            ),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(top: 32),
                                child: AspectRatio(
                                  aspectRatio: 16 / 8,
                                  child: DChartPieO(
                                    data: ordinalDataList,
                                    configRenderPie: ConfigRenderPie(
                                      arcLabelDecorator: ArcLabelDecorator(
                                        labelPosition: ArcLabelPosition.outside,
                                        leaderLineStyle:
                                            ArcLabelLeaderLineStyle(
                                          color: Theme.of(context).primaryColor,
                                          length: 20,
                                          thickness: 1,
                                        ),
                                        outsideLabelStyle: LabelStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      arcWidth: 30,
                                    ),
                                  ),
                                ),
                              ),
              ],
            ),
          );
  }
}

class WidgetThongTin extends StatelessWidget {
  WidgetThongTin({
    super.key,
    required this.title,
    required this.content,
  });

  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customTextStyleBody(
              text: title,
              color: Theme.of(context).textTheme.titleSmall!.color!,
              fontWeight: FontWeight.w400,
            ),
            customTextStyleBody(
              text: content,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            height: 1,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        )
      ],
    );
  }
}
