import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getbusdate.dart';
import 'package:nvs_trading/data/services/transfer_stock/getlisttranfer.dart';
import 'package:nvs_trading/presentation/view/asset_page/form/genaral_Info.dart';
import 'package:nvs_trading/presentation/view/asset_page/form/money_Info.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/chooseAcctno.dart';
import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class TransferStockHis extends StatefulWidget {
  const TransferStockHis({super.key});

  @override
  State<TransferStockHis> createState() => _TransferStockHisState();
}

class _TransferStockHisState extends State<TransferStockHis> {
  final GlobalKey _menuKey = GlobalKey();
  String datetime = '';
  String _startDate = '';
  String _endDate = '';
  List data = [];
  List data1 = [];
  List filterdata = [];
  bool selectAll = false;
  List selectedItems = [];
  dynamic Custodycd = HydratedBloc.storage.read('custodycd');
  dynamic Acctno = HydratedBloc.storage.read('acctno');
  void fetchdata() async {
    try {
      final response = await ListTranfer(Custodycd, Acctno, selectedItems,
          _startDate, _endDate, 1, 50, HydratedBloc.storage.read('token'));
      setState(() {
        filterdata = response;
      });
      data1 = filterdata;
    } catch (e) {
      print('error:$e');
    }
  }

  Future<void> fetchdatetime() async {
    try {
      final response = await GetBusDate(HydratedBloc.storage.read('token'));
      setState(() {
        datetime = response.data['dateserver'];
        DateTime dateTime = DateTime.parse(datetime);
        _endDate = DateFormat('dd/MM/yyyy').format(dateTime);
        DateTime startDate = dateTime.subtract(const Duration(days: 0));
        _startDate = DateFormat("dd/MM/yyyy").format(startDate);
      });
      fetchdata();
    } catch (e) {
      print('error:$e');
    }
  }

