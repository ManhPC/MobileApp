import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/order_book/order_type.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/order_book/CancelAllOrders.dart';
import 'package:nvs_trading/data/services/order_book/getlistorderinday.dart';
import 'package:nvs_trading/presentation/view/provider/changeAcctno.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/dialog_cancel_all.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class TradingInDay extends StatefulWidget {
  const TradingInDay({super.key});

  @override
  State<TradingInDay> createState() => _TradingInDayState();
}

final class _TradingInDayState extends State<TradingInDay> {
  dynamic Custodycd = HydratedBloc.storage.read('custodycd');

  String? status;
  String? allowCancel;

  String? from;
  String? to;

  String selectedValue1 = '';

  List<dynamic> selectedItems = [];

  dynamic value;

  List<bool> selected2 = [];
  List<bool> visible2 = [];
  final TextEditingController symbol = TextEditingController();
  //list search
  List<SearchFieldListItem> listsymbol = [];

  String? selectedsymbol;

  late Future datalist;
  List filterdata = [];
  List<dynamic> data = [];
  bool selectAll = false;
  bool selectAllorderid = false;
  List selectedorderid = [];

  // sửa
  TextEditingController giadat = TextEditingController();
  TextEditingController khoiluong = TextEditingController();
  String currentGiadat = "";
  String currentKL = "";

  // msg toast
  late FToast fToast;

  //
  String acctno = "";

  //
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    fToast = FToast();
    fToast.init(context);

    fetchStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final changeAcctno = Provider.of<ChangeAcctno>(context, listen: false);
      setState(() {
        acctno = changeAcctno.acctno;
      });
      fetchData();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final changeAcctno = Provider.of<ChangeAcctno>(context);
    if (acctno != changeAcctno.acctno) {
      setState(() {
        acctno = changeAcctno.acctno;
      });
      fetchData();
    }
  }

  Future<void> fetchStatus() async {
    try {
      final response = await GetAllCode(
          'API', 'ODORSTATUS', HydratedBloc.storage.read('token'));
      data = response;
      data.insert(
        0,
        {'cdval': 'ALL', 'vN_CDCONTENT': 'Chọn tất cả'},
      );
      for (var i in data) {
        checkboxStates[i['cdval']] = false;
      }
      setState(() {});
    } catch (e) {
      print('error:$e');
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await FilterData(
        Custodycd,
        acctno,
        selectedItems,
        selectedValue1,
        symbol.text,
        1,
        50,
        HydratedBloc.storage.read('token'),
      );

      setState(() {
        filterdata = response;
      });

      selected2 = List<bool>.filled(filterdata.length, false);
      visible2 = List<bool>.filled(filterdata.length, false);
      print('lengh:${filterdata.length}');
    } catch (e) {
      print('error A:$e');
    }
  }

  Map<String, bool> checkboxStates = {};

  var marketInfo;
  @override
  Widget build(BuildContext context) {
    //print("ll:$filterdata");
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            InkWell(
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/candle-2.svg",
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Bộ lọc',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(231, 171, 33, 1),
                    ),
                  ),
                ],
              ),
              onTap: () {
                showModalBottomSheet(
                    barrierColor: Colors.transparent,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 24, top: 6),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Text(
                                      'Bộ lọc',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Divider(
                                      color: Theme.of(context).hintColor,
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      width: double.infinity,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 36,
                                        child: PopupMenuButton<int>(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            maxHeight: 200,
                                          ),
                                          itemBuilder: (BuildContext context) {
                                            return [
                                              PopupMenuItem<int>(
                                                enabled: false,
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: StatefulBuilder(
                                                    builder: (context,
                                                        menuSetState) {
                                                      return Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            CheckboxListTile(
                                                              activeColor: Theme
                                                                      .of(context)
                                                                  .secondaryHeaderColor,
                                                              title:
                                                                  customTextStyleBody(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 14,
                                                                txalign:
                                                                    TextAlign
                                                                        .start,
                                                                text:
                                                                    "Chọn tất cả",
                                                              ),
                                                              controlAffinity:
                                                                  ListTileControlAffinity
                                                                      .leading,
                                                              value: selectAll,
                                                              onChanged: (bool?
                                                                  value) {
                                                                menuSetState(
                                                                    () {
                                                                  selectAll =
                                                                      value ??
                                                                          false;
                                                                  if (selectAll) {
                                                                    selectedItems = data
                                                                        .map((item) =>
                                                                            item['cdval']
                                                                                as String)
                                                                        .toList();
                                                                  } else {
                                                                    selectedItems
                                                                        .clear();
                                                                  }
                                                                });
                                                                setState(() {});
                                                              },
                                                            ),
                                                            ...data.map((item) {
                                                              return CheckboxListTile(
                                                                activeColor: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                                title:
                                                                    customTextStyleBody(
                                                                  size: 14,
                                                                  txalign:
                                                                      TextAlign
                                                                          .start,
                                                                  text: item[
                                                                      'vN_CDCONTENT']!,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                                controlAffinity:
                                                                    ListTileControlAffinity
                                                                        .leading,
                                                                value: selectedItems
                                                                    .contains(item[
                                                                        'cdval']),
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  menuSetState(
                                                                      () {
                                                                    if (value ==
                                                                        true) {
                                                                      selectedItems
                                                                          .add(item[
                                                                              'cdval']!);
                                                                    } else {
                                                                      selectedItems
                                                                          .remove(
                                                                              item['cdval']);
                                                                    }
                                                                    selectAll =
                                                                        selectedItems.length ==
                                                                            data.length;
                                                                  });
                                                                  setState(
                                                                      () {});
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
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    selectedItems.isEmpty
                                                        ? 'Trạng thái'
                                                        : data
                                                            .where((item) =>
                                                                selectedItems
                                                                    .contains(item[
                                                                        'cdval']))
                                                            .map((item) => item[
                                                                'vN_CDCONTENT'])
                                                            .join(', '),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Icon(Icons.arrow_drop_down,
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      width: double.infinity,
                                      height: 30,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          iconStyleData: IconStyleData(
                                              iconEnabledColor:
                                                  Theme.of(context).hintColor),
                                          isExpanded: true,
                                          hint: Text(
                                            'Tất cả',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          items: listMB
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.code,
                                                    child: Text(
                                                      item.name,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: selectedValue1,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedValue1 = value!;
                                            });
                                          },
                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                          buttonStyleData:
                                              const ButtonStyleData(
                                            padding: EdgeInsets.only(
                                                left: 16, right: 8),
                                            height: 40,
                                            width: 140,
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            height: 28,
                                            width: double.infinity,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  color: Theme.of(context)
                                                      .buttonTheme
                                                      .colorScheme!
                                                      .background,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Đóng',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .buttonTheme
                                                      .colorScheme!
                                                      .background,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 24,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 28,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                    2,
                                                  )),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .buttonTheme
                                                          .colorScheme!
                                                          .background,
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .buttonTheme
                                                          .colorScheme!
                                                          .primary,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    print("ll:$selectedsymbol");
                                                    // FilterData(
                                                    //     Custodycd,
                                                    //     Acctno,
                                                    //     selectedItems,
                                                    //     selectedValue1,
                                                    //     symbol.text,
                                                    //     1,
                                                    //     50,
                                                    //     HydratedBloc.storage
                                                    //         .read('token'));
                                                    fetchData();
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Áp dụng',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    });
              },
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            BlocBuilder<MarketInfoCubit, MarketInfoState>(
              builder: (context, state) {
                marketInfo = state.marketInfo;
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

                return Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    // child: DropdownButtonHideUnderline(
                    //   child: DropdownButton2<String>(
                    //     isExpanded: true,
                    //     hint: Text(
                    //       'Mã CK',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         color: Theme.of(context).hintColor,
                    //       ),
                    //     ),

                    //     items: listsymbol
                    //         .map((item) => DropdownMenuItem(
                    //               value: item,
                    //               child: Text(
                    //                 item,
                    //                 style: TextStyle(
                    //                   fontSize: 14,
                    //                   color: Theme.of(context).primaryColor,
                    //                 ),
                    //               ),
                    //             ))
                    //         .toList(),
                    //     value: selectedsymbol,
                    //     onChanged: (String? newvalue) {
                    //       setState(() {
                    //         selectedsymbol = newvalue;
                    //         symbol.text = newvalue!;
                    //         fetchData();
                    //       });
                    //     },
                    //     buttonStyleData: const ButtonStyleData(
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       height: 40,
                    //       width: 200,
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
                        });
                        await fetchData();
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
                          await fetchData();
                        } else {
                          if (listsymbol
                                  .contains(SearchFieldListItem(symbol.text)) &&
                              symbol.text.length == 3) {
                            await fetchData();
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
                  ),
                );
              },
            ),
            const SizedBox(
              width: 12,
            ),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  filterdata.every((i) => i['allowcancel'] == '0')
                      ? null
                      : huytatca(context, selectedorderid);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(240, 74, 71, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Hủy tất cả',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 75,
                child: Row(
                  children: [
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      checkColor:
                          Theme.of(context).buttonTheme.colorScheme!.primary,
                      activeColor:
                          Theme.of(context).buttonTheme.colorScheme!.background,
                      side: BorderSide(
                        color: filterdata.every((i) => i['allowcancel'] == '0')
                            ? Colors.grey
                            : const Color.fromRGBO(255, 255, 255, 1),
                        width: 2,
                      ),
                      value: selectAllorderid,
                      onChanged: filterdata
                              .every((i) => i['allowcancel'] == '0')
                          ? null
                          : (bool? value) {
                              setState(() {
                                selectAllorderid = value ?? false;
                                if (selectAllorderid) {
                                  selectedorderid = filterdata
                                      .map((item) => item['orderid'] as String)
                                      .toList();
                                } else {
                                  selectedorderid.clear();
                                }
                              });
                              setState(() {});
                            },
                    ),
                    Text(
                      'Mã CK',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 66,
                child: Text(
                  'M/B',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'Đặt ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'Khớp',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                ),
              ),
              SizedBox(
                width: 72,
                child: Text(
                  'Còn lại',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
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
              itemBuilder: (context, index) {
                final i = filterdata[index] as Map;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected2[index] = !selected2[index];
                      visible2[index] = !visible2[index];
                    });
                  },
                  child: AnimatedContainer(
                    margin: const EdgeInsets.only(bottom: 8),
                    duration: const Duration(milliseconds: 400),
                    width: double.infinity,
                    height: selected2[index] ? 90 : 50,
                    curve: Curves.ease,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
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
                                width: 75,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                      checkColor: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .primary,
                                      activeColor: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .background,
                                      side: BorderSide(
                                          width: 2,
                                          color: i['allowcancel'] == '0'
                                              ? Colors.grey
                                              : const Color.fromRGBO(
                                                  255, 255, 255, 1)),
                                      value: selectedorderid
                                          .contains(i['orderid']),
                                      onChanged: i['allowcancel'] == '0'
                                          ? null
                                          : (bool? value) {
                                              setState(() {
                                                if (value == true) {
                                                  selectedorderid
                                                      .add(i['orderid']!);
                                                } else {
                                                  selectedorderid
                                                      .remove(i['orderid']);
                                                  selectAllorderid = false;
                                                }
                                                selectAllorderid =
                                                    selectedorderid.length ==
                                                        filterdata.length;
                                              });
                                              setState(() {});
                                            },
                                    ),
                                    const SizedBox(width: 2),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customTextStyleBody(
                                          text: i['symbol'].toString(),
                                          color: Theme.of(context).primaryColor,
                                          txalign: TextAlign.start,
                                        ),
                                        customTextStyleBody(
                                          text: i['txtime'].toString(),
                                          size: 10,
                                          color: Theme.of(context).primaryColor,
                                          txalign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 66,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTextStyleBody(
                                        text: i['exectypedisplay'].toString(),
                                        color: (i['exectype'] == "NB")
                                            ? const Color(0xff4FD08A)
                                            : const Color.fromRGBO(
                                                240, 74, 71, 1),
                                        txalign: TextAlign.start),
                                    customTextStyleBody(
                                      text: i['matchtype_en'].toString(),
                                      size: 10,
                                      color: Theme.of(context).primaryColor,
                                      txalign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTextStyleBody(
                                      text: i['orderqtty'].toString(),
                                      color: Theme.of(context).primaryColor,
                                      txalign: TextAlign.start,
                                    ),
                                    customTextStyleBody(
                                      text:
                                          NumberFormat.decimalPattern().format(
                                        int.parse(
                                              i['quoteprice'] ?? 0,
                                            ) /
                                            1000,
                                      ),
                                      size: 10,
                                      color: Theme.of(context).primaryColor,
                                      txalign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTextStyleBody(
                                      text: i['execqtty'].toString(),
                                      color: Theme.of(context).primaryColor,
                                      txalign: TextAlign.start,
                                    ),
                                    customTextStyleBody(
                                      text: (i['matchprice'] == null)
                                          ? "--"
                                          : "${int.parse(i['matchprice']) / 1000}",
                                      size: (i['matchprice'] == null) ? 14 : 10,
                                      color: Theme.of(context).primaryColor,
                                      txalign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 74,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    customTextStyleBody(
                                      text: i['remainqtty'].toString(),
                                      color: Theme.of(context).primaryColor,
                                      txalign: TextAlign.end,
                                    ),
                                    customTextStyleBody(
                                      text: i['orstatus'].toString(),
                                      size: 10,
                                      color: (i['orstatusvl'] == "2" ||
                                              i['orstatusvl'] == '8')
                                          ? const Color(0xffCCAC3D)
                                          : (i['orstatusvl'] == '4' ||
                                                  i['orstatusvl'] == '13')
                                              ? const Color(0xff4fd08a)
                                              : (i['orstatusvl'] == '3')
                                                  ? const Color(0xffF04A47)
                                                  : Theme.of(context)
                                                      .primaryColor,
                                      txalign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: visible2[index],
                          child: Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 28,
                                  child: ElevatedButton(
                                    onPressed: (i['allowadjust'] == '1')
                                        ? () {
                                            setState(() {
                                              String formattedText =
                                                  (int.parse(i['quoteprice']) /
                                                          1000)
                                                      .toStringAsFixed(2);
                                              if (formattedText.contains('.') &&
                                                  formattedText.endsWith('0')) {
                                                // Loại bỏ số 0 ở cuối nếu có
                                                formattedText =
                                                    formattedText.substring(
                                                        0,
                                                        formattedText.length -
                                                            1);
                                                if (formattedText
                                                        .contains('.') &&
                                                    formattedText
                                                        .endsWith('0')) {
                                                  formattedText =
                                                      formattedText.substring(
                                                          0,
                                                          formattedText.length -
                                                              1);
                                                  // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                  if (formattedText
                                                      .endsWith('.')) {
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                  }
                                                }
                                              }
                                              giadat.text = formattedText;
                                              currentGiadat = formattedText;
                                              khoiluong.text = i['orderqtty'];
                                              currentKL = i['orderqtty'];
                                            });
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                  title: customTextStyleBody(
                                                    text: "Sửa lệnh",
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor,
                                                    size: 16,
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text: "Loại lệnh",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                customTextStyleBody(
                                                              text: i[
                                                                  'exectypedisplay'],
                                                              size: 14,
                                                              color:
                                                                  (i['exectype'] ==
                                                                          "NS")
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .green,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  "Mã chứng khoán",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                customTextStyleBody(
                                                              text: i['symbol'],
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text: "Giá đặt",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  currentGiadat,
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  "Giá đặt mới",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          Card(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            elevation: 0,
                                                            child: SizedBox(
                                                              height: 24,
                                                              width: 100,
                                                              child: TextField(
                                                                controller:
                                                                    giadat,
                                                                cursorColor: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                cursorHeight:
                                                                    20,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                decoration:
                                                                    InputDecoration(
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Theme.of(context).hintColor),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Theme.of(context).hintColor),
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .only(),
                                                                  prefix:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      String
                                                                          gia =
                                                                          giadat
                                                                              .text;

                                                                      String
                                                                          market =
                                                                          marketInfo[i['symbol']].marketCode ??
                                                                              "";
                                                                      double
                                                                          giaDatDouble =
                                                                          0;
                                                                      if (gia
                                                                          .isEmpty) {
                                                                        giaDatDouble =
                                                                            0;
                                                                      } else {
                                                                        giaDatDouble =
                                                                            double.parse(gia);
                                                                      }
                                                                      print(
                                                                          market);
                                                                      if (market ==
                                                                          "STO") {
                                                                        if (giaDatDouble <
                                                                            10) {
                                                                          giaDatDouble -=
                                                                              0.01;
                                                                        } else if (giaDatDouble <=
                                                                            49.95) {
                                                                          giaDatDouble -=
                                                                              0.05;
                                                                        } else {
                                                                          giaDatDouble -=
                                                                              0.1;
                                                                        }
                                                                      } else {
                                                                        giaDatDouble -=
                                                                            0.1;
                                                                      }
                                                                      String
                                                                          formattedText =
                                                                          giaDatDouble
                                                                              .toStringAsFixed(2);
                                                                      if (formattedText.contains(
                                                                              '.') &&
                                                                          formattedText
                                                                              .endsWith('0')) {
                                                                        // Loại bỏ số 0 ở cuối nếu có
                                                                        formattedText = formattedText.substring(
                                                                            0,
                                                                            formattedText.length -
                                                                                1);
                                                                        if (formattedText.contains('.') &&
                                                                            formattedText.endsWith('0')) {
                                                                          formattedText = formattedText.substring(
                                                                              0,
                                                                              formattedText.length - 1);
                                                                          // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                                          if (formattedText
                                                                              .endsWith('.')) {
                                                                            formattedText =
                                                                                formattedText.substring(0, formattedText.length - 1);
                                                                          }
                                                                        }
                                                                      }
                                                                      giadat.text =
                                                                          formattedText;
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          12,
                                                                      width: 12,
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              4),
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  suffix:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      String
                                                                          gia =
                                                                          giadat
                                                                              .text;
                                                                      String
                                                                          market =
                                                                          marketInfo[i['symbol']].marketCode ??
                                                                              "";
                                                                      double
                                                                          giaDatDouble =
                                                                          0;
                                                                      if (gia
                                                                          .isEmpty) {
                                                                        giaDatDouble =
                                                                            0;
                                                                      } else {
                                                                        giaDatDouble =
                                                                            double.parse(gia);
                                                                      }
                                                                      if (market ==
                                                                          "STO") {
                                                                        if (giaDatDouble <
                                                                            10) {
                                                                          giaDatDouble +=
                                                                              0.01;
                                                                        } else if (giaDatDouble <=
                                                                            49.95) {
                                                                          giaDatDouble +=
                                                                              0.05;
                                                                        } else {
                                                                          giaDatDouble +=
                                                                              0.1;
                                                                        }
                                                                      } else {
                                                                        giaDatDouble +=
                                                                            0.1;
                                                                      }

                                                                      String
                                                                          formattedText =
                                                                          giaDatDouble
                                                                              .toStringAsFixed(2);
                                                                      if (formattedText.contains(
                                                                              '.') &&
                                                                          formattedText
                                                                              .endsWith('0')) {
                                                                        // Loại bỏ số 0 ở cuối nếu có
                                                                        formattedText = formattedText.substring(
                                                                            0,
                                                                            formattedText.length -
                                                                                1);
                                                                        if (formattedText.contains('.') &&
                                                                            formattedText.endsWith('0')) {
                                                                          formattedText = formattedText.substring(
                                                                              0,
                                                                              formattedText.length - 1);
                                                                          // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                                          if (formattedText
                                                                              .endsWith('.')) {
                                                                            formattedText =
                                                                                formattedText.substring(0, formattedText.length - 1);
                                                                          }
                                                                        }
                                                                      }
                                                                      giadat.text =
                                                                          formattedText;
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 14,
                                                                      height:
                                                                          12,
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              8),
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  "Khối lượng",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                customTextStyleBody(
                                                              text: currentKL,
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  "Khối lượng mới",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          Card(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            elevation: 0,
                                                            child: SizedBox(
                                                              height: 24,
                                                              width: 100,
                                                              child: TextField(
                                                                controller:
                                                                    khoiluong,
                                                                cursorColor: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                cursorHeight:
                                                                    20,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                decoration:
                                                                    InputDecoration(
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Theme.of(context).hintColor),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Theme.of(context).hintColor),
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .only(),
                                                                  prefix:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      String kl;
                                                                      if (khoiluong
                                                                          .text
                                                                          .isEmpty) {
                                                                        return;
                                                                      } else {
                                                                        kl = khoiluong
                                                                            .text;
                                                                      }
                                                                      int value =
                                                                          int.parse(
                                                                              kl);
                                                                      if (value >
                                                                          100) {
                                                                        setState(
                                                                            () {
                                                                          value -=
                                                                              100;
                                                                        });
                                                                        khoiluong.text =
                                                                            value.toString();
                                                                      } else if (value >
                                                                          0) {
                                                                        setState(
                                                                            () {
                                                                          value--;
                                                                        });
                                                                        khoiluong.text =
                                                                            value.toString();
                                                                      } else {
                                                                        khoiluong
                                                                            .clear();
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          12,
                                                                      width: 12,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary,
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              4),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  suffix:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      String kl;
                                                                      if (khoiluong
                                                                          .text
                                                                          .isEmpty) {
                                                                        kl =
                                                                            "0";
                                                                      } else {
                                                                        kl = khoiluong
                                                                            .text;
                                                                      }
                                                                      int value =
                                                                          int.parse(
                                                                              kl);
                                                                      if (value >
                                                                              99 ||
                                                                          value ==
                                                                              0) {
                                                                        setState(
                                                                            () {
                                                                          value +=
                                                                              100;
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          value++;
                                                                        });
                                                                      }
                                                                      khoiluong
                                                                              .text =
                                                                          value
                                                                              .toString();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 14,
                                                                      height:
                                                                          12,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary,
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  actions: <CupertinoDialogAction>[
                                                    CupertinoDialogAction(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          customTextStyleBody(
                                                        text: "Đóng",
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor,
                                                        size: 16,
                                                      ),
                                                    ),
                                                    CupertinoDialogAction(
                                                      onPressed: () async {
                                                        final response =
                                                            await editOrder(
                                                          i['orderid'],
                                                          i['exectype'],
                                                          giadat.text,
                                                          currentKL,
                                                          khoiluong.text,
                                                        );

                                                        if (response[0]
                                                                ['code'] ==
                                                            200) {
                                                          fToast.showToast(
                                                            gravity:
                                                                ToastGravity
                                                                    .TOP,
                                                            toastDuration:
                                                                const Duration(
                                                                    seconds: 2),
                                                            child:
                                                                msgNotification(
                                                              color:
                                                                  Colors.green,
                                                              icon: Icons
                                                                  .check_circle,
                                                              text: response[0]
                                                                  ['msg'],
                                                            ),
                                                          );
                                                          await Future.delayed(
                                                            const Duration(
                                                                seconds: 2),
                                                          );
                                                          await fetchData();
                                                          Navigator.of(context)
                                                              .pop();
                                                        } else {
                                                          fToast.showToast(
                                                            gravity:
                                                                ToastGravity
                                                                    .TOP,
                                                            toastDuration:
                                                                const Duration(
                                                                    seconds: 2),
                                                            child:
                                                                msgNotification(
                                                              color: Colors.red,
                                                              icon: Icons.error,
                                                              text: response[0]
                                                                  ['msg'],
                                                            ),
                                                          );
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                      child:
                                                          customTextStyleBody(
                                                        text: "Xác nhận",
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            79, 208, 138, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: const Text(
                                      'Sửa lệnh',
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 28,
                                  child: ElevatedButton(
                                    onPressed: (i['allowcancel'] == '1')
                                        ? () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                  title: customTextStyleBody(
                                                    text: "Hủy lệnh",
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor,
                                                    size: 16,
                                                  ),
                                                  content: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text: "Loại lệnh",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                customTextStyleBody(
                                                              text: i[
                                                                  'exectypedisplay'],
                                                              size: 14,
                                                              color:
                                                                  (i['exectype'] ==
                                                                          "NS")
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .green,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  "Mã chứng khoán",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                customTextStyleBody(
                                                              text: i['symbol'],
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text: "Giá đặt",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  "${int.parse(i['quoteprice']) / 1000}",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  "Khối lượng",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  " ${i['orderqtty']}",
                                                              size: 14,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              txalign: TextAlign
                                                                  .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  actions: <CupertinoDialogAction>[
                                                    CupertinoDialogAction(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          customTextStyleBody(
                                                        text: "Đóng",
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor,
                                                        size: 16,
                                                      ),
                                                    ),
                                                    CupertinoDialogAction(
                                                      onPressed: () async {
                                                        final response =
                                                            await Cancelorders(
                                                                i['orderid']);
                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          final List<dynamic>
                                                              data =
                                                              response.data[
                                                                  'listResult'];
                                                          if (data[0]['code'] ==
                                                              200) {
                                                            fToast.showToast(
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              toastDuration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              child:
                                                                  msgNotification(
                                                                color: Colors
                                                                    .green,
                                                                icon: Icons
                                                                    .check_circle,
                                                                text: data[0]
                                                                    ['msg'],
                                                              ),
                                                            );
                                                            fetchData();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {});
                                                          } else {
                                                            fToast.showToast(
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              toastDuration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              child:
                                                                  msgNotification(
                                                                color:
                                                                    Colors.red,
                                                                icon:
                                                                    Icons.error,
                                                                text: data[0]
                                                                    ['msg'],
                                                              ),
                                                            );
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                        } else {
                                                          print(response
                                                              .statusCode);
                                                        }
                                                      },
                                                      child:
                                                          customTextStyleBody(
                                                        text: "Xác nhận",
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            240, 74, 71, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: const Text(
                                      'Hủy lệnh',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: 14),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}

Future<dynamic> huytatca(BuildContext context, List orderid) {
  return showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => Container(
            child: CupertinoAlertDialog(
                title: Center(
                  child: customTextStyleBody(
                      text: 'Hủy tất cả',
                      color: const Color.fromRGBO(231, 171, 33, 1),
                      size: 16),
                ),
                content: customTextStyleBody(
                  text: 'Bạn có muốn hủy tất cả các lệnh đang chờ',
                  color: const Color.fromRGBO(226, 226, 226, 1),
                  size: 14,
                ),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    child: customTextStyleBody(
                      text: 'Đóng',
                      color: const Color.fromRGBO(226, 226, 226, 1),
                      size: 16,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: customTextStyleBody(
                        text: 'Xác nhận',
                        color: const Color.fromRGBO(226, 226, 226, 1),
                        size: 16),
                    onPressed: () {
                      Cancelallorders(
                        orderid,
                        HydratedBloc.storage.read('acctno'),
                      );

                      Navigator.pop(context);
                    },
                  )
                ]),
          ));
}
