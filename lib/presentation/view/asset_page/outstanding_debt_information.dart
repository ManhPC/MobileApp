import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getBusDate.dart';
import 'package:nvs_trading/data/services/tra_no/getLoanContract.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class OutDebtInfo extends StatefulWidget {
  const OutDebtInfo({super.key});

  @override
  State<OutDebtInfo> createState() => _OutDebtInfoState();
}

class _OutDebtInfoState extends State<OutDebtInfo> {
  String formatDateString(String dateTime) {
    return dateTime.split(' ')[0];
  }

  List<bool> selected = [];
  List<bool> visible = [];
  String sort = 'DUEDATE DESC';
  String datetime = '';
  String _startDate = '';
  String _endDate = '';
  List<dynamic> data = [];
  dynamic Custodycd = HydratedBloc.storage.read('custodycd');
  dynamic Acctno = HydratedBloc.storage.read('acctno');
  String TransactionType = 'ALL';
  List filterdata = [];
  String PS = '';
  Future<void> fetchdatetime() async {
    try {
      final response = await GetBusDate(HydratedBloc.storage.read('token'));
      setState(() {
        datetime = response.data['dateserver'];
        print(datetime);
        DateTime dateTime = DateTime.parse(datetime);
        _endDate = DateFormat('dd/MM/yyyy').format(dateTime);
        DateTime startDate = dateTime.subtract(const Duration(days: 30));
        _startDate = DateFormat("dd/MM/yyyy").format(startDate);
      });
      fetchdata();
    } catch (e) {
      print('error:$e');
    }
  }

  void fetchdata() async {
    try {
      final response = await getLoanContract(
          Custodycd, Acctno, _startDate, _endDate, sort, 1, 50);
      print(response);
      setState(() {
        filterdata = response;
        selected = List<bool>.filled(filterdata.length, false);
        visible = List<bool>.filled(filterdata.length, false);
      });
    } catch (e) {
      print('error:$e');
    }
  }

  Future<void> fetchdata2() async {
    try {
      final response = await GetAllCode(
          'API', 'ODORSTATUS', HydratedBloc.storage.read('token'));
      data = response;

      print(data);
      setState(() {});
    } catch (e) {
      print('error:$e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdatetime();
    fetchdata2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Thông tin dư nợ"),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateFormat('dd/MM/yyyy').parse(_startDate),
                          firstDate: (DateFormat('dd/MM/yyyy').parse(_endDate))
                              .subtract(const Duration(days: 90)),
                          lastDate: DateFormat('dd/MM/yyyy').parse(_endDate),
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
                          setState(() {
                            _startDate =
                                DateFormat('dd/MM/yyyy').format(picked);
                            fetchdata();
                          });
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
                              Image.asset(
                                "assets/icons/Vector.png",
                                color: Theme.of(context).hintColor,
                              ),
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateFormat('dd/MM/yyyy').parse(_endDate),
                          firstDate: (DateFormat('dd/MM/yyyy').parse(_endDate))
                              .subtract(const Duration(days: 90)),
                          lastDate: DateFormat('dd/MM/yyyy').parse(_endDate),
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
                          setState(() {
                            _endDate = DateFormat('dd/MM/yyyy').format(picked);
                            fetchdata();
                          });
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
                              Image.asset(
                                "assets/icons/Vector.png",
                                color: Theme.of(context).hintColor,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              customTextStyleBody(
                text: 'Tổng cộng',
                color: Theme.of(context).textTheme.titleSmall!.color!,
              ),
              Row(
                children: [
                  customTextStyleBody(
                    text: '-',
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 2),
                  customTextStyleBody(
                    text: 'VND',
                    size: 12,
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  )
                ],
              ),
              customTextStyleBody(
                text: 'Tổng lãi phí tạm tính',
                color: Theme.of(context).textTheme.titleSmall!.color!,
              ),
              Row(
                children: [
                  customTextStyleBody(
                    text: '-',
                    size: 10,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 2),
                  customTextStyleBody(
                    text: 'VND',
                    size: 12,
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                ],
              )
            ]),
            const SizedBox(height: 14),
            customTextStyleBody(
              text: 'Danh sách các khoản vay',
              size: 18,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 90,
                    child: customTextStyleBody(
                      text: 'Số hiệu',
                      txalign: TextAlign.start,
                      size: 12,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: customTextStyleBody(
                      text: 'Ngày phát sinh',
                      txalign: TextAlign.start,
                      size: 12,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: customTextStyleBody(
                      text: 'Ngày đến hạn',
                      txalign: TextAlign.start,
                      size: 12,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: customTextStyleBody(
                      text: 'Tổng nợ',
                      txalign: TextAlign.start,
                      size: 12,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filterdata.length,
                itemBuilder: (contex, index) {
                  final i = filterdata[index] as Map;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selected[index] = !selected[index];
                        visible[index] = !visible[index];
                      });
                    },
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 8),
                      duration: const Duration(milliseconds: 400),
                      width: double.infinity,
                      height: selected[index] ? 129 : 54,
                      curve: Curves.ease,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Column(
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
                                  width: 90,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: i['loanid'],
                                        size: 12,
                                        color: Theme.of(context).primaryColor,
                                        txalign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                          text: i['txdate'],
                                          size: 12,
                                          color: Theme.of(context).primaryColor,
                                          txalign: TextAlign.start),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                          text: i['duedate'],
                                          size: 12,
                                          color: Theme.of(context).primaryColor,
                                          txalign: TextAlign.start),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                          text: NumberFormat.decimalPattern()
                                              .format(int.parse(i['loanamt'])),
                                          size: 12,
                                          color: Theme.of(context).primaryColor,
                                          txalign: TextAlign.start),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            maintainState: false,
                            visible: visible[index],
                            child: Flexible(
                              child: Column(
                                children: [
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customTextStyleBody(
                                                text: 'Nợ gốc còn lại',
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .color!,
                                                txalign: TextAlign.start),
                                            Row(
                                              children: [
                                                customTextStyleBody(
                                                    text: NumberFormat
                                                            .decimalPattern()
                                                        .format(int.parse(i[
                                                            'remain_loanamt'])),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    txalign: TextAlign.end),
                                                const SizedBox(width: 2),
                                                customTextStyleBody(
                                                  text: 'VND',
                                                  size: 12,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .color!,
                                                  txalign: TextAlign.end,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customTextStyleBody(
                                                text: 'Số  ngày còn lại',
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .color!,
                                                txalign: TextAlign.start),
                                            Row(
                                              children: [
                                                customTextStyleBody(
                                                    text: i['daynumber'],
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    txalign: TextAlign.end),
                                                const SizedBox(width: 2),
                                                customTextStyleBody(
                                                  text: 'Ngày',
                                                  size: 12,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .color!,
                                                  txalign: TextAlign.end,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customTextStyleBody(
                                                text: 'Lãi/phí tạm tính',
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .color!,
                                                txalign: TextAlign.start),
                                            Row(
                                              children: [
                                                customTextStyleBody(
                                                    text: NumberFormat
                                                            .decimalPattern()
                                                        .format(int.parse(
                                                            i['acrintamt'])),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    txalign: TextAlign.end),
                                                const SizedBox(width: 2),
                                                customTextStyleBody(
                                                  text: 'VND',
                                                  size: 12,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .color!,
                                                  txalign: TextAlign.end,
                                                  fontWeight: FontWeight.w400,
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
