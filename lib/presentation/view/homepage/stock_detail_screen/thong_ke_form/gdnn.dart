import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class GDNN extends StatefulWidget {
  GDNN({
    super.key,
    required this.data,
  });
  List<dynamic> data = [];

  @override
  State<GDNN> createState() => _GDNNState();
}

class _GDNNState extends State<GDNN> {
  List<String> label = [
    'Ngày',
    'Room còn lại',
    '+/-',
    '%',
    'KL Ròng',
    'GT Ròng',
    'KL mua',
    'GT mua',
    'KL bán',
    'GT bán',
    'Giá đóng cửa',
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
              DataRow(cells: [
                DataCell(
                  customTextStyleBody(
                    text: widget.data[i]['tradingDate'],
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  customTextStyleBody(
                    text: Utils()
                        .formatNumber(widget.data[i]['remainForeignQtty']),
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  customTextStyleBody(
                    text:
                        "${(widget.data[i]['changePrice'] / 1000).toStringAsFixed(2)}",
                    color: (widget.data[i]['changePrice'] > 0)
                        ? Colors.green
                        : (widget.data[i]['changePrice'] == 0)
                            ? Colors.yellow
                            : Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  customTextStyleBody(
                    text:
                        "${(widget.data[i]['pctChangePrice']).toStringAsFixed(2)}",
                    color: (widget.data[i]['pctChangePrice'] > 0)
                        ? Colors.green
                        : (widget.data[i]['pctChangePrice'] == 0)
                            ? Colors.yellow
                            : Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: double.infinity,
                    child: customTextStyleBody(
                      text: Utils()
                          .formatNumber(widget.data[i]['subForeignQtty']),
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
                          .formatNumber(widget.data[i]['subForeignValue']),
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
                          .formatNumber(widget.data[i]['buyForeignQtty']),
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
                          .formatNumber(widget.data[i]['buyForeignValue']),
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
                          .formatNumber(widget.data[i]['sellForeignQtty']),
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
                          .formatNumber(widget.data[i]['sellForeignValue']),
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                      txalign: TextAlign.end,
                    ),
                  ),
                ),
                const DataCell(Text('')),
              ])
          ],
        ),
      ),
    );
  }
}
