import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:nvs_trading/data/services/stock_detail/getEventChart.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class VVCT extends StatefulWidget {
  VVCT({
    super.key,
    required this.symbol,
  });

  String symbol;

  @override
  State<VVCT> createState() => _VVCTState();
}

class _VVCTState extends State<VVCT> {
  dynamic data;
  List<OrdinalData> cashDividendInfo = [];
  List<OrdinalData> stockDividendInfo = [];
  @override
  void initState() {
    super.initState();
    fetchEventChart();
  }

  void fetchEventChart() async {
    try {
      final res = await getEventChart(widget.symbol);
      if (res.statusCode == 200) {
        setState(() {
          data = res.data;
        });
      }
      dynamic rawData = data['lstCorporateActionChart'];

      for (var i in rawData) {
        if (i['eventlistcode'] == "DIV") {
          cashDividendInfo.add(
            OrdinalData(
              domain: i['issueyear'].toStringAsFixed(0),
              measure: i['value'],
            ),
          );
        } else {
          stockDividendInfo.add(
            OrdinalData(
              domain: i['issueyear'].toStringAsFixed(0),
              measure: i['ratio'],
            ),
          );
        }
      }
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cashDividendChart = [
      OrdinalGroup(
        id: '1',
        chartType: ChartType.bar,
        data: cashDividendInfo,
        color: Colors.blue,
      ),
      OrdinalGroup(
        id: '2',
        chartType: ChartType.line,
        data: cashDividendInfo,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      OrdinalGroup(
        id: '3',
        chartType: ChartType.scatterPlot,
        data: cashDividendInfo,
        color: Theme.of(context).secondaryHeaderColor,
      ),
    ];
    final stockDividendChart = [
      OrdinalGroup(
        id: '1',
        chartType: ChartType.bar,
        data: stockDividendInfo,
        color: Colors.blue,
      ),
      OrdinalGroup(
        id: '2',
        chartType: ChartType.line,
        data: stockDividendInfo,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      OrdinalGroup(
        id: '3',
        chartType: ChartType.scatterPlot,
        data: stockDividendInfo,
        color: Theme.of(context).secondaryHeaderColor,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: customTextStyleBody(
              text: "Cổ tức bằng tiền (đ)",
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              txalign: TextAlign.start,
            ),
          ),
          (cashDividendInfo.isEmpty)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AspectRatio(
                    aspectRatio: 8 / 9,
                    child: DChartComboO(
                      measureAxis: MeasureAxis(
                        showLine: true,
                        lineStyle: LineStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelStyle: LabelStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      domainAxis: DomainAxis(
                        lineStyle: LineStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelStyle: LabelStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      groupList: cashDividendChart,
                    ),
                  ),
                ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: customTextStyleBody(
              text: "Cổ tức bằng CP (%)",
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              txalign: TextAlign.start,
            ),
          ),
          (stockDividendInfo.isEmpty)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AspectRatio(
                    aspectRatio: 8 / 9,
                    child: DChartComboO(
                      measureAxis: MeasureAxis(
                        showLine: true,
                        lineStyle: LineStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelStyle: LabelStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      domainAxis: DomainAxis(
                        lineStyle: LineStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelStyle: LabelStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),

                      groupList: stockDividendChart,
                      // barLabelValue: (group, ordinalData, index) {
                      //   return ordinalData.measure.toStringAsFixed(2);
                      // },
                      // barLabelDecorator: BarLabelDecorator(
                      //   barLabelPosition: BarLabelPosition.inside,
                      // ),
                    ),
                  ),
                ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: customTextStyleBody(
              text: "Tài sản (Tỷ đồng)",
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
