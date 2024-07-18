import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/extensions/string_extensions.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/group_stock.dart';
import 'package:nvs_trading/data/model/market_info.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail.dart';
import 'package:nvs_trading/presentation/view/provider/changeAcctno.dart';
import 'package:nvs_trading/presentation/view/provider/dataIndustries.dart';
import 'package:nvs_trading/presentation/view/provider/datasegments.dart';
import 'package:nvs_trading/data/services/getStockInfo.dart';
import 'package:nvs_trading/data/services/listGroupStock.dart';
import 'package:nvs_trading/presentation/theme/color.dart';

import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';

import 'package:nvs_trading/presentation/widget/chooseAcctno.dart';
import 'package:nvs_trading/presentation/widget/highlight.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String custodycd = HydratedBloc.storage.read('custodycd');
  String acctno = "";
  String token = HydratedBloc.storage.read('token');

  int currentIndex = 0;
  int isSelect = 0;
  int isSelect2 = 3;

  TextEditingController bankName = TextEditingController();
  String searchBN = "";

  List<GroupStock> responseGS = [];
  List<dynamic> responseStockInfo = [];
  // nganh
  String nganh = "";

  FocusNode _focusNode = FocusNode();
  late FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    _focusNode = FocusNode();
    fToast = FToast();
    fToast.init(context);
    ////
    _focusNode.addListener(checkExpanded);
    super.initState();
    fetchGS();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final changeAcctno = Provider.of<ChangeAcctno>(context, listen: false);
      setState(() {
        acctno = changeAcctno.acctno;
      });
      fetchStockInfo();
    });
  }

  ////
  void checkExpanded() {
    setState(() {
      isExpanded = _focusNode.hasFocus;
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
      fetchStockInfo();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String danhmuc = "Danh mục";
  bool checkLanguageDanhmuc = false;
  List<SearchFieldListItem> filteredSuggestions = [];

  Future<void> fetchGS() async {
    try {
      final response = await listGroupStock();
      if (response.isNotEmpty) {
        responseGS = response;
        checkEditGroupStock.clear();
        for (var i = 0; i < responseGS.length; i++) {
          checkEditGroupStock.add(false);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchStockInfo() async {
    try {
      final response = await GetStockInfo(custodycd, acctno, token);
      if (response.isNotEmpty) {
        setState(() {
          responseStockInfo = response;
        });
      } else {
        print("Lỗi stockinfo");
      }
    } catch (e) {
      Future.error(e);
    }
  }

  List<bool> checkEditGroupStock = [];
  TextEditingController groupStock = TextEditingController();
  bool checkCreateGroupStock = false;
  TextEditingController gsCreate = TextEditingController();

  List<String> symbolAddStar = [];

  // animated for search
  bool isExpanded = false;

  // sx theo tang giam
  dynamic sxSymbol;
  dynamic sxmatchPrice;
  dynamic sxmatchVol;
  int choiceTypeChange = 0;

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;

    final industries =
        Provider.of<DataIndustriesProvider>(context).dataIndustries;

    List<String> nameIndustries = [];
    for (var i = 0; i < industries.length; i++) {
      nameIndustries.add(industries[i]['name']);
    }
    // var orientation = MediaQuery.of(context).orientation;
    // print(orientation);
    List<String> vn30Values = [];
    List<String> hnx30Values = [];
    final dataSegmentsProvider = Provider.of<DataSegmentsProvider>(context);
    final dataSegments = dataSegmentsProvider.dataSegments;
    if (dataSegments.containsKey('VN30')) {
      vn30Values = dataSegments['VN30'];
    }
    if (dataSegments.containsKey('HNX30')) {
      hnx30Values = dataSegments['HNX30'];
    }
    if (checkLanguageDanhmuc == false) {
      danhmuc = appLocal.homepageForm('watchlist');
      checkLanguageDanhmuc = true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leadingWidth: MediaQuery.of(context).size.width / 2,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 32,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = true;
                  });
                  //_focusNode.requestFocus();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 375),
                  width: isExpanded
                      ? MediaQuery.of(context).size.width * 0.8
                      : 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                        color: Theme.of(context).hintColor, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/ic_search.svg'),
                      if (isExpanded) ...[
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: BlocBuilder<MarketInfoCubit, MarketInfoState>(
                            builder: (context, state) {
                              final marketInfo = state.marketInfo;
                              List<String> listSymbols = [];
                              List<String> listNameBank = [];
                              for (var entry in marketInfo.entries) {
                                String symbol = entry.value.symbol ?? "";
                                listSymbols.add(symbol);
                                String nameBank = entry.value.symbolName ?? "";
                                listNameBank.add(nameBank);
                              }
                              if (filteredSuggestions.isEmpty) {
                                filteredSuggestions =
                                    List.generate(listSymbols.length, (index) {
                                  String symbol = listSymbols[index];
                                  String nameBank = listNameBank[index];
                                  return SearchFieldListItem(symbol,
                                      child: Text("$symbol - $nameBank"));
                                });
                                filteredSuggestions.sort((a, b) =>
                                    a.searchKey.compareTo(b.searchKey));
                              }
                              return SearchField(
                                focusNode: _focusNode,
                                controller: bankName,
                                hint: appLocal.hintSearch,
                                searchInputDecoration: const InputDecoration(
                                  // prefixIcon: Padding(
                                  //   padding:
                                  //       const EdgeInsets.only(top: 4, bottom: 4),
                                  //   child: SvgPicture.asset(
                                  //       'assets/icons/ic_search.svg'),
                                  // ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 8),
                                ),
                                itemHeight: 60,
                                maxSuggestionsInViewPort: 2,
                                searchStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                suggestionStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                                suggestions: filteredSuggestions,
                                onSuggestionTap: (p0) async {
                                  _focusNode.unfocus();
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    bankName.text = p0.searchKey;
                                  });
                                  if (isSelect2 == 1) {
                                    for (var i = 0;
                                        i < responseGS.length;
                                        i++) {
                                      if (danhmuc == responseGS[i].name) {
                                        final res = await addNewSymbol(
                                            responseGS[i].id, p0.searchKey);
                                        if (res == 1) {
                                          await fetchGS();
                                          setState(() {
                                            bankName.clear();
                                          });
                                        }
                                      }
                                    }
                                  } else {
                                    //print("STG : ${marketInfo[bankName.text]?.marketCode}");
                                    String typeSymbolSearch =
                                        marketInfo[bankName.text]?.marketCode ??
                                            "";
                                    if (typeSymbolSearch == "STO") {
                                      setState(() {
                                        isSelect2 = 4;
                                      });
                                    } else if (typeSymbolSearch == "STX") {
                                      setState(() {
                                        isSelect2 = 5;
                                      });
                                    } else {
                                      setState(() {
                                        isSelect2 = 6;
                                      });
                                    }
                                  }
                                },
                                onSearchTextChanged: (p0) {
                                  setState(() {
                                    bankName.text = p0.toUpperCase();
                                  });

                                  return filteredSuggestions
                                      .where((element) => element.searchKey
                                          .contains(bankName.text))
                                      .toList();
                                },
                                onSubmit: (p0) async {
                                  if (isSelect2 == 1) {
                                    bool isInSuggestions = filteredSuggestions
                                        .where((element) =>
                                            element.searchKey == p0)
                                        .isNotEmpty;
                                    if (isInSuggestions) {
                                      for (var i = 0;
                                          i < responseGS.length;
                                          i++) {
                                        if (danhmuc == responseGS[i].name) {
                                          final res = await addNewSymbol(
                                              responseGS[i].id, p0);
                                          if (res == 1) {
                                            await fetchGS();
                                            setState(() {
                                              bankName.clear();
                                            });
                                          }
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        bankName.clear();
                                      });
                                      fToast.showToast(
                                        gravity: ToastGravity.TOP,
                                        toastDuration:
                                            const Duration(seconds: 2),
                                        child: msgNotification(
                                          color: Colors.red,
                                          icon: Icons.error,
                                          text:
                                              "Không có mã chứng khoán phù hợp",
                                        ),
                                      );
                                    }
                                  } else {
                                    String typeSymbolSearch =
                                        marketInfo[bankName.text]?.marketCode ??
                                            "";
                                    if (typeSymbolSearch == "STO") {
                                      setState(() {
                                        isSelect2 = 4;
                                      });
                                    } else if (typeSymbolSearch == "STX") {
                                      setState(() {
                                        isSelect2 = 5;
                                      });
                                    } else if (typeSymbolSearch == "UPX") {
                                      setState(() {
                                        isSelect2 = 6;
                                      });
                                    } else {
                                      setState(() {
                                        bankName.clear();
                                      });
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const ChooseAcctno(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Image.asset('assets/icons/Combined Shape.png'),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          const MarketIndexItems(),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            padding: const EdgeInsets.only(left: 16, right: 16),
            color: Theme.of(context).colorScheme.primary,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  securityType(context, 0, appLocal.homepageForm('stock'), []),
                  securityType(
                      context,
                      1,
                      nganh == ""
                          ? appLocal.homepageForm('industry')
                          : "${appLocal.homepageForm('industry')} ($nganh)",
                      nameIndustries),
                  securityType(
                      context, 2, appLocal.homepageForm('waranties'), []),
                ],
              ),
            ),
          ),
          (isSelect == 0)
              ? Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        stockType(context, 0, appLocal.homepageForm('all')),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelect2 = 1;
                              modalBottomDanhmuc();
                            });
                          },
                          child: Container(
                            height: 25,
                            decoration: BoxDecoration(
                              color: (isSelect2 == 1)
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.only(left: 8, right: 6.5),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customTextStyleBody(
                                  text: danhmuc,
                                  size: 14,
                                  color: (isSelect2 == 1)
                                      ? Theme.of(context).secondaryHeaderColor
                                      : Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                  fontWeight: FontWeight.w400,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                  color: (isSelect2 == 1)
                                      ? Theme.of(context).secondaryHeaderColor
                                      : Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                ),
                              ],
                            ),
                          ),
                        ),
                        stockType(
                            context, 2, appLocal.homepageForm('equitySecure')),
                        stockType(context, 3, 'VN30'),
                        stockType(context, 7, 'HNX30'),
                        stockType(context, 4, 'HSX'),
                        stockType(context, 5, 'HNX'),
                        stockType(context, 6, 'UpCOM'),
                      ],
                    ),
                  ),
                )
              : Container(),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(0.5),
              1: FlexColumnWidth(1.25),
              2: FlexColumnWidth(1.25),
              3: FlexColumnWidth(1.25),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1.25),
            },
            border:
                TableBorder.all(color: Theme.of(context).colorScheme.tertiary),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  const TableCell(child: Text("")),
                  //sym
                  TableCell(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          sxmatchPrice = null;
                          sxmatchVol = null;

                          if (sxSymbol == null || sxSymbol == false) {
                            sxSymbol = true;
                          } else {
                            sxSymbol = false;
                          }
                        });
                        print(sxSymbol);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customTextStyleBody(
                              text: appLocal.homepageForm('symbol'),
                              color: Theme.of(context).primaryColor,
                            ),
                            sxSymbol == null
                                ? Container()
                                : Icon(
                                    sxSymbol == true
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_drop_up,
                                    size: 16,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //match
                  TableCell(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          sxSymbol = null;
                          sxmatchVol = null;
                          if (sxmatchPrice == null || sxmatchPrice == false) {
                            sxmatchPrice = true;
                          } else {
                            sxmatchPrice = false;
                          }
                        });
                        print(sxmatchPrice);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customTextStyleBody(
                            text: appLocal.homepageForm('matchPrice'),
                            color: Theme.of(context).primaryColor,
                            txalign: TextAlign.center,
                          ),
                          sxmatchPrice == null
                              ? Container()
                              : Icon(
                                  sxmatchPrice == true
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_drop_up,
                                  size: 16,
                                ),
                        ],
                      ),
                    ),
                  ),
                  //vol
                  TableCell(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          sxSymbol = null;
                          sxmatchPrice = null;
                          if (sxmatchVol == null || sxmatchVol == false) {
                            sxmatchVol = true;
                          } else {
                            sxmatchVol = false;
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customTextStyleBody(
                            text: appLocal.homepageForm('matchvol'),
                            color: Theme.of(context).primaryColor,
                            txalign: TextAlign.center,
                          ),
                          sxmatchVol == null
                              ? Container()
                              : Icon(
                                  sxmatchVol == true
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_drop_up,
                                  size: 16,
                                ),
                        ],
                      ),
                    ),
                  ),
                  //+/-
                  TableCell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (choiceTypeChange == 0) {
                                choiceTypeChange = 1;
                              } else {
                                choiceTypeChange = 0;
                              }
                            });
                          },
                          child: const Icon(
                            Icons.arrow_left,
                            size: 14,
                          ),
                        ),
                        customTextStyleBody(
                          text: "+/-",
                          color: Theme.of(context).primaryColor,
                          txalign: TextAlign.center,
                        ),
                        choiceTypeChange == 0
                            ? Container()
                            : customTextStyleBody(
                                text: "(%)",
                                color: Theme.of(context).primaryColor,
                                txalign: TextAlign.center,
                                size: 10,
                              ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (choiceTypeChange == 0) {
                                choiceTypeChange = 1;
                              } else {
                                choiceTypeChange = 0;
                              }
                            });
                          },
                          child: const Icon(
                            Icons.arrow_right,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //tong kl
                  TableCell(
                    child: customTextStyleBody(
                      text: appLocal.homepageForm('totalvol'),
                      color: Theme.of(context).primaryColor,
                      txalign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<MarketInfoCubit, MarketInfoState>(
              builder: (context, state) {
                final marketInfo = state.marketInfo;
                List<MapEntry<String, MarketInfo>> entries = [];
                List<MapEntry<String, MarketInfo>> entriesLast =
                    []; // tìm kiếm mã
                List<MapEntry<String, MarketInfo>> entriesVer2 = [];
                if (isSelect == 0) {
                  if (isSelect2 == 0) {
                    entries = marketInfo.entries.toList();
                    entriesVer2 = marketInfo.entries.toList();
                  } else if (isSelect2 == 1) {
                    for (var i in responseGS) {
                      if (danhmuc == i.name) {
                        for (var st in i.listStock) {
                          for (var entry in marketInfo.entries) {
                            if (entry.value.symbol == st) {
                              entries.add(entry);
                              entriesVer2.add(entry);
                            }
                          }
                        }
                      }
                    }
                  } else if (isSelect2 == 2) {
                    for (var i in responseStockInfo) {
                      for (var entry in marketInfo.entries) {
                        if (i['symbol'] == entry.value.symbol) {
                          entries.add(entry);
                          entriesVer2.add(entry);
                        }
                      }
                    }
                  } else if (isSelect2 == 3) {
                    for (var entry in marketInfo.entries) {
                      if (entry.value.securityType != "CW" &&
                          entry.value.securityType != "BO" &&
                          entry.value.marketCode == "STO" &&
                          vn30Values.contains(entry.value.symbol)) {
                        entries.add(entry);
                        entriesVer2.add(entry);
                      }
                    }
                  } else if (isSelect2 == 4) {
                    if (bankName.text.isEmpty) {
                      for (var entry in marketInfo.entries) {
                        if (entry.value.marketCode == "STO" &&
                            entry.value.securityType == "ST") {
                          entries.add(entry);
                          entriesVer2.add(entry);
                        }
                      }
                    } else {
                      for (var entry in marketInfo.entries) {
                        if (entry.value.marketCode == "STO" &&
                            entry.value.securityType == "ST" &&
                            entry.value.symbol == bankName.text) {
                          entries.add(entry);
                          entriesVer2.add(entry);
                        } else if (entry.value.marketCode == "STO" &&
                            entry.value.securityType == "ST" &&
                            entry.value.symbol != bankName.text) {
                          entriesLast.add(entry);
                          entriesVer2.add(entry);
                        }
                      }
                    }
                  } else if (isSelect2 == 5) {
                    if (bankName.text.isEmpty) {
                      for (var entry in marketInfo.entries) {
                        if (entry.value.marketCode == "STX" &&
                            entry.value.securityType == "ST") {
                          entries.add(entry);
                          entriesVer2.add(entry);
                        }
                      }
                    } else {
                      for (var entry in marketInfo.entries) {
                        if (entry.value.marketCode == "STX" &&
                            entry.value.securityType == "ST" &&
                            entry.value.symbol == bankName.text) {
                          entries.add(entry);
                          entriesVer2.add(entry);
                        } else if (entry.value.marketCode == "STX" &&
                            entry.value.securityType == "ST" &&
                            entry.value.symbol != bankName.text) {
                          entriesLast.add(entry);
                          entriesVer2.add(entry);
                        }
                      }
                    }
                  } else if (isSelect2 == 6) {
                    if (bankName.text.isEmpty) {
                      for (var entry in marketInfo.entries) {
                        if (entry.value.marketCode == "UPX" &&
                            entry.value.securityType == "ST") {
                          entries.add(entry);
                          entriesVer2.add(entry);
                        }
                      }
                    } else {
                      for (var entry in marketInfo.entries) {
                        if (entry.value.marketCode == "UPX" &&
                            entry.value.securityType == "ST" &&
                            entry.value.symbol == bankName.text) {
                          entries.add(entry);
                          entriesVer2.add(entry);
                        } else if (entry.value.marketCode == "UPX" &&
                            entry.value.securityType == "ST" &&
                            entry.value.symbol != bankName.text) {
                          entriesLast.add(entry);
                          entriesVer2.add(entry);
                        }
                      }
                    }
                  } else if (isSelect2 == 7) {
                    for (var entry in marketInfo.entries) {
                      if (entry.value.securityType != "CW" &&
                          entry.value.securityType != "BO" &&
                          entry.value.marketCode == "STX" &&
                          hnx30Values.contains(entry.value.symbol)) {
                        entries.add(entry);
                        entriesVer2.add(entry);
                      }
                    }
                  }
                } else if (isSelect == 1) {
                  for (var j = 0; j < industries.length; j++) {
                    if (industries[j]['name'] == nganh) {
                      List<dynamic> symbols = industries[j]['symbolList'];
                      //print("LL : $symbols");
                      for (var sym in symbols) {
                        for (var entry in marketInfo.entries) {
                          if (sym == entry.value.symbol) {
                            entries.add(entry);
                            entriesVer2.add(entry);
                          }
                        }
                      }
                    }
                  }
                } else if (isSelect == 2) {
                  for (var entry in marketInfo.entries) {
                    if (entry.value.securityType == "CW") {
                      entries.add(entry);
                      entriesVer2.add(entry);
                    }
                  }
                }

                if (bankName.text.isEmpty) {
                  entries.sort(
                      (a, b) => a.value.symbol!.compareTo(b.value.symbol!));

                  //sx ma ck
                  if (sxSymbol != null) {
                    if (!sxSymbol) {
                      entries.sort(
                          (a, b) => a.value.symbol!.compareTo(b.value.symbol!));
                    } else {
                      entries.sort(
                          (a, b) => b.value.symbol!.compareTo(a.value.symbol!));
                    }
                  }

                  //sx gia khop
                  if (sxmatchPrice != null) {
                    if (sxmatchPrice) {
                      entries.sort((a, b) =>
                          b.value.matchPrice!.compareTo(a.value.matchPrice!));
                    } else {
                      entries.sort((a, b) =>
                          a.value.matchPrice!.compareTo(b.value.matchPrice!));
                    }
                  }
                  // sx kl khop

                  if (sxmatchVol != null) {
                    if (sxmatchVol) {
                      entries.sort((a, b) =>
                          b.value.matchQtty!.compareTo(a.value.matchQtty!));
                    } else {
                      entries.sort((a, b) =>
                          a.value.matchQtty!.compareTo(b.value.matchQtty!));
                    }
                  }

                  if (symbolAddStar.isNotEmpty) {
                    entries.removeWhere((element) =>
                        symbolAddStar.contains(element.value.symbol));
                    for (var i in symbolAddStar) {
                      for (var entry in entriesVer2) {
                        if (i == entry.value.symbol) {
                          entries.insert(0, entry);
                        }
                      }
                    }
                  }
                } else {
                  if (isSelect2 == 3 || isSelect2 == 7) {
                    entries.sort(
                        (a, b) => a.value.symbol!.compareTo(b.value.symbol!));
                    if (symbolAddStar.isNotEmpty) {
                      entries.removeWhere((element) =>
                          symbolAddStar.contains(element.value.symbol));
                      for (var i in symbolAddStar) {
                        for (var entry in entriesVer2) {
                          if (i == entry.value.symbol) {
                            entries.insert(0, entry);
                          }
                        }
                      }
                    }
                  } else {
                    if (symbolAddStar.isNotEmpty) {
                      for (var i in symbolAddStar) {
                        for (var entry in entriesLast) {
                          if (i == entry.value.symbol) {
                            entries.insert(0, entry);
                          }
                        }
                      }
                      entriesLast.removeWhere((element) =>
                          symbolAddStar.contains(element.value.symbol));
                    }
                    entriesLast.sort(
                        (a, b) => a.value.symbol!.compareTo(b.value.symbol!));
                    entries.addAll(entriesLast);
                  }
                }

                final colors = Theme.of(context).primaryColor;
                final theme = Theme.of(context);
                return ListView(
                  children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(0.5),
                        1: FlexColumnWidth(1.25),
                        2: FlexColumnWidth(1.25),
                        3: FlexColumnWidth(1.25),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(1.25),
                      },
                      border: TableBorder.all(
                          color: Theme.of(context).colorScheme.tertiary),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        ...List.generate(entries.length, (index) {
                          final bool isEvenRow = index % 2 == 0;
                          final Color rowColor = isEvenRow
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.primary;
                          return TableRow(
                            decoration: BoxDecoration(
                              color: rowColor,
                            ),
                            children: [
                              //star
                              TableCell(
                                child: GestureDetector(
                                  onTap: () {
                                    if (!symbolAddStar.contains(
                                        entries[index].value.symbol)) {
                                      symbolAddStar.add(
                                          entries[index].value.symbol ?? "");
                                      print(symbolAddStar);
                                      var selectedEntry = entries[index];
                                      entries.removeAt(index);
                                      entries.insert(0, selectedEntry);
                                      setState(() {
                                        print(entries);
                                      });
                                    } else {
                                      symbolAddStar.remove(
                                          entries[index].value.symbol ?? "");
                                      setState(() {});
                                    }
                                  },
                                  child: Icon(
                                    (symbolAddStar.contains(
                                            entries[index].value.symbol))
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: (symbolAddStar.contains(
                                            entries[index].value.symbol))
                                        ? Colors.yellow
                                        : null,
                                    size: 20,
                                  ),
                                ),
                              ),
                              //symbol
                              TableCell(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => StockDetail(
                                          symbol:
                                              entries[index].value.symbol ?? "",
                                          market:
                                              entries[index].value.marketName ??
                                                  "",
                                          nameSymbol:
                                              entries[index].value.symbolName ??
                                                  "",
                                          isStar: symbolAddStar.contains(
                                            entries[index].value.symbol ?? "",
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        customTextStyleBody(
                                          text:
                                              entries[index].value.symbol ?? "",
                                          color: colorRealTime[entries[index]
                                                  .value
                                                  .matchPriceColor] ??
                                              colors,
                                        ),
                                        // (isSelect == 0 && isSelect2 == 1)
                                        //     ? GestureDetector(
                                        //         onTap: () async {
                                        //           final rs = await removeSymbol(
                                        //               responseGS[responseGS
                                        //                       .indexWhere(
                                        //                           (element) =>
                                        //                               element
                                        //                                   .name ==
                                        //                               danhmuc)]
                                        //                   .id,
                                        //               entries[index]
                                        //                   .value
                                        //                   .symbol!);
                                        //           if (rs == 1) {
                                        //             await fetchGS();
                                        //             setState(() {});
                                        //           }
                                        //         },
                                        //         child: const Icon(
                                        //           Icons.close,
                                        //           color: Colors.red,
                                        //           size: 16,
                                        //         ),
                                        //       )
                                        //     : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //gia khop
                              TableCell(
                                child: HighLight(
                                  width:
                                      MediaQuery.of(context).size.width / 5.5,
                                  height: 28,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 8),
                                  symbol: entries[index].value.symbol,
                                  textStyle:
                                      theme.textTheme.bodyMedium?.copyWith(
                                    color: colorRealTime[
                                        entries[index].value.matchPriceColor],
                                  ),
                                  value: "${entries[index].value.matchPrice}"
                                          .isValidNumber
                                      ? double.tryParse(entries[index]
                                          .value
                                          .matchPrice
                                          .toString())
                                      : null,
                                  type: HighLightType.PRICE,
                                  child: Text(
                                    (entries[index].value.matchPrice == null)
                                        ? ""
                                        : entries[index]
                                            .value
                                            .matchPrice!
                                            .toStringAsFixed(2),
                                  ),
                                ),
                              ),
                              //kl khop
                              TableCell(
                                child: HighLight(
                                  width:
                                      MediaQuery.of(context).size.width / 5.5,
                                  height: 28,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 8),
                                  symbol: entries[index].value.symbol,
                                  textStyle:
                                      theme.textTheme.bodyMedium?.copyWith(
                                    color: colorRealTime[
                                        entries[index].value.matchQttyColor],
                                  ),
                                  value: "${entries[index].value.matchQtty}"
                                          .isValidNumber
                                      ? double.tryParse(
                                          entries[index]
                                              .value
                                              .matchQtty
                                              .toString(),
                                        )
                                      : null,
                                  type: HighLightType.PRICE,
                                  child: Text(
                                    (entries[index].value.matchQtty == null)
                                        ? ""
                                        : Utils().formatString(
                                            (entries[index].value.matchQtty! /
                                                    10)
                                                .toStringAsFixed(0),
                                          ),
                                  ),
                                ),
                              ),

                              //+/- va +/- %

                              choiceTypeChange == 0
                                  ? TableCell(
                                      child: HighLight(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5.5,
                                        height: 28,
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        symbol: entries[index].value.symbol,
                                        textStyle: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: colorRealTime[entries[index]
                                              .value
                                              .changePriceColor],
                                        ),
                                        value:
                                            "${entries[index].value.changePrice}"
                                                    .isValidNumber
                                                ? double.tryParse(entries[index]
                                                    .value
                                                    .changePrice
                                                    .toString())
                                                : null,
                                        type: HighLightType.PRICE,
                                        child: Text(
                                          (entries[index].value.changePrice ==
                                                  null)
                                              ? ""
                                              : entries[index]
                                                  .value
                                                  .changePrice!
                                                  .toStringAsFixed(2),
                                        ),
                                      ),
                                    )
                                  : TableCell(
                                      child: HighLight(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5.5,
                                        height: 28,
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        symbol: entries[index].value.symbol,
                                        textStyle: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: colorRealTime[entries[index]
                                              .value
                                              .pctChangePriceColor],
                                        ),
                                        value:
                                            "${entries[index].value.pctChangePrice}"
                                                    .isValidNumber
                                                ? double.tryParse(entries[index]
                                                    .value
                                                    .pctChangePrice
                                                    .toString())
                                                : null,
                                        type: HighLightType.PRICE,
                                        child: Text(
                                          (entries[index]
                                                      .value
                                                      .pctChangePrice ==
                                                  null)
                                              ? ""
                                              : "${entries[index].value.pctChangePrice!.toStringAsFixed(2)}%",
                                        ),
                                      ),
                                    ),
                              //tong KL
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 6),
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      customTextStyleBody(
                                        text: (entries[index]
                                                    .value
                                                    .totalTradedQttyNM ==
                                                null)
                                            ? ""
                                            : Utils().formatNumber(
                                                entries[index]
                                                    .value
                                                    .totalTradedQttyNM!
                                                    .toInt()),
                                        size: 12,
                                        color: colors,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      (isSelect == 0 && isSelect2 == 1)
                                          ? GestureDetector(
                                              onTap: () async {
                                                final rs = await removeSymbol(
                                                    responseGS[responseGS
                                                            .indexWhere(
                                                                (element) =>
                                                                    element
                                                                        .name ==
                                                                    danhmuc)]
                                                        .id,
                                                    entries[index]
                                                        .value
                                                        .symbol!);
                                                if (rs == 1) {
                                                  await fetchGS();
                                                  setState(() {});
                                                }
                                              },
                                              child: Transform.rotate(
                                                angle: pi / 4,
                                                child: const Icon(
                                                  Icons.add_circle,
                                                  size: 12,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector securityType(BuildContext context, int number,
      String securText, List<String>? nameIndustries) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelect = number;
        });
        if (isSelect == 1) {
          modalBottomIndustries(nameIndustries!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: (isSelect != number)
                ? BorderSide.none
                : BorderSide(
                    color: Theme.of(context).secondaryHeaderColor,
                    width: 3,
                  ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: customTextStyleBody(
          text: securText,
          fontWeight: FontWeight.w500,
          size: 16,
          color: (isSelect != number)
              ? Theme.of(context).textTheme.titleSmall!.color!
              : Theme.of(context).secondaryHeaderColor,
        ),
      ),
    );
  }

  GestureDetector stockType(BuildContext context, int number, String textType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelect2 = number;
        });
      },
      child: Container(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: (isSelect2 == number)
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: customTextStyleBody(
          text: textType,
          color: (isSelect2 == number)
              ? Theme.of(context).secondaryHeaderColor
              : Theme.of(context).textTheme.titleSmall!.color!,
          size: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  void modalBottomDanhmuc() {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.primary,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        var appLocal = AppLocalizations.of(context)!;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateModal) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Adjust the bottom padding to avoid keyboard overlap
            ),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 3.5,
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 17),
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          customTextStyleBody(
                            text: appLocal.homepageForm('watchlist'),
                            size: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          GestureDetector(
                            onTap: () {
                              checkCreateGroupStock = false;
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.close,
                              size: 24,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .color!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(context).hintColor,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 16, right: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var i = 0; i < responseGS.length; i++)
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          danhmuc = responseGS[i].name;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: SizedBox(
                                        height: 56,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            checkEditGroupStock[i]
                                                ? SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            120,
                                                    height: 32,
                                                    child: TextField(
                                                      cursorColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      controller: groupStock,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8,
                                                                left: 6),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor,
                                                          ),
                                                        ),
                                                      ),
                                                      onSubmitted:
                                                          (value) async {
                                                        final rs =
                                                            await editGroupStock(
                                                                responseGS[i]
                                                                    .id,
                                                                value);
                                                        print("RS: $rs");
                                                        if (rs == 1) {
                                                          await fetchGS();
                                                          setStateModal(() {
                                                            checkEditGroupStock[
                                                                i] = false;
                                                            groupStock.clear();
                                                          });
                                                        } else {
                                                          print("Cant change");
                                                        }
                                                      },
                                                    ),
                                                  )
                                                : customTextStyleBody(
                                                    text: responseGS[i].name,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                            SizedBox(
                                              width: 50,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setStateModal(() {
                                                        checkEditGroupStock[i] =
                                                            !checkEditGroupStock[
                                                                i];
                                                        for (var j = 0;
                                                            j <
                                                                responseGS
                                                                    .length;
                                                            j++) {
                                                          if (j != i) {
                                                            checkEditGroupStock[
                                                                j] = false;
                                                          }
                                                        }
                                                        groupStock.text =
                                                            responseGS[i].name;
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor,
                                                      size: 16,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final rs =
                                                          await deleteGroupStock(
                                                              responseGS[i].id);
                                                      print("object: $rs");
                                                      if (rs == 1) {
                                                        await fetchGS();
                                                        setStateModal(() {});
                                                      } else {
                                                        print("Cant delete");
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 56,
                      child: GestureDetector(
                        onTap: () {
                          setStateModal(() {
                            checkCreateGroupStock = !checkCreateGroupStock;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final res =
                                    await createGroupStock(gsCreate.text);

                                if (res == 1) {
                                  await fetchGS();
                                  setStateModal(() {
                                    gsCreate.clear();
                                    checkCreateGroupStock = false;
                                  });
                                } else {
                                  print(res);
                                }
                              },
                              child: Icon(
                                Icons.add_circle_outline,
                                size: 20,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            checkCreateGroupStock
                                ? SizedBox(
                                    width: 200,
                                    height: 32,
                                    child: TextField(
                                      controller: gsCreate,
                                      cursorColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            left: 6, bottom: 8),
                                      ),
                                    ),
                                  )
                                : customTextStyleBody(
                                    text: appLocal.homepageForm('addnewWL'),
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void modalBottomIndustries(List<String> nameIndustries) {
    var appLocal = AppLocalizations.of(context)!;
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.primary,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Container(
              height: MediaQuery.of(context).size.height / 3.5,
              padding: const EdgeInsets.only(bottom: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 17),
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          customTextStyleBody(
                            text: appLocal.homepageForm('industry'),
                            size: 18,
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.w500,
                          ),
                          GestureDetector(
                            onTap: () {
                              checkCreateGroupStock = false;
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.close,
                              size: 24,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .color!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(context).hintColor,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: [
                          for (var i = 0; i < nameIndustries.length; i++)
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      nganh = nameIndustries[i];
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: SizedBox(
                                    height: 36,
                                    child: Center(
                                      child: customTextStyleBody(
                                        text: nameIndustries[i],
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: Theme.of(context).hintColor,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

final marketIndex = ['VNINDEX', 'VN30', 'VNXALL', 'HNXINDEX', 'HNXUPCOMINDEX'];

final marketIndexName = {
  'VNINDEX': 'VNINDEX',
  'VN30': 'VN30',
  'VNXALL': 'VNXALL',
  'HNXINDEX': 'HNXINDEX',
  // 'HNX30': 'HNX-30',
  'HNXUPCOMINDEX': 'HNXUPCOMINDEX'
};

class MarketIndexItems extends StatelessWidget {
  const MarketIndexItems({super.key});

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, right: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...marketIndex.map(
              (index) => BlocBuilder<MarketInfoCubit, MarketInfoState>(
                buildWhen: (previous, current) =>
                    previous.marketIndex[index] != current.marketIndex[index],
                builder: (context, state) {
                  final marketIndex = state.marketIndex[index];
                  final colors = NvsColor.of(context);
                  final theme = Theme.of(context);

                  return InkWell(
                    onTap: () {},
                    child: Container(
                      height: 62,
                      width: 192,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customTextStyleBody(
                                text: marketIndexName[index] ?? '',
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: HighLight(
                                  symbol: index,
                                  textStyle:
                                      theme.textTheme.bodyLarge!.copyWith(
                                    color: colorRealTime[
                                            marketIndex?.currentIndexColor] ??
                                        colors.text,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  value: "${marketIndex?.currentIndex}"
                                          .isValidNumber
                                      ? double.tryParse(
                                          marketIndex?.currentIndex ?? "0")
                                      : null,
                                  type: HighLightType.PRICE,
                                  child:
                                      Text('${marketIndex?.currentIndex ?? 0}'),
                                ),
                              ),
                            ],
                          ),
                          if (marketIndex?.changeIndex != "null") ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customTextStyleBody(
                                  text:
                                      "${Utils().formatBillion(marketIndex?.totalTradedValue ?? "0")} ${appLocal.homepageForm('bill')}",
                                  color: theme.textTheme.titleSmall!.color!,
                                  fontWeight: FontWeight.w400,
                                  size: 12,
                                ),
                                Row(
                                  children: [
                                    HighLight(
                                      symbol: index,
                                      textStyle:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: colorRealTime[
                                            marketIndex?.changeIndexColor],
                                      ),
                                      value: "${marketIndex?.changeIndex}"
                                              .isValidNumber
                                          ? double.tryParse(
                                              marketIndex?.changeIndex ?? '0')
                                          : null,
                                      type: HighLightType.PRICE,
                                      child: Text(
                                          "${marketIndex?.changeIndex ?? 0}"),
                                    ),
                                    HighLight(
                                      symbol: index,
                                      textStyle:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: colorRealTime[
                                            marketIndex?.changeIndexColor],
                                      ),
                                      value: "${marketIndex?.pctChangeIndex}"
                                              .isValidNumber
                                          ? double.tryParse(
                                              marketIndex?.pctChangeIndex ??
                                                  "0")
                                          : null,
                                      type: HighLightType.PRICE,
                                      child: Text(
                                        ' (${marketIndex?.pctChangeIndex ?? 0}%)',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]
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
