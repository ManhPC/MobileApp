import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getbusdate.dart';
import 'package:nvs_trading/data/services/order_book/historyOrder.dart';
import 'package:nvs_trading/presentation/view/provider/changeAcctno.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  dynamic Custodycd = HydratedBloc.storage.read('custodycd');
  String acctno = "";
  String? StartDate;
  String? EndDate;
  String? sort;

  //search symbol
  final TextEditingController symbol = TextEditingController();
  List<SearchFieldListItem> listsymbol = [];

  String? selectedsymbol;
  List<dynamic> selectedItems = ['ALL'];
  String selectedValue1 = 'ALL';
  List filterdata = [];
  String datetime = '';
  int selected = 1;
  final PageController _pageController = PageController();
  List<dynamic> data = [];

  // visible
  final List<bool> _isVisible = [];
  final List<bool> _isSelected = [];
  List<dynamic> data2 = [];
  String timeDone = "";

  //

  late FocusNode _focusNode;
  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    fetchdatetime();
    fetchdata1();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final changeAcctno = Provider.of<ChangeAcctno>(context, listen: false);
      setState(() {
        acctno = changeAcctno.acctno;
      });
      fetchdata();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final changeAcctno = Provider.of<ChangeAcctno>(context);
    if (acctno != changeAcctno.acctno) {
      setState(() {
        acctno = changeAcctno.acctno;
      });
      fetchdata();
    }
  }

  Future<void> fetchdatetime() async {
    try {
      final response = await GetBusDate(HydratedBloc.storage.read('token'));
      String busDate = "";
      if (response.statusCode == 200) {
        setState(() {
          busDate = response.data['dateserver'];
        });
      }
      setState(() {
        datetime = busDate;
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

  Future<void> fetchdata() async {
    try {
      final response = await historyData(
        Custodycd,
        acctno,
        _startDate,
        _endDate,
        symbol.text,
        selectedValue1 = 'ALL',
        selectedItems,
        sort = 'TXDATE DESC',
        1,
        50,
        HydratedBloc.storage.read('token'),
      );
      setState(() {
        filterdata = response;
      });
      for (var i = 0; i < filterdata.length; i++) {
        setState(() {
          _isVisible.add(false);
          _isSelected.add(false);
        });
      }
    } catch (e) {
      print('error:$e');
    }
  }

  Future<void> fetchdata1() async {
    try {
      final response = await GetAllCode(
          'API', 'ODORSTATUSHIST', HydratedBloc.storage.read('token'));
      data = response;
      data.insert(
        0,
        {'cdval': 'ALL', 'vN_CDCONTENT': 'Chọn tất cả'},
      );

      setState(() {});
    } catch (e) {
      print('error:$e');
    }
  }

  String _startDate = '';
  String _endDate = '';
  int chooseTime = 1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          BlocBuilder<MarketInfoCubit, MarketInfoState>(
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
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 36,
              // child: DropdownButtonHideUnderline(
              //   child: DropdownButton2<String>(
              //     isExpanded: true,
              //     hint: customTextStyleBody(
              //       text: 'Mã CK',
              //       size: 14,
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
              //     value: selectedsymbol,
              //     onChanged: (String? newvalue) {
              //       setState(() {
              //         selectedsymbol = newvalue;
              //         symbol.text = selectedsymbol!;

              //         fetchdata();
              //       });
              //     },
              //     buttonStyleData: const ButtonStyleData(
              //       padding: EdgeInsets.symmetric(horizontal: 8),
              //       height: 40,
              //       width: double.infinity,
              //     ),
              //     iconStyleData: IconStyleData(
              //       icon: const Icon(Icons.keyboard_arrow_down),
              //       iconEnabledColor: Theme.of(context).hintColor,
              //       iconSize: 16,
              //     ),
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
              //             enabledBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(8),
              //               borderSide:
              //                   BorderSide(color: Theme.of(context).hintColor),
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(8),
              //               borderSide:
              //                   BorderSide(color: Theme.of(context).hintColor),
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
                      .where(
                          (element) => element.searchKey.contains(symbol.text))
                      .toList();
                },
                onSuggestionTap: (p0) async {
                  _focusNode.unfocus();
                  FocusScope.of(context).unfocus();
                  setState(() {
                    symbol.text = p0.searchKey;
                  });
                  await fetchdata();
                  setState(() {
                    symbol.clear();
                  });
                },
                onSubmit: (p0) async {
                  _focusNode.unfocus();
                  FocusScope.of(context).unfocus();
                  setState(() {
                    symbol.text = p0;
                  });
                  if (symbol.text.isEmpty) {
                    await fetchdata();
                  } else {
                    if (listsymbol.contains(SearchFieldListItem(symbol.text)) &&
                        symbol.text.length == 3) {
                      await fetchdata();
                      setState(() {
                        symbol.clear();
                      });
                    } else {
                      setState(() {
                        symbol.clear();
                      });
                    }
                  }
                },
              ),
            );
          }),
          // ngay bat dau - ngay ket thuc
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
                        initialDate: DateFormat('dd/MM/yyyy').parse(_startDate),
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
                          _startDate = DateFormat('dd/MM/yyyy').format(picked);
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
                          Text(
                            _startDate,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Image.asset(
                            "assets/icons/Vector.png",
                            color: Theme.of(context).hintColor,
                          ),
                        ],
                      ),
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
                          Text(
                            _endDate,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Image.asset(
                            "assets/icons/Vector.png",
                            color: Theme.of(context).hintColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // in day , in week , in month
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
                    height: 18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (chooseTime == 1)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: customTextStyleBody(
                      text: "Trong ngày",
                      size: 10,
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
                    height: 18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (chooseTime == 2)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: customTextStyleBody(
                      text: "Trong tuần",
                      size: 10,
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
                    height: 18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (chooseTime == 3)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: customTextStyleBody(
                      text: "Trong tháng",
                      size: 10,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       margin: const EdgeInsets.only(bottom: 8),
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          //       decoration: BoxDecoration(
          //           color: Theme.of(context).colorScheme.primary,
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
          Expanded(
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filterdata.length,
                itemBuilder: (contex, index) {
                  final i = filterdata[index] as Map;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          List<dynamic> res = [];

                          if (_isSelected[int.parse(i['stt']) - 1] == false) {
                            res = await historyData(
                              Custodycd,
                              acctno,
                              _startDate,
                              _endDate,
                              symbol.text,
                              selectedValue1 = 'ALL',
                              [i['orstatus']],
                              sort = 'TXDATE DESC',
                              1,
                              50,
                              HydratedBloc.storage.read('token'),
                            );
                          }
                          setState(() {
                            if (_isSelected[int.parse(i['stt']) - 1] == false) {
                              _isSelected.fillRange(
                                  0, _isSelected.length, false);
                              _isVisible.fillRange(0, _isVisible.length, false);
                            }
                            _isSelected[int.parse(i['stt']) - 1] =
                                !_isSelected[int.parse(i['stt']) - 1];
                            // if (!_isSelected[int.parse(i['stt']) - 1]) {
                            //   _isVisible[int.parse(i['stt']) - 1] = false;
                            // }

                            data2.clear();
                            timeDone = "";
                            data2 = res;
                          });

                          if (data2[data2.indexWhere((element) =>
                                      element['orderid'] == i['orderid'])]
                                  ['matchlist'] !=
                              "") {
                            String a = data2[data2.indexWhere((element) =>
                                    element['orderid'] == i['orderid'])]
                                ['matchlist'];

                            List<String> parts = a.split('\$');
                            // Lấy phần tử cuối cùng chứa thông tin ngày và thời gian
                            String dateTimeString = parts.last.trim();
                            List<String> parts2 = dateTimeString.split('-');
                            timeDone =
                                "${parts2[1].trim()} ${parts2[0].trim()}";
                          } else {
                            timeDone = "";
                          }
                        },
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          duration: const Duration(milliseconds: 700),
                          width: double.infinity,
                          height:
                              _isSelected[int.parse(i['stt']) - 1] ? 194 : 46,
                          curve: Curves.easeInOut,
                          onEnd: _isSelected[int.parse(i['stt']) - 1]
                              ? () {
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    setState(() {
                                      _isVisible[int.parse(i['stt']) - 1] =
                                          true;
                                    });
                                  });
                                }
                              : () {
                                  setState(() {
                                    _isVisible[int.parse(i['stt']) - 1] = false;
                                  });
                                },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, top: 6),
                                child: Row(
                                  verticalDirection: VerticalDirection.down,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 76,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customTextStyleBody(
                                            text: i['symbol'],
                                            color:
                                                Theme.of(context).primaryColor,
                                            txalign: TextAlign.start,
                                          ),
                                          customTextStyleBody(
                                            text: i['orstatus_text'],
                                            size: 12,
                                            color: i['orstatus'] == "4"
                                                ? const Color.fromRGBO(
                                                    79, 208, 138, 1)
                                                : i['orstatus'] == "3"
                                                    ? const Color(0xffF04A47)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .color!,
                                            txalign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 76,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customTextStyleBody(
                                              text:
                                                  NumberFormat.decimalPattern()
                                                      .format(int.parse(
                                                              i['quoteprice']) /
                                                          1000),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              txalign: TextAlign.start),
                                          customTextStyleBody(
                                            text: 'Giá',
                                            size: 12,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                            txalign: TextAlign.start,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 76,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customTextStyleBody(
                                            text: Utils().formatNumber(
                                                int.parse(i['orderqtty'])),
                                            color:
                                                Theme.of(context).primaryColor,
                                            txalign: TextAlign.start,
                                          ),
                                          customTextStyleBody(
                                            text: 'Khối lượng',
                                            size: 12,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                            txalign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 76,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customTextStyleBody(
                                            text: i['exectype_text'],
                                            color: i['exectype'] == 'NB'
                                                ? const Color.fromRGBO(
                                                    79, 208, 138, 1)
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
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Visibility(
                                  visible: _isVisible[int.parse(i['stt']) - 1],
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customTextStyleBody(
                                              text: "Thời gian đặt",
                                              size: 12,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                            ),
                                            customTextStyleBody(
                                              text:
                                                  "${i['txtime']} ${DateFormat('dd/MM/yyyy').format(DateFormat("M/d/yyyy hh:mm:ss a").parse(i['txdate']))}",
                                              size: 12,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customTextStyleBody(
                                              text: (i['orstatus'] == '4')
                                                  ? "Thời gian khớp"
                                                  : "Thời gian hủy",
                                              size: 12,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                            ),
                                            customTextStyleBody(
                                              text: timeDone == ""
                                                  ? "--"
                                                  : timeDone,
                                              size: 12,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customTextStyleBody(
                                              text: "Khối lượng khớp",
                                              size: 12,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                            ),
                                            customTextStyleBody(
                                              text: Utils().formatNumber(
                                                  int.parse(i['execqtty'])),
                                              size: 12,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customTextStyleBody(
                                              text: "Khối lượng đặt",
                                              size: 12,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                            ),
                                            customTextStyleBody(
                                              text: Utils().formatNumber(
                                                  int.parse(i['orderqtty'])),
                                              size: 12,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customTextStyleBody(
                                            text: "Giá khớp trung bình",
                                            size: 12,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                          ),
                                          customTextStyleBody(
                                            text: Utils().formatNumber(
                                                int.parse(i['matchprice'])),
                                            size: 12,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
