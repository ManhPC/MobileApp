import 'package:flutter/material.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class BangLSG extends StatefulWidget {
  BangLSG({super.key, required this.data});

  List<dynamic> data;
  @override
  State<BangLSG> createState() => _BangLSGState();
}

class _BangLSGState extends State<BangLSG> {
  List<String> label = [
    'Ngày',
    'Thay đổi',
    '%',
    'Mở',
    'Cao',
    'Thấp',
    'Đóng',
    'TB',
    'Tổng KL',
    'Tổng GT',
    'GD khớp lệnh',
    'GD thỏa thuận',
    'Tổng GD',
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder.all(
            color: Theme.of(context).hintColor,
          ),
          headingRowHeight: 28,
          dataRowHeight: 28,
          columns: label
              .map(
                (e) => DataColumn(
                  label: customTextStyleBody(
                    text: e,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
              .toList(),
          rows: [
            for (var i = 0; i < widget.data.length; i++)
              DataRow(cells: [
                DataCell(
                  customTextStyleBody(
                    text: widget.data[i]['tradingDate'],
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: double.infinity,
                    child: customTextStyleBody(
                      text:
                          "${((widget.data[i]['changePrice']) / 1000).toStringAsFixed(2)}",
                      color: (widget.data[i]['changePrice'] > 0)
                          ? Colors.green
                          : (widget.data[i]['changePrice'] == 0)
                              ? Colors.yellow
                              : Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                DataCell(
                  customTextStyleBody(
                    text:
                        "${widget.data[i]['pctChangePrice'].toStringAsFixed(2)}",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  customTextStyleBody(
                    text: "${widget.data[i]['openPrice'] / 1000}",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  customTextStyleBody(
                    text: "${widget.data[i]['highestPrice'] / 1000}",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  customTextStyleBody(
                    text: "${widget.data[i]['lowestPrice'] / 1000}",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  customTextStyleBody(
                    text: "${widget.data[i]['closePrice'] / 1000}",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  customTextStyleBody(
                    text:
                        "${(widget.data[i]['avgPrice'] / 1000).toStringAsFixed(2)}",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
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
                const DataCell(Text('')),
                const DataCell(Text('')),
                const DataCell(Text('')),
              ]),
          ],
        ),
      ),
    );
  }
}
