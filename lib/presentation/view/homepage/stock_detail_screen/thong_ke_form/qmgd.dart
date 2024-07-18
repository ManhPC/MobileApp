import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class QMGD extends StatefulWidget {
  QMGD({
    super.key,
    required this.data,
  });

  List<dynamic> data;

  @override
  State<QMGD> createState() => _QMGDState();
}

class _QMGDState extends State<QMGD> {
  List<String> label = [
    'Ngày',
    'KL đặt mua',
    'KL đặt bán',
    'KLGD khớp lệnh',
    'GTGD khớp lệnh',
    'KLGD thỏa thuận',
    'GTGD thỏa thuận',
    'Tổng KL',
    'Tổng GT'
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 28,
          dataRowHeight: 28,
          border: TableBorder.all(
            color: Theme.of(context).hintColor,
          ),
          columns: label
              .map(
                (e) => DataColumn(
                  label: customTextStyleBody(
                    text: e,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
              .toList(),
          rows: [
            for (var i = 0; i < widget.data.length; i++)
              DataRow(
                cells: [
                  DataCell(
                    customTextStyleBody(
                      text: widget.data[i]['tradingDate'],
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  DataCell(
                    customTextStyleBody(
                      text:
                          Utils().formatNumber(widget.data[i]['totalBidQtty']),
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  DataCell(
                    customTextStyleBody(
                      text: Utils()
                          .formatNumber(widget.data[i]['totalOfferQtty']),
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: double.infinity,
                      child: customTextStyleBody(
                        text: Utils()
                            .formatNumber(widget.data[i]['totalTradedQttyNM']),
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.end,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: double.infinity,
                      child: customTextStyleBody(
                        text: Utils()
                            .formatNumber(widget.data[i]['totalTradedValueNM']),
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.end,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: double.infinity,
                      child: customTextStyleBody(
                        text: Utils()
                            .formatNumber(widget.data[i]['totalTradedQttyPT']),
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.end,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: double.infinity,
                      child: customTextStyleBody(
                        text: Utils()
                            .formatNumber(widget.data[i]['totalTradedValuePT']),
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.end,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: double.infinity,
                      child: customTextStyleBody(
                        text: Utils()
                            .formatNumber(widget.data[i]['totalTradedQtty']),
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.end,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: double.infinity,
                      child: customTextStyleBody(
                        text: Utils()
                            .formatNumber(widget.data[i]['totalTradedValue']),
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
