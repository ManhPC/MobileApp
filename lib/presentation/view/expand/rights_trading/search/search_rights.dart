// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nvs_trading/data/model/get_account_detail.dart';
import 'package:nvs_trading/data/services/getAccountDetail.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getBusDate.dart';
import 'package:nvs_trading/data/services/getRightBalance.dart';
import 'package:nvs_trading/presentation/view/expand/rights_trading/search/detail_rights.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchRight extends StatefulWidget {
  const SearchRight({super.key});

  @override
  State<SearchRight> createState() => _SearchRightState();
}

class _SearchRightState extends State<SearchRight> {
  FocusNode _focusNode = FocusNode();
  String custodycd = HydratedBloc.storage.read('custodycd');

  String token = HydratedBloc.storage.read('token');

  var selectedAcctno = HydratedBloc.storage.read('acctno');
  // List<ValueItem<String>> selectedOptionsRight = [];
  // List<ValueItem<String>> listOptionsRight = [];
  // final MultiSelectController<String> selectRight = MultiSelectController();

  // final MultiSelectController<String> selectStatus = MultiSelectController();
  // List<ValueItem<String>> selectedOptionsStatus = [];
  // List<ValueItem<String>> listOptionsStatus = [];
  String busDate = "";

  TextEditingController symbol = TextEditingController();
  String status = "";
  String catype = "";

  // List<GetAccountDetailModel> accountDetail = [];
  // List<dynamic> listRight = [];
  // List<dynamic> listStatus = [];
  List<dynamic> listRightBalance = [];

  //Search
  List<SearchFieldListItem> listSymbols = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    fetchBusDate();
    // fetchAccount();
    // fetchRight();
    // fetchStatus();
    fetchRightBalance();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void fetchBusDate() async {
    try {
      final response = await GetBusDate(HydratedBloc.storage.read('token'));
      if (response.statusCode == 200) {
        setState(() {
          busDate = response.data['dateserver'];
        });
        print(busDate);
      }
    } catch (e) {
      print(e);
    }
  }

  // void fetchAccount() async {
  //   try {
  //     final response = await GetAccountDetail(custodycd);
  //     if (response.isNotEmpty) {
  //       setState(() {
  //         accountDetail = response;
  //       });
  //     } else {
  //       print("Lỗi lấy thông tin account!!!");
  //     }
  //   } catch (e) {
  //     Future.error(e);
  //   }
  // }

  // void fetchRight() async {
  //   try {
  //     final response = await GetAllCode("API", "CATYPE", token);
  //     if (response.isNotEmpty) {
  //       setState(() {
  //         listRight = response;
  //       });
  //       for (var i in listRight) {
  //         listOptionsRight.add(
  //           ValueItem(
  //             label: i['vN_CDCONTENT'],
  //             value: i['cdval'],
  //           ),
  //         );
  //       }
  //       // print(listOptions);
  //     } else {
  //       print("Lỗi lấy quyền!!");
  //     }
  //   } catch (e) {
  //     Future.error(e);
  //   }
  // }

  // void fetchStatus() async {
  //   try {
  //     final response = await GetAllCode("API", "CASTATUS", token);
  //     if (response.isNotEmpty) {
  //       setState(() {
  //         listStatus = response;
  //       });
  //       for (var i in listStatus) {
  //         listOptionsStatus.add(
  //           ValueItem(
  //             label: i['vN_CDCONTENT'],
  //             value: i['cdval'],
  //           ),
  //         );
  //       }
  //     } else {
  //       print("Lỗi lấy trạng thái!!!");
  //     }
  //   } catch (e) {
  //     Future.error(e);
  //   }
  // }

