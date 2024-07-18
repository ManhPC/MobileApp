import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nvs_trading/data/services/stock_detail/getStockList.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/thong_ke_form/bangLSG.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/thong_ke_form/gdnn.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/thong_ke_form/qmgd.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class ThongKe extends StatefulWidget {
  ThongKe({super.key, required this.symbol});

  String symbol;
  @override
  State<ThongKe> createState() => _ThongKeState();
}

class _ThongKeState extends State<ThongKe> {
  List<String> chooseTypeLabel = ['Lịch sử giá', 'Giao dịch NN', 'Quy mô GD'];
  int chooseType = 0;
  List<dynamic> dataStockList = [];
  @override
  void initState() {
    super.initState();
    fetchStockList();
  }

  void fetchStockList() async {
    try {
      final res = await getStockList(widget.symbol);
      if (res.statusCode == 200) {
        setState(() {
          dataStockList = res.data;
        });
      }
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                barrierColor: Colors.transparent,
                backgroundColor: Theme.of(context).colorScheme.primary,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: const BoxDecoration(),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 192,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chooseType = 0;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: customTextStyleBody(
                              text: "Lịch sử giá",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).hintColor,
                          height: 0.5,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chooseType = 1;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: customTextStyleBody(
                              text: "Giao dịch NN",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).hintColor,
                          height: 0.5,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              chooseType = 2;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: customTextStyleBody(
                              text: "Quy mô GD",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).hintColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: customTextStyleBody(
                              text: "Đóng",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              width: 132,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: chooseTypeLabel[chooseType],
                    color: Theme.of(context).primaryColor,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Theme.of(context).hintColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: (chooseType == 0)
              ? BangLSG(
                  data: dataStockList,
                )
              : (chooseType == 1)
                  ? GDNN(
                      data: dataStockList,
                    )
                  : QMGD(
                      data: dataStockList,
                    ),
        ),
      ],
    );
  }
}
