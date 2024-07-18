import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/data/model/get_account_detail.dart';
import 'package:nvs_trading/data/services/GetAccountDetail.dart';
import 'package:nvs_trading/data/services/GetListMoneyStatement.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getbusdate.dart';
import 'package:nvs_trading/presentation/view/asset_page/form/genaral_Info.dart';
import 'package:nvs_trading/presentation/view/asset_page/form/money_Info.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class saoketien extends StatefulWidget {
  const saoketien({super.key});

  @override
  State<saoketien> createState() => _saoketienState();
}

class _saoketienState extends State<saoketien> {
  String formatDateString(String dateTime) {
    return dateTime.split(' ')[0];
  }

  String datetime = '';
  String _startDate = '';
  String _endDate = '';
  List<dynamic> data = [];
  List<dynamic> data1 = [];
  List<GetAccountDetailModel> data3 = [];
  dynamic Custodycd = HydratedBloc.storage.read('custodycd');
  dynamic Acctno = HydratedBloc.storage.read('acctno');
  Map<String, dynamic> filterdata = {};
  int chooseTime = 1;
  void fetchdata() async {
    try {
      final response = await getListMoneyStatement(
        Custodycd,
        Acctno,
        _startDate,
        _endDate,
        1,
        50,
        HydratedBloc.storage.read('token'),
      );
      print(response);
      setState(() {
        filterdata = response;
      });
      data1 = filterdata['data'];
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
          'API', 'ODORSTATUS', HydratedBloc.storage.read('token'));

      print(data);
      setState(() {
        data = response;
      });
    } catch (e) {
      print('error:$e');
    }
  }

  Future<void> fetchdata3() async {
    try {
      final response = await GetAccountDetail(Custodycd);

      setState(() {
        data3 = response;
      });
    } catch (e) {
      print('error:$e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdatetime();
    fetchdata1();
    fetchdata3();
  }

  @override
  Widget build(BuildContext context) {
    print('data${filterdata['data']}');
    return Scaffold(
      appBar: appBar(text: "Sao kê tiền"),
      body: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateFormat('dd/MM/yyyy').parse(_startDate),
                              firstDate:
                                  (DateFormat('dd/MM/yyyy').parse(_endDate))
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          width: double.infinity,
                          height: 32,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: customTextStyleBody(
                                text: 'Tất cả',
                                color: Theme.of(context).hintColor,
                              ),
                              items: data3
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.acctno,
                                        child: customTextStyleBody(
                                          text: item.acctno,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ))
                                  .toList(),
                              value: Acctno,
                              onChanged: (value) {
                                setState(() {
                                  Acctno = value!;
                                  fetchdata();
                                });
                              },
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              iconStyleData: IconStyleData(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 16,
                                iconEnabledColor: Theme.of(context).hintColor,
                              ),
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(left: 16, right: 8),
                                height: 40,
                                width: 140,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                      ],
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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        chooseTime = 1;
                        DateTime dateTime = DateTime.parse(datetime);
                        _endDate = DateFormat('dd/MM/yyyy').format(dateTime);
                        DateTime startDate =
                            dateTime.subtract(const Duration(days: 0));
                        _startDate = DateFormat("dd/MM/yyyy").format(startDate);
                        fetchdata();
                      });
                    },
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (chooseTime == 1)
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.transparent,
                      ),
                      child: customTextStyleBody(
                        text: "Hôm nay",
                        size: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        chooseTime = 2;
                        DateTime dateTime = DateTime.parse(datetime);
                        _endDate = DateFormat('dd/MM/yyyy').format(dateTime);
                        DateTime startDate =
                            dateTime.subtract(const Duration(days: 7));
                        _startDate = DateFormat("dd/MM/yyyy").format(startDate);
                        fetchdata();
                      });
                    },
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (chooseTime == 2)
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.transparent,
                      ),
                      child: customTextStyleBody(
                        text: "Một tuần",
                        size: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        chooseTime = 3;
                        DateTime dateTime = DateTime.parse(datetime);
                        _endDate = DateFormat('dd/MM/yyyy').format(dateTime);
                        DateTime startDate =
                            dateTime.subtract(const Duration(days: 30));
                        _startDate = DateFormat("dd/MM/yyyy").format(startDate);
                        fetchdata();
                      });
                    },
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (chooseTime == 3)
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.transparent,
                      ),
                      child: customTextStyleBody(
                        text: "Một tháng",
                        size: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextStyleBody(
                  text: 'Số dư đầu kỳ',
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                ),
                Row(
                  children: [
                    customTextStyleBody(
                      text: NumberFormat.decimalPattern().format(
                        int.tryParse(
                                filterdata['beG_BALANCE']?.toString() ?? '0') ??
                            0,
                      ),
                      color: (filterdata['beG_BALANCE'] ?? 0) >= 0
                          ? const Color.fromRGBO(79, 208, 138, 1)
                          : const Color.fromRGBO(240, 74, 71, 1),
                    ),
                    const SizedBox(width: 3),
                    customTextStyleBody(
                      text: 'VND',
                      size: 12,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextStyleBody(
                  text: 'Số dư cuối kỳ',
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                ),
                Row(children: [
                  customTextStyleBody(
                    text: NumberFormat.decimalPattern().format(
                      int.tryParse(
                              filterdata['enD_BALANCE']?.toString() ?? '0') ??
                          0,
                    ),
                    color: (filterdata['enD_BALANCE'] ?? 0) >= 0
                        ? const Color.fromRGBO(79, 208, 138, 1)
                        : const Color.fromRGBO(240, 74, 71, 1),
                  ),
                  const SizedBox(width: 3),
                  customTextStyleBody(
                    text: 'VND',
                    size: 12,
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  )
                ])
              ],
            ),
            const SizedBox(height: 16),
            customTextStyleBody(
              text: 'Danh sách các giao dịch',
              size: 18,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            // const SizedBox(height: 16),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Container(
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            //       decoration: BoxDecoration(
            //           color: Theme.of(context).colorScheme.secondary,
            //           borderRadius: BorderRadius.circular(5)),
            //       alignment: Alignment.center,
            //       height: 26,
            //       child: customTextStyleBody(
            //         text: '$_startDate - $_endDate',
            //         size: 10,
            //         color: Theme.of(context).primaryColor,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: data1.length,
                itemBuilder: (contex, index) {
                  final i = data1[index];
                  // for (var i in filterdata)
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 120,
                            // width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customTextStyleBody(
                                  txalign: TextAlign.start,
                                  text: i['tltxcd_name'],
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(height: 2),
                                customTextStyleBody(
                                  txalign: TextAlign.start,
                                  text: i['txdate'],
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: customTextStyleBody(
                                    text: i['description'],
                                    txalign: TextAlign.start,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  customTextStyleBody(
                                    text:
                                        '${i['cramt'] == '0' ? '-' : '+'}${NumberFormat.decimalPattern().format(int.parse(i['cramt'] == '0' ? '${i['dramt']}' : '${i['cramt']}'))}',
                                    color: i['dramt'] != '0'
                                        ? const Color.fromRGBO(240, 74, 71, 1)
                                        : i['cramt'] != '0'
                                            ? const Color.fromRGBO(
                                                79, 208, 138, 1)
                                            : Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 2),
                                  customTextStyleBody(
                                    text: 'VND',
                                    size: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              customTextStyleBody(
                                text: '_',
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .color!,
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        color: Theme.of(context).hintColor,
                        thickness: 1,
                      ),
                      const SizedBox(height: 12),
                    ],
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