  void fetchRightBalance() async {
    try {
      final response = await getRightBalanceInfo(
        1,
        50,
        custodycd,
        selectedAcctno,
        symbol.text.isEmpty ? "ALL" : symbol.text,
        status.isEmpty ? 'ALL' : status,
        catype.isEmpty ? 'ALL' : catype,
      );

      setState(() {
        listRightBalance = response;
      });
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: local.lookUpPermission('lookUpPer')),
      body: listRightBalance.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: customTextStyleBody(
                text: "No data",
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BlocBuilder<MarketInfoCubit, MarketInfoState>(
                  //     builder: (context, state) {
                  //   final marketInfo = state.marketInfo;

                  //   List<String> listSyms = [];
                  //   List<String> listNameBank = [];
                  //   for (var entry in marketInfo.entries) {
                  //     String symbol = entry.value.symbol ?? "";
                  //     listSyms.add(symbol);
                  //     String nameBank = entry.value.symbolName ?? "";
                  //     listNameBank.add(nameBank);
                  //   }
                  //   if (listSymbols.isEmpty) {
                  //     listSymbols = List.generate(listSyms.length, (index) {
                  //       String symbol = listSyms[index];
                  //       String nameBank = listNameBank[index];

                  //       return SearchFieldListItem(symbol,
                  //           child: Text("$symbol - $nameBank"));
                  //     });
                  //     listSymbols
                  //         .sort((a, b) => a.searchKey.compareTo(b.searchKey));
                  //   }
                  //   return Container(
                  //     height: 36,
                  //     color: Theme.of(context).colorScheme.primary,
                  //     child: SearchField(
                  //       hint: local.lookUpPermission('bank'),
                  //       controller: symbol,
                  //       suggestions: listSymbols,
                  //       focusNode: _focusNode,
                  //       searchInputDecoration: InputDecoration(
                  //         prefixIcon: Padding(
                  //           padding: const EdgeInsets.only(top: 4, bottom: 4),
                  //           child:
                  //               SvgPicture.asset('assets/icons/ic_search.svg'),
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide.none,
                  //           borderRadius: BorderRadius.circular(4),
                  //         ),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide.none,
                  //           borderRadius: BorderRadius.circular(4),
                  //         ),
                  //         contentPadding: const EdgeInsets.only(left: 8),
                  //       ),
                  //       itemHeight: 50,
                  //       maxSuggestionsInViewPort: 2,
                  //       searchStyle: TextStyle(
                  //         fontSize: 16,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //       suggestionStyle: TextStyle(
                  //         fontSize: 16,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //       onSubmit: (p0) {
                  //         setState(() {
                  //           symbol.text = p0.toUpperCase();
                  //         });
                  //         fetchRightBalance();
                  //       },
                  //       onSearchTextChanged: (p0) {
                  //         setState(() {
                  //           symbol.text = p0.toUpperCase();
                  //         });

                  //         return listSymbols
                  //             .where((element) =>
                  //                 element.searchKey.contains(symbol.text))
                  //             .toList();
                  //       },
                  //       onSuggestionTap: (p0) {
                  //         _focusNode.unfocus();
                  //         setState(() {
                  //           symbol.text = p0.searchKey;
                  //         });
                  //         fetchRightBalance();
                  //       },
                  //     ),
                  //   );
                  // }),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       margin: const EdgeInsets.symmetric(vertical: 12),
                  //       width: 180.5,
                  //       height: 32,
                  //       child: MultiSelectDropDown(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 4, horizontal: 6),
                  //         controller: selectRight,
                  //         hint: local.lookUpPermission('TOR'),
                  //         hintPadding: const EdgeInsets.only(left: 4),
                  //         inputDecoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(4),
                  //           color: Theme.of(context).colorScheme.primary,
                  //         ),
                  //         onOptionSelected: (options) {
                  //           selectedOptionsRight = options;
                  //           setState(() {
                  //             catype = selectedOptionsRight
                  //                 .map((e) => e.value)
                  //                 .join(',');
                  //           });
                  //           fetchRightBalance();
                  //         },
                  //         options: listOptionsRight,
                  //         maxItems: 4,
                  //         chipConfig: ChipConfig(
                  //           wrapType: WrapType.scroll,
                  //           backgroundColor:
                  //               Theme.of(context).colorScheme.primary,
                  //           labelStyle: const TextStyle(fontSize: 10),
                  //           deleteIconColor: Theme.of(context).hintColor,
                  //           radius: 8,
                  //           padding: const EdgeInsets.only(
                  //             left: 4,
                  //             right: 2,
                  //             bottom: 12,
                  //           ),
                  //         ),
                  //         suffixIcon: Icon(
                  //           Icons.keyboard_arrow_down,
                  //           color: Theme.of(context).hintColor,
                  //           size: 20,
                  //         ),
                  //         dropdownBackgroundColor:
                  //             Theme.of(context).colorScheme.primary,
                  //         optionTextStyle: const TextStyle(
                  //           fontSize: 10,
                  //         ),
                  //         onOptionRemoved: (index, option) {},
                  //         optionBuilder: (context, valueItem, isSelected) {
                  //           return ListTile(
                  //             title: customTextStyleBody(
                  //               text: valueItem.label,
                  //               size: 10,
                  //               color: Theme.of(context).primaryColor,
                  //               txalign: TextAlign.start,
                  //             ),
                  //             leading: isSelected
                  //                 ? Icon(
                  //                     Icons.check_box,
                  //                     color: Theme.of(context)
                  //                         .secondaryHeaderColor,
                  //                   )
                  //                 : const Icon(
                  //                     Icons.check_box_outline_blank,
                  //                   ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.symmetric(vertical: 12),
                  //       width: 161.5,
                  //       height: 32,
                  //       child: MultiSelectDropDown(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 4, horizontal: 6),
                  //         controller: selectStatus,
                  //         hint: local.lookUpPermission('status'),
                  //         hintPadding: const EdgeInsets.only(left: 4),
                  //         inputDecoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(4),
                  //           color: Theme.of(context).colorScheme.primary,
                  //         ),
                  //         onOptionSelected: (options) {
                  //           selectedOptionsStatus = options;
                  //           setState(() {
                  //             status = selectedOptionsStatus
                  //                 .map((e) => e.value)
                  //                 .join(',');
                  //           });
                  //           fetchRightBalance();
                  //         },
                  //         suffixIcon: Icon(
                  //           Icons.keyboard_arrow_down,
                  //           color: Theme.of(context).hintColor,
                  //           size: 20,
                  //         ),
                  //         options: listOptionsStatus,
                  //         chipConfig: ChipConfig(
                  //           wrapType: WrapType.scroll,
                  //           backgroundColor:
                  //               Theme.of(context).colorScheme.primary,
                  //           labelStyle: const TextStyle(fontSize: 10),
                  //           deleteIconColor: Theme.of(context).hintColor,
                  //           radius: 8,
                  //           padding: const EdgeInsets.only(
                  //             left: 4,
                  //             right: 2,
                  //             bottom: 12,
                  //           ),
                  //         ),
                  //         dropdownBackgroundColor:
                  //             Theme.of(context).colorScheme.primary,
                  //         optionTextStyle: const TextStyle(
                  //           fontSize: 10,
                  //         ),
                  //         onOptionRemoved: (index, option) {},
                  //         optionBuilder: (context, valueItem, isSelected) {
                  //           return ListTile(
                  //             title: customTextStyleBody(
                  //               text: valueItem.label,
                  //               size: 10,
                  //               color: Theme.of(context).primaryColor,
                  //               txalign: TextAlign.start,
                  //             ),
                  //             leading: isSelected
                  //                 ? Icon(
                  //                     Icons.check_box,
                  //                     color: Theme.of(context)
                  //                         .secondaryHeaderColor,
                  //                   )
                  //                 : const Icon(
                  //                     Icons.check_box_outline_blank,
                  //                   ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: 180.5,
                  //       height: 36,
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(4),
                  //         color: Theme.of(context).colorScheme.primary,
                  //       ),
                  //       child: DropdownButton(
                  //         value: selectedAcctno,
                  //         items: [
                  //           for (var i in accountDetail)
                  //             DropdownMenuItem(
                  //               value: i.acctno,
                  //               child: customTextStyleBody(
                  //                 text: i.acctno,
                  //                 color: Theme.of(context).primaryColor,
                  //               ),
                  //             ),
                  //         ],
                  //         onChanged: (value) {
                  //           setState(() {
                  //             selectedAcctno = value!;
                  //           });
                  //           fetchRightBalance();
                  //         },
                  //         hint: customTextStyleBody(
                  //           text: "Tài khoản",
                  //           size: 10,
                  //           color: const Color(0xFF797F8A),
                  //         ),
                  //         isExpanded: true,
                  //         iconSize: 20,
                  //         iconEnabledColor: Theme.of(context).hintColor,
                  //         iconDisabledColor: Theme.of(context).hintColor,
                  //         icon: const Icon(Icons.keyboard_arrow_down),
                  //         underline: Container(),
                  //         isDense: true,
                  //       ),
                  //     ),
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.red,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(4),
                  //         ),
                  //         fixedSize: const Size(161, 36),
                  //       ),
                  //       onPressed: () {
                  //         setState(() {
                  //           symbol.clear();
                  //           selectRight.clearAllSelection();
                  //           selectStatus.clearAllSelection();
                  //         });
                  //       },
                  //       child: customTextStyleBody(
                  //         text: local.buttonForm('clearFilter'),
                  //         size: 14,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24, bottom: 16),
                  //   child: customTextStyleBody(
                  //     text: local.lookUpPermission('rightInfo'),
                  //     color: const Color(0xffe7ab21),
                  //   ),
                  // ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i in listRightBalance)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customTextStyleBody(
                                        text: i['symbol'],
                                        size: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 76,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              side: BorderSide(
                                                color: Theme.of(context)
                                                    .buttonTheme
                                                    .colorScheme!
                                                    .background,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailRights(
                                                  symbol: i['symbol'],
                                                  catype: i['catype_text'],
                                                  rate: i['rate'],
                                                  actiondate: i['actiondate'],
                                                  status: i['status'],
                                                  status_text: i['status_text'],
                                                  reportdate: i['reportdate'],
                                                  reportqtty: i['reportqtty'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: FittedBox(
                                            fit: BoxFit.none,
                                            child: customTextStyleBody(
                                              size: 12,
                                              text: local.lookUpPermission(
                                                  'seeDetail'),
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .background,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                width: 80,
                                                child: AutoSizeText(
                                                  local.lookUpPermission('TOR'),
                                                  maxLines: 2,
                                                  minFontSize: 1,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .color!,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: customTextStyleBody(
                                                  text: i['catype_text'],
                                                  fontWeight: FontWeight.w500,
                                                  txalign: TextAlign.start,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                width: 80,
                                                child: customTextStyleBody(
                                                  text: local.lookUpPermission(
                                                      'status'),
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .color!,
                                                  fontWeight: FontWeight.w400,
                                                  txalign: TextAlign.start,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 77.5,
                                                height: 18,
                                                child: customTextStyleBody(
                                                  text: i['status_text'],
                                                  color: i['status'] == 'C'
                                                      ? const Color(0xff4FD08A)
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  txalign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                width: 80,
                                                child: AutoSizeText(
                                                  local.lookUpPermission('ER'),
                                                  maxLines: 2,
                                                  minFontSize: 1,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .color!,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              SizedBox(
                                                width: 77.5,
                                                height: 18,
                                                child: customTextStyleBody(
                                                  text: i['rate'],
                                                  fontWeight: FontWeight.w500,
                                                  txalign: TextAlign.start,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: 80,
                                                child: AutoSizeText(
                                                  local.lookUpPermission('EED'),
                                                  maxLines: 2,
                                                  minFontSize: 1,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .color!,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              SizedBox(
                                                width: 77.5,
                                                height: 18,
                                                child: customTextStyleBody(
                                                  text: DateFormat('dd/MM/yyyy')
                                                      .format(
                                                    DateFormat(
                                                            'M/d/yyyy h:mm:ss a')
                                                        .parse(
                                                      i['actiondate'],
                                                    ),
                                                  ),
                                                  fontWeight: FontWeight.w500,
                                                  txalign: TextAlign.start,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
