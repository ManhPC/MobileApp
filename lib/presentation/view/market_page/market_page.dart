// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/market_info.dart';
import 'package:nvs_trading/data/services/getStockInfo.dart';
import 'package:nvs_trading/presentation/theme/color.dart';
import 'package:nvs_trading/presentation/view/bottom_bar/bottom_bar.dart';
import 'package:nvs_trading/presentation/view/homepage/homepage.dart';
import 'package:nvs_trading/presentation/view/provider/changeAcctno.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/chooseAcctno.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  String custodycd = HydratedBloc.storage.read('custodycd');
  String token = HydratedBloc.storage.read('token');
  //acctno
  String acctno = "";
  TextEditingController bankName = TextEditingController();
  List<SearchFieldListItem> filteredSuggestions = [];
  FocusNode _focusNode = FocusNode();

  List<String> listMarket = [
    'HSX',
    'HNX',
    'UpCOM',
  ];

  // top KL
  int chooseTimeKL = 0;
  dynamic marketKL = "HSX";

  // top tang giam
  int chooseTimeTangGiam = 0;
  dynamic marketTangGiam = "HSX";
  int chooseTypeTG = 0;

  //ds chung khoan so huu
  List<dynamic> responseStockInfo = [];

  @override
  void initState() {
    // TODO: implement initState
    _focusNode = FocusNode();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final changeAcctno = Provider.of<ChangeAcctno>(context, listen: false);
      acctno = changeAcctno.acctno;
      fetchStockInfo();
    });
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final changeAcctno = Provider.of<ChangeAcctno>(context);
    if (acctno != changeAcctno.acctno) {
      acctno = changeAcctno.acctno;
      fetchStockInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leadingWidth: MediaQuery.of(context).size.width / 2,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: SizedBox(
              height: 32,
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
                    filteredSuggestions
                        .sort((a, b) => a.searchKey.compareTo(b.searchKey));
                  }
                  return SearchField(
                    focusNode: _focusNode,
                    controller: bankName,
                    hint: "Search",
                    searchInputDecoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SvgPicture.asset('assets/icons/ic_search.svg'),
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
                    suggestions: filteredSuggestions,
                    onSuggestionTap: (p0) async {
                      _focusNode.unfocus();
                      FocusScope.of(context).unfocus();
                      setState(() {
                        bankName.text = p0.searchKey;
                      });
                    },
                    onSubmit: (p0) async {
                      setState(() {
                        bankName.text = p0;
                      });
                    },
                  );
                },
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MarketIndexItems(),
            BlocBuilder<MarketInfoCubit, MarketInfoState>(
                builder: (context, state) {
              final marketInfo = state.marketInfo;
              //danh sách các mã theo sàn
              List<MapEntry<String, MarketInfo>> entriesHSX = [];
              List<MapEntry<String, MarketInfo>> entriesHNX = [];
              List<MapEntry<String, MarketInfo>> entriesUPC = [];
              for (var i in marketInfo.entries) {
                if (i.value.marketCode == "STO") {
                  entriesHSX.add(i);
                } else if (i.value.marketCode == "STX") {
                  entriesHNX.add(i);
                } else if (i.value.marketCode == "UPX") {
                  entriesUPC.add(i);
                }
              }

              //top khối lượng
              List<MapEntry<String, MarketInfo>> top5entriesHSX = [];
              List<MapEntry<String, MarketInfo>> top5entriesHNX = [];
              List<MapEntry<String, MarketInfo>> top5entriesUPC = [];

              entriesHSX.sort((a, b) => (b.value.totalTradedQttyNM ?? 0)
                  .compareTo(a.value.totalTradedQttyNM ?? 0));
              top5entriesHSX = entriesHSX.take(5).toList();
              entriesHNX.sort((a, b) => (b.value.totalTradedQttyNM ?? 0)
                  .compareTo(a.value.totalTradedQttyNM ?? 0));
              top5entriesHNX = entriesHNX.take(5).toList();
              entriesUPC.sort((a, b) => (b.value.totalTradedQttyNM ?? 0)
                  .compareTo(a.value.totalTradedQttyNM ?? 0));
              top5entriesUPC = entriesUPC.take(5).toList();

              //top tăng giá
              List<MapEntry<String, MarketInfo>> top5entriesTangGiaHSX = [];
              List<MapEntry<String, MarketInfo>> top5entriesTangGiaHNX = [];
              List<MapEntry<String, MarketInfo>> top5entriesTangGiaUPC = [];

              entriesHSX.sort((a, b) => (b.value.changePrice ?? 0)
                  .compareTo(a.value.changePrice ?? 0));
              top5entriesTangGiaHSX = entriesHSX.take(5).toList();

              entriesHNX.sort((a, b) => (b.value.changePrice ?? 0)
                  .compareTo(a.value.changePrice ?? 0));
              top5entriesTangGiaHNX = entriesHNX.take(5).toList();

              entriesUPC.sort((a, b) => (b.value.changePrice ?? 0)
                  .compareTo(a.value.changePrice ?? 0));
              top5entriesTangGiaUPC = entriesUPC.take(5).toList();
              //top giảm giá
              List<MapEntry<String, MarketInfo>> top5entriesGiamGiaHSX = [];
              List<MapEntry<String, MarketInfo>> top5entriesGiamGiaHNX = [];
              List<MapEntry<String, MarketInfo>> top5entriesGiamGiaUPC = [];

              entriesHSX.sort((a, b) => (a.value.changePrice ?? 0)
                  .compareTo(b.value.changePrice ?? 0));
              top5entriesGiamGiaHSX = entriesHSX.take(5).toList();

              entriesHNX.sort((a, b) => (a.value.changePrice ?? 0)
                  .compareTo(b.value.changePrice ?? 0));
              top5entriesGiamGiaHNX = entriesHNX.take(5).toList();

              entriesUPC.sort((a, b) => (a.value.changePrice ?? 0)
                  .compareTo(b.value.changePrice ?? 0));
              top5entriesGiamGiaUPC = entriesUPC.take(5).toList();

              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 200,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTextStyleBody(
                              text: "Top khối lượng",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            customTextStyleBody(
                              text: "Xem thêm",
                              size: 12,
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 32) *
                                        3 /
                                        4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chooseTimeKL = 0;
                                        });
                                      },
                                      child: chooseTimeKLWidget(
                                        chooseTimeKL: chooseTimeKL,
                                        chosedTime: 0,
                                        text: "Hôm nay",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chooseTimeKL = 1;
                                        });
                                      },
                                      child: chooseTimeKLWidget(
                                        chooseTimeKL: chooseTimeKL,
                                        chosedTime: 1,
                                        text: "1 tuần",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chooseTimeKL = 2;
                                        });
                                      },
                                      child: chooseTimeKLWidget(
                                        chooseTimeKL: chooseTimeKL,
                                        chosedTime: 2,
                                        text: "1 tháng",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chooseTimeKL = 3;
                                        });
                                      },
                                      child: chooseTimeKLWidget(
                                        chooseTimeKL: chooseTimeKL,
                                        chosedTime: 3,
                                        text: "3 tháng",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width:
                                    (MediaQuery.of(context).size.width - 32) *
                                        1 /
                                        4.3,
                                height: 18,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    value: marketKL,
                                    iconStyleData: IconStyleData(
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      iconSize: 14,
                                      iconEnabledColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        marketKL = value;
                                      });
                                    },
                                    items: [
                                      for (var i in listMarket)
                                        DropdownMenuItem(
                                          value: i,
                                          child: customTextStyleBody(
                                            text: i,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 28,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 62,
                                      child: customTextStyleBody(
                                        text: "Mã CK",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: customTextStyleBody(
                                        text: "Giá",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.end,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 65,
                                      child: customTextStyleBody(
                                        text: "+/-",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.end,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: customTextStyleBody(
                                        text: "+/- (%)",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.end,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 92,
                                      child: customTextStyleBody(
                                        text: "Tổng KL",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              for (var i in (marketKL == "HSX")
                                  ? top5entriesHSX
                                  : (marketKL == "HNX")
                                      ? top5entriesHNX
                                      : top5entriesUPC)
                                SizedBox(
                                  height: 22,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 62,
                                        child: customTextStyleBody(
                                          text: i.value.symbol ?? "",
                                          color: colorRealTime[
                                                  i.value.matchPriceColor] ??
                                              Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                          txalign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        child: customTextStyleBody(
                                          text: "${i.value.matchPrice ?? 0}",
                                          color: colorRealTime[
                                                  i.value.matchPriceColor] ??
                                              Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                          txalign: TextAlign.end,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 65,
                                        child: customTextStyleBody(
                                          text: "${i.value.changePrice ?? 0}",
                                          color: colorRealTime[
                                                  i.value.changePriceColor] ??
                                              Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                          txalign: TextAlign.end,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        child: customTextStyleBody(
                                          text:
                                              "${i.value.pctChangePrice ?? 0}",
                                          color: colorRealTime[i
                                                  .value.pctChangePriceColor] ??
                                              Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                          txalign: TextAlign.end,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 92,
                                        child: customTextStyleBody(
                                          text: Utils().formatNumber(
                                              i.value.totalTradedQttyNM ?? 0),
                                          color: Theme.of(context).primaryColor,
                                          txalign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 202,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 190,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        chooseTypeTG = 0;
                                      });
                                    },
                                    child: customTextStyleBody(
                                      text: "Top tăng giá",
                                      color: (chooseTypeTG == 0)
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).hintColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        chooseTypeTG = 1;
                                      });
                                    },
                                    child: customTextStyleBody(
                                      text: "Top giảm giá",
                                      color: (chooseTypeTG == 1)
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).hintColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            customTextStyleBody(
                              text: "Xem thêm",
                              size: 12,
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 32) *
                                        3 /
                                        4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chooseTimeTangGiam = 0;
                                        });
                                      },
                                      child: chooseTimeKLWidget(
                                        chooseTimeKL: chooseTimeTangGiam,
                                        chosedTime: 0,
                                        text: "Hôm nay",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chooseTimeTangGiam = 1;
                                        });
                                      },
                                      child: chooseTimeKLWidget(
                                        chooseTimeKL: chooseTimeTangGiam,
                                        chosedTime: 1,
                                        text: "1 tuần",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chooseTimeTangGiam = 2;
                                        });
                                      },
                                      child: chooseTimeKLWidget(
                                        chooseTimeKL: chooseTimeTangGiam,
                                        chosedTime: 2,
                                        text: "1 tháng",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chooseTimeTangGiam = 3;
                                        });
                                      },
                                      child: chooseTimeKLWidget(
                                        chooseTimeKL: chooseTimeTangGiam,
                                        chosedTime: 3,
                                        text: "3 tháng",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width:
                                    (MediaQuery.of(context).size.width - 32) *
                                        1 /
                                        4.3,
                                height: 18,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    value: marketTangGiam,
                                    iconStyleData: IconStyleData(
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      iconSize: 14,
                                      iconEnabledColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        marketTangGiam = value;
                                      });
                                    },
                                    items: [
                                      for (var i in listMarket)
                                        DropdownMenuItem(
                                          value: i,
                                          child: customTextStyleBody(
                                            text: i,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 138,
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 28,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 62,
                                      child: customTextStyleBody(
                                        text: "Mã CK",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: customTextStyleBody(
                                        text: "Giá",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.end,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 65,
                                      child: customTextStyleBody(
                                        text: "+/-",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.end,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: customTextStyleBody(
                                        text: "+/- (%)",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.end,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 92,
                                      child: customTextStyleBody(
                                        text: "Tổng KL",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              for (var i in (chooseTypeTG == 0)
                                  ? (marketTangGiam == 'HSX'
                                      ? top5entriesTangGiaHSX
                                      : marketTangGiam == 'HNX'
                                          ? top5entriesTangGiaHNX
                                          : top5entriesTangGiaUPC)
                                  : (marketTangGiam == 'HSX'
                                      ? top5entriesGiamGiaHSX
                                      : marketTangGiam == 'HNX'
                                          ? top5entriesGiamGiaHNX
                                          : top5entriesGiamGiaUPC))
                                SizedBox(
                                  height: 22,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 62,
                                        child: customTextStyleBody(
                                          text: i.value.symbol ?? "",
                                          color: colorRealTime[
                                                  i.value.matchPriceColor] ??
                                              Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                          txalign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        child: customTextStyleBody(
                                          text: "${i.value.matchPrice ?? 0}",
                                          color: colorRealTime[
                                                  i.value.matchPriceColor] ??
                                              Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                          txalign: TextAlign.end,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 65,
                                        child: customTextStyleBody(
                                          text: "${i.value.changePrice ?? 0}",
                                          color: colorRealTime[
                                                  i.value.changePriceColor] ??
                                              Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                          txalign: TextAlign.end,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        child: customTextStyleBody(
                                          text:
                                              "${i.value.pctChangePrice ?? 0}",
                                          color: colorRealTime[i
                                                  .value.pctChangePriceColor] ??
                                              Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                          txalign: TextAlign.end,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 92,
                                        child: customTextStyleBody(
                                          text: Utils().formatNumber(
                                              i.value.totalTradedQttyNM ?? 0),
                                          color: Theme.of(context).primaryColor,
                                          txalign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTextStyleBody(
                              text: "Danh mục CK đang sở hữu",
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            customTextStyleBody(
                              text: "Xem thêm",
                              size: 12,
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 62,
                                child: customTextStyleBody(
                                  text: "Mã CK",
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                  fontWeight: FontWeight.w500,
                                  txalign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: 63,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    customTextStyleBody(
                                      text: "Giá",
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w500,
                                      txalign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 65,
                                child: customTextStyleBody(
                                  text: "+/-",
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                  fontWeight: FontWeight.w500,
                                  txalign: TextAlign.end,
                                ),
                              ),
                              SizedBox(
                                width: 79,
                                child: customTextStyleBody(
                                  text: "+/- (%)",
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                  fontWeight: FontWeight.w500,
                                  txalign: TextAlign.end,
                                ),
                              ),
                              const SizedBox(
                                width: 60,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 158,
                          child: ListView(
                            children: [
                              for (var i in responseStockInfo)
                                SizedBox(
                                  height: 41,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 62,
                                            child: customTextStyleBody(
                                              text: i['symbol'],
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w500,
                                              txalign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 63,
                                            child: customTextStyleBody(
                                              text:
                                                  "${marketInfo[i['symbol']]?.matchPrice ?? 0.0}",
                                              color: colorRealTime[
                                                      marketInfo[i['symbol']]
                                                          ?.matchPriceColor] ??
                                                  Theme.of(context)
                                                      .primaryColor,
                                              fontWeight: FontWeight.w500,
                                              txalign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 65,
                                            child: customTextStyleBody(
                                              text:
                                                  "${marketInfo[i['symbol']]?.changePrice ?? 0.0}",
                                              color: colorRealTime[
                                                      marketInfo[i['symbol']]
                                                          ?.changePriceColor] ??
                                                  Theme.of(context)
                                                      .primaryColor,
                                              fontWeight: FontWeight.w500,
                                              txalign: TextAlign.end,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 79,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                customTextStyleBody(
                                                  text:
                                                      "${marketInfo[i['symbol']]?.pctChangePrice ?? 0.0}",
                                                  color: colorRealTime[marketInfo[
                                                              i['symbol']]
                                                          ?.pctChangePriceColor] ??
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  txalign: TextAlign.end,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 20,
                                                width: 39,
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BottomBar(
                                                          current: 2,
                                                          symbol: i['symbol'],
                                                          khoiluong: i['trade'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      side: BorderSide(
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor,
                                                      ),
                                                    ),
                                                  ),
                                                  child: FittedBox(
                                                    fit: BoxFit.none,
                                                    child: customTextStyleBody(
                                                      text: "Bán",
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor,
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
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class chooseTimeKLWidget extends StatelessWidget {
  chooseTimeKLWidget({
    super.key,
    required this.chooseTimeKL,
    required this.chosedTime,
    required this.text,
  });

  final int chooseTimeKL;
  int chosedTime;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (chooseTimeKL == chosedTime)
            ? Theme.of(context).secondaryHeaderColor
            : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: customTextStyleBody(
        text: text,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