  Future<void> fetchdata1() async {
    try {
      final response = await GetAllCode(
          'API', 'STOCKSTATUS', HydratedBloc.storage.read('token'));

      print(data);
      setState(() {
        data = response;
      });
    } catch (e) {
      print('error:$e');
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    fetchdatetime();
    fetchdata1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        text: 'Lịch sử chuyển chứng khoán',
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextStyleBody(
                          text: 'Từ ngày',
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateFormat('dd/MM/yyyy').parse(_startDate),
                              firstDate: DateFormat('dd/MM/yyyy')
                                  .parse(_endDate)
                                  .subtract(const Duration(days: 90)),
                              lastDate:
                                  DateFormat('dd/MM/yyyy').parse(_endDate),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.green, // Màu sắc chính
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              DateTime endDate =
                                  DateFormat('dd/MM/yyyy').parse(_endDate);
                              if (picked.isAfter(endDate)) {
                                // Nếu ngày bắt đầu được chọn lớn hơn ngày kết thúc, cập nhật cả hai
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 60,
                                        ),
                                        content: customTextStyleBody(
                                          text: "Từ ngày phải nhỏ hơn đến ngày",
                                        ),
                                      );
                                    },
                                  );
                                });
                              } else {
                                // Ngày bắt đầu hợp lệ
                                setState(() {
                                  _startDate =
                                      DateFormat('dd/MM/yyyy').format(picked);
                                });
                              }
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customTextStyleBody(
                                  text: _startDate,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Image.asset("assets/icons/Vector.png")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextStyleBody(text: 'Đến ngày'),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateFormat('dd/MM/yyyy').parse(_endDate),
                              firstDate: DateFormat('dd/MM/yyyy')
                                  .parse(_endDate)
                                  .subtract(const Duration(days: 90)),
                              lastDate:
                                  DateFormat('dd/MM/yyyy').parse(_endDate),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.green, // Màu sắc chính
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              DateTime startDate =
                                  DateFormat('dd/MM/yyyy').parse(_startDate);
                              if (picked.isBefore(startDate)) {
                                // Nếu ngày kết thúc được chọn nhỏ hơn ngày bắt đầu, cập nhật cả hai
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 60,
                                        ),
                                        content: customTextStyleBody(
                                          text: "Từ ngày phải nhỏ hơn đến ngày",
                                        ),
                                      );
                                    },
                                  );
                                });
                              } else {
                                // Ngày kết thúc hợp lệ
                                setState(() {
                                  _endDate =
                                      DateFormat('dd/MM/yyyy').format(picked);
                                });
                              }
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customTextStyleBody(
                                  text: _endDate,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Image.asset("assets/icons/Vector.png")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    height: 36,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 12,
                      height: 36,
                      child: PopupMenuButton<int>(
                        color: Theme.of(context).colorScheme.primary,
                        constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width / 2 - 22),
                        // onSelected: (int) {},
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<int>(
                              enabled: false,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: StatefulBuilder(
                                  builder: (context, menuSetState) {
                                    return Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CheckboxListTile(
                                            activeColor: Theme.of(context)
                                                .secondaryHeaderColor,
                                            title: customTextStyleBody(
                                              txalign: TextAlign.start,
                                              text: "Chọn tất cả",
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: selectAll,
                                            onChanged: (bool? value) {
                                              menuSetState(() {
                                                selectAll = value ?? false;
                                                if (selectAll) {
                                                  selectedItems = data
                                                      .map((item) =>
                                                          item['cdval']
                                                              as String)
                                                      .toList();
                                                } else {
                                                  selectedItems.clear();
                                                }
                                              });
                                              setState(() {});
                                            },
                                          ),
                                          ...data.map((item) {
                                            return CheckboxListTile(
                                              activeColor: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              title: customTextStyleBody(
                                                  txalign: TextAlign.start,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  text: item['vN_CDCONTENT']!),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              value: selectedItems
                                                  .contains(item['cdval']),
                                              onChanged: (bool? value) {
                                                menuSetState(() {
                                                  if (value == true) {
                                                    selectedItems
                                                        .add(item['cdval']!);
                                                  } else {
                                                    selectedItems
                                                        .remove(item['cdval']);
                                                  }
                                                  selectAll =
                                                      selectedItems.length ==
                                                          data.length;
                                                });
                                                setState(() {});
                                              },
                                            );
                                          }),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ];
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  selectedItems.isEmpty
                                      ? 'Trạng thái'
                                      : data
                                          .where((item) => selectedItems
                                              .contains(item['cdval']))
                                          .map((item) => item['vN_CDCONTENT'])
                                          .join(', '),
                                  style: TextStyle(
                                    // ignore: unrelated_type_equality_checks
                                    fontSize: (selectedItems == 'Trạng thái')
                                        ? 12
                                        : 14,
                                    color: Theme.of(context).primaryColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).hintColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                            4,
                          )),
                          backgroundColor: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .background,
                        ),
                        onPressed: () {
                          setState(() {
                            fetchdata();
                          });
                        },
                        child: customTextStyleBody(
                          text: 'Tìm kiếm',
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .primary,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            customTextStyleBody(
              txalign: TextAlign.start,
              text: 'Lịch sử chuyển chứng khoán',
              size: 16,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 25,
                    child: customTextStyleBody(
                      text: 'Mã CK',
                      txalign: TextAlign.start,
                      size: 10,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: customTextStyleBody(
                      text: 'Thời gian yêu cầu',
                      txalign: TextAlign.start,
                      size: 10,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    width: 79,
                    child: customTextStyleBody(
                      text: 'TK chuyển',
                      txalign: TextAlign.start,
                      size: 10,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    width: 79,
                    child: customTextStyleBody(
                      text: 'TK nhận',
                      txalign: TextAlign.start,
                      size: 10,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: customTextStyleBody(
                      text: 'Khối lượng',
                      txalign: TextAlign.end,
                      size: 10,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: customTextStyleBody(
                      text: 'Trạng thái',
                      txalign: TextAlign.start,
                      size: 10,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filterdata.length,
                itemBuilder: (contex, index) {
                  final i = filterdata[index] as Map;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              verticalDirection: VerticalDirection.down,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 25,
                                  child: customTextStyleBody(
                                    text: i['symbol'],
                                    txalign: TextAlign.start,
                                    size: 10,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: i['txdate'],
                                        size: 10,
                                        color: Theme.of(context).primaryColor,
                                        txalign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 79,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: i['afacctno'],
                                        size: 10,
                                        color: Theme.of(context).primaryColor,
                                        txalign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 79,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: i['recvafacctno'],
                                        size: 10,
                                        color: Theme.of(context).primaryColor,
                                        txalign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      customTextStyleBody(
                                        text: i['qtty'],
                                        size: 10,
                                        color: Theme.of(context).primaryColor,
                                        txalign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 48,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: i['status_vn'],
                                        size: 10,
                                        color: i['status_vn'] == 'Đã duyệt'
                                            ? const Color.fromRGBO(
                                                79, 208, 138, 1)
                                            : i['status_vn'] == 'Chờ duyệt'
                                                ? const Color.fromRGBO(
                                                    231, 171, 33, 1)
                                                : const Color.fromRGBO(
                                                    240, 74, 71, 1),
                                        txalign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
