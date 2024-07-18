import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/data/services/assets_page/GetGainOrLost.dart';
import 'package:nvs_trading/data/services/assets_page/GetPerformance.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getBusDate.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:searchfield/searchfield.dart';

class ProfitOrLoss extends StatefulWidget {
  const ProfitOrLoss({super.key});

  @override
  State<ProfitOrLoss> createState() => _ProfitOrLossState();
}

class _ProfitOrLossState extends State<ProfitOrLoss> {
  String formatDateString(String dateTime) {
    return dateTime.split(' ')[0];
  }

  List<SearchFieldListItem> listsymbol = [];
  final TextEditingController symbol = TextEditingController();
  String datetime = '';
  String _startDate = '';
  String _endDate = '';
  List<dynamic> data = [];
  String selectedsymbol = 'ALL';
  dynamic acctno = HydratedBloc.storage.read('acctno');
  List filterdata = [];
  List filterdata1 = [];
  int chooseTime = 1;

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
      fetchdata1();
    } catch (e) {
      print('error:$e');
    }
  }

  Future<void> fetchdata() async {
    try {
      final response = await GetGainOrLost(
        acctno,
        _startDate,
        _endDate,
        selectedsymbol,
        1,
        50,
      );
      setState(() {
        filterdata = response;
      });
    } catch (e) {
      print('error:$e');
    }
  }

  Future<void> fetchdata1() async {
    try {
      final response = await GetPerformance(
        acctno,
        _startDate,
        _endDate,
        selectedsymbol,
        1,
        50,
      );
      setState(() {
        filterdata1 = response;
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

  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    fetchdatetime();
    fetchdata2();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: 'Lãi/lỗ đã thực hiện'),
      body: BlocBuilder<MarketInfoCubit, MarketInfoState>(
          builder: (context, state) {
        final marketInfo = state.marketInfo;
        List<String> symbols = [];
        List<String> listNameBank = [];
        for (var entry in marketInfo.entries) {
          String symbol = entry.value.symbol ?? "";
          symbols.add(symbol);
          String nameBank = entry.value.symbolName ?? "";
          listNameBank.add(nameBank);
        }
        if (listsymbol.isEmpty) {
          listsymbol = List.generate(symbols.length, (index) {
            String symbol = symbols[index];
            String nameBank = listNameBank[index];
            return SearchFieldListItem(symbol,
                child: Text("$symbol - $nameBank"));
          });
          listsymbol.sort((a, b) => a.searchKey.compareTo(b.searchKey));
        }

        return Padding(
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Theme.of(context).colorScheme.primary,
                height: 36,
                // child: DropdownButtonHideUnderline(
                //   child: DropdownButton2<String>(
                //     isExpanded: true,
                //     hint: customTextStyleBody(
                //       text: 'Mã CK',
                //       size: 10,
                //       color: Theme.of(context).hintColor,
                //     ),

                //     items: listsymbol
                //         .map((item) => DropdownMenuItem(
                //               value: item,
                //               child: Text(
                //                 item,
                //                 style: const TextStyle(
                //                   fontSize: 14,
                //                 ),
                //               ),
                //             ))
                //         .toList(),
                //     value: selectedsymbol != 'ALL' ? selectedsymbol : null,
                //     onChanged: (newvalue) {
                //       setState(() {
                //         selectedsymbol = newvalue ?? 'ALL';
                //         symbol.text = selectedsymbol;
                //         fetchdata();
                //         fetchdata1();
                //       });
                //     },
                //     buttonStyleData: const ButtonStyleData(
                //         padding: EdgeInsets.symmetric(horizontal: 16),
                //         height: 40,
                //         width: double.infinity),
                //     dropdownStyleData: const DropdownStyleData(
                //       maxHeight: 200,
                //     ),
                //     menuItemStyleData: const MenuItemStyleData(
                //       height: 40,
                //     ),
                //     dropdownSearchData: DropdownSearchData(
                //       searchController: symbol,
                //       searchInnerWidgetHeight: 50,
                //       searchInnerWidget: Container(
                //         height: 50,
                //         padding: const EdgeInsets.only(
                //           top: 8,
                //           bottom: 4,
                //           right: 8,
                //           left: 8,
                //         ),
                //         child: TextFormField(
                //           cursorColor: Theme.of(context).primaryColor,
                //           expands: true,
                //           maxLines: null,
                //           controller: symbol,
                //           decoration: InputDecoration(
                //             isDense: true,
                //             contentPadding: const EdgeInsets.symmetric(
                //               horizontal: 10,
                //               vertical: 8,
                //             ),
                //             hintText: 'Search for an item...',
                //             hintStyle: const TextStyle(fontSize: 12),
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             focusedBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(8),
                //               borderSide: BorderSide(
                //                 color: Theme.of(context).hintColor,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       searchMatchFn: (item, searchValue) {
                //         return item.value.toString().contains(searchValue);
                //       },
                //     ),
                //     //This to clear the search value when you close the menu
                //     onMenuStateChange: (isOpen) {
                //       if (!isOpen) {
                //         symbol.clear();
                //       }
                //     },
                //   ),
                // ),

                child: SearchField(
                  controller: symbol,
                  focusNode: _focusNode,
                  searchInputDecoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: SvgPicture.asset(
                        'assets/icons/ic_search.svg',
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).hintColor,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).hintColor,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 8),
                  ),
                  itemHeight: 60,
                  maxSuggestionsInViewPort: 2,
                  searchStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  suggestionStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  suggestions: listsymbol,
                  onSearchTextChanged: (p0) {
                    setState(() {
                      symbol.text = p0.toUpperCase();
                    });

                    return listsymbol
                        .where((element) =>
                            element.searchKey.contains(symbol.text))
                        .toList();
                  },
                  onSuggestionTap: (p0) async {
                    _focusNode.unfocus();
                    FocusScope.of(context).unfocus();
                    setState(() {
                      symbol.text = p0.searchKey;
                      selectedsymbol = symbol.text;
                    });
                    await fetchdata();
                    await fetchdata1();
                    setState(() {
                      symbol.clear();
                      selectedsymbol = "ALL";
                    });
                  },
                  onSubmit: (p0) async {
                    _focusNode.unfocus();
                    FocusScope.of(context).unfocus();
                    setState(() {
                      symbol.text = p0;
                      selectedsymbol = symbol.text;
                    });
                    if (symbol.text.isEmpty) {
                      selectedsymbol = "ALL";
                      await fetchdata();
                      await fetchdata1();
                    } else {
                      if (listsymbol
                              .contains(SearchFieldListItem(symbol.text)) &&
                          symbol.text.length == 3) {
                        await fetchdata();
                        await fetchdata1();
                        setState(() {
                          symbol.clear();
                          selectedsymbol = "ALL";
                        });
                      } else {
                        setState(() {
                          symbol.clear();
                          selectedsymbol = "ALL";
                        });
                      }
                    }
                  },
                ),
              ),
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
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
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
                              fetchdata1();
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
                                Image.asset("assets/icons/Vector.png"),
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
                            initialDate:
                                DateFormat('dd/MM/yyyy').parse(_endDate),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
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
                              _endDate =
                                  DateFormat('dd/MM/yyyy').format(picked);
                              fetchdata();
                              fetchdata1();
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
                                Image.asset("assets/icons/Vector.png"),
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
                          _startDate =
                              DateFormat("dd/MM/yyyy").format(startDate);
                          fetchdata();
                          fetchdata1();
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
                          _startDate =
                              DateFormat("dd/MM/yyyy").format(startDate);
                          fetchdata();
                          fetchdata1();
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
                          _startDate =
                              DateFormat("dd/MM/yyyy").format(startDate);
                          fetchdata();
                          fetchdata1();
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
                    text: 'Tổng cộng lãi/lỗ',
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w400,
                  ),
                  Row(children: [
                    for (var i in filterdata1)
                      customTextStyleBody(
                        text: NumberFormat.decimalPattern()
                            .format(int.parse(i['glvalue'])),
                        color: int.parse(i['glvalue']) >= 0
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
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: 'Tổng cộng lãi/lỗ (%)',
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w400,
                  ),
                  for (var i in filterdata1)
                    Row(
                      children: [
                        customTextStyleBody(
                          text: i['glpercent'],
                          color: double.parse(i['glpercent']) >= 0
                              ? const Color.fromRGBO(79, 208, 138, 1)
                              : const Color.fromRGBO(240, 74, 71, 1),
                        ),
                        const SizedBox(width: 3),
                        customTextStyleBody(
                          text: '%',
                          color: double.parse(i['glpercent']) >= 0
                              ? const Color.fromRGBO(79, 208, 138, 1)
                              : const Color.fromRGBO(240, 74, 71, 1),
                        )
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              customTextStyleBody(
                text: 'Lịch sử lãi lỗ đã thực hiện',
                size: 18,
                color: Theme.of(context).secondaryHeaderColor,
                fontWeight: FontWeight.w500,
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
                child: Container(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filterdata.length,
                    itemBuilder: (contex, index) {
                      final i = filterdata[index] as Map;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customTextStyleBody(
                                text: i['symbol'],
                                color: Theme.of(context).primaryColor,
                              ),
                              Row(children: [
                                customTextStyleBody(
                                  text: NumberFormat.decimalPattern()
                                      .format(int.parse(i['glvalue'])),
                                  color: int.parse(i['glvalue']) >= 0
                                      ? const Color.fromRGBO(79, 208, 138, 1)
                                      : const Color.fromRGBO(240, 74, 71, 1),
                                ),
                                const SizedBox(width: 3),
                                customTextStyleBody(
                                  text: 'VND',
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                )
                              ])
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customTextStyleBody(
                                text: formatDateString(i['txdate']),
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .color!,
                              ),
                              Row(children: [
                                customTextStyleBody(
                                  text: i['glpercent'],
                                  color: double.parse(i['glpercent']) >= 0
                                      ? const Color.fromRGBO(79, 208, 138, 1)
                                      : const Color.fromRGBO(240, 74, 71, 1),
                                ),
                                const SizedBox(width: 3),
                                customTextStyleBody(
                                  text: '%',
                                  color: double.parse(i['glpercent']) >= 0
                                      ? const Color.fromRGBO(79, 208, 138, 1)
                                      : const Color.fromRGBO(240, 74, 71, 1),
                                )
                              ]),
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
              ),
            ],
          ),
        );
      }),
    );
  }
}
