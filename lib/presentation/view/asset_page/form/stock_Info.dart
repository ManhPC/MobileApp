// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/order/orderExcute.dart';

import 'package:nvs_trading/presentation/view/asset_page/profit_or_loss.dart';
import 'package:nvs_trading/presentation/view/asset_page/stock_statement.dart';
import 'package:nvs_trading/presentation/view/bottom_bar/bottom_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class StockInfo extends StatefulWidget {
  StockInfo({
    super.key,
    required this.assetsData,
    required this.indexAcctno,
    required this.stockData,
    required this.acctno,
  });

  String acctno;
  List<dynamic> assetsData;
  int indexAcctno;
  List<dynamic> stockData;

  @override
  State<StockInfo> createState() => _StockInfoState();
}

class _StockInfoState extends State<StockInfo> {
  final List<bool> _isSelected = [];
  final List<bool> _isVisible = [];
  final bool _isObscure = false;

  // chọn mã để bán
  final List<bool> checkSell = [];
  bool isSelectAll = false;

  bool isEnableSell = false;

  //pop up bán nhiều mã
  int soduCK = 100;
  String loaiGia = "LO";
  bool isSelectAllpopUp = true;
  final List<bool> checkAllSellPopUp = [];
  final List<String> symbolManySell = [];
  List<bool> isEditedPopUp = [];
  List<String> khoiluongBandauPopUp = [];
  List<String> khoiluongPopUp = [];
  List<String> giadatPopUp = [];
  List<String> giadatTTpopUp = [];
  TextEditingController editKL = TextEditingController();
  String? errorKL;
  TextEditingController editGiaDat = TextEditingController();
  String? errorGiadat;
  List<double> ceilPrice = [];
  List<double> floorPrice = [];
  bool isConfirm = true;
  TextEditingController passTrans = TextEditingController();
  bool isObscure = false;
  bool isSavePassTransAsset =
      HydratedBloc.storage.read('isSavePassTransAsset') ?? false;

  // check disable sell all
  void _updateEnableSell() {
    isEnableSell = checkSell.any((element) => element);
  }

  //select all
  void _toggleSelectAll(bool? value) {
    setState(() {
      isSelectAll = value!;
      for (int i = 0; i < checkSell.length; i++) {
        if (widget.stockData[i]['trade'] != "0") {
          checkSell[i] = isSelectAll;
        }
      }
    });
    _updateEnableSell();
  }

  late FToast fToast;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    for (var i = 0; i < widget.stockData.length; i++) {
      setState(() {
        _isSelected.add(false);
        _isVisible.add(false);
        checkSell.add(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return BlocBuilder<MarketInfoCubit, MarketInfoState>(
        builder: (context, state) {
      final marketInfo = state.marketInfo;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextStyleBody(
              text: appLocal.assetStockForm('securitiesBalance'),
              color: Theme.of(context).secondaryHeaderColor,
              size: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      customTextStyleBody(
                        text: appLocal.assetStockForm('gainlossDaily'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                    width: 120,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .background,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const StockStatement(),
                          ),
                        );
                      },
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: customTextStyleBody(
                          text: appLocal.assetStockForm('stockstate'),
                          size: 12,
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
            ),
            customTextStyleBody(
              text:
                  "${Utils().formatNumber(widget.assetsData[widget.indexAcctno]['intradaylosses'])} / ${widget.assetsData[widget.indexAcctno]['intradaylossesratio']}%",
              color:
                  (widget.assetsData[widget.indexAcctno]['intradaylosses'] > 0)
                      ? const Color(0xff4FD08A)
                      : const Color(0xFFF04A47),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: appLocal.assetStockForm('gainlossPort'),
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    height: 24,
                    width: 120,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .background,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfitOrLoss(),
                          ),
                        );
                      },
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: customTextStyleBody(
                          text: appLocal.assetStockForm('rPorL'),
                          size: 12,
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
            ),
            customTextStyleBody(
              text:
                  "${Utils().formatNumber(widget.assetsData[widget.indexAcctno]['glvalue'])} / ${widget.assetsData[widget.indexAcctno]['glpercent']}%",
              color: (widget.assetsData[widget.indexAcctno]['glvalue'] > 0)
                  ? const Color(0xff4FD08A)
                  : const Color(0xFFF04A47),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: appLocal.assetStockForm('directInfo'),
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                  SizedBox(
                    width: 100,
                    height: 24,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                            color: (isEnableSell)
                                ? const Color(0xFFF04A47)
                                : const Color(0xffa0a3af),
                          ),
                        ),
                      ),
                      onPressed: (isEnableSell)
                          ? () {
                              isSelectAllpopUp = true;
                              checkAllSellPopUp.clear();
                              symbolManySell.clear();
                              isEditedPopUp.clear();
                              khoiluongBandauPopUp.clear();
                              khoiluongPopUp.clear();
                              giadatPopUp.clear();
                              isConfirm = true;
                              if (!isSavePassTransAsset) {
                                passTrans.clear();
                              }
                              for (var i = 0; i < checkSell.length; i++) {
                                if (checkSell[i] == true) {
                                  setState(() {
                                    checkAllSellPopUp.add(true);
                                    isEditedPopUp.add(false);
                                  });

                                  symbolManySell
                                      .add(widget.stockData[i]['symbol']);
                                  //KL ban đầu khi chưa sửa đổi
                                  khoiluongBandauPopUp
                                      .add(widget.stockData[i]['trade']);
                                  if (int.parse(widget.stockData[i]['trade']) >
                                      100) {
                                    khoiluongPopUp.add(widget.stockData[i]
                                            ['trade']
                                        .toString()
                                        .replaceRange(
                                            widget.stockData[i]['trade']
                                                    .toString()
                                                    .length -
                                                2,
                                            widget.stockData[i]['trade']
                                                .toString()
                                                .length,
                                            "00"));
                                  } else {
                                    khoiluongPopUp
                                        .add(widget.stockData[i]['trade']);
                                  }
                                  giadatPopUp.add(
                                      marketInfo[widget.stockData[i]['symbol']]
                                              ?.floorPrice
                                              .toString() ??
                                          "0");
                                  ceilPrice.add(
                                      marketInfo[widget.stockData[i]['symbol']]
                                              ?.ceilPrice ??
                                          0);
                                  floorPrice.add(
                                      marketInfo[widget.stockData[i]['symbol']]
                                              ?.floorPrice ??
                                          0);
                                  if (marketInfo[widget.stockData[i]['symbol']]
                                          ?.marketCode ==
                                      "STX") {
                                    giadatTTpopUp.add('MTL');
                                  } else if (marketInfo[widget.stockData[i]
                                              ['symbol']]
                                          ?.marketCode ==
                                      "STO") {
                                    giadatTTpopUp.add('MP');
                                  }
                                }
                              }

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (context, setState2) {
                                      return AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        title: customTextStyleBody(
                                          text: "Bán nhiều mã chứng khoán",
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500,
                                          size: 16,
                                        ),
                                        content: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        customTextStyleBody(
                                                          text:
                                                              "Số dư chứng khoán",
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          height: 30,
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2(
                                                              value: soduCK,
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                  border: Border
                                                                      .all(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .hintColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              iconStyleData:
                                                                  IconStyleData(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              8),
                                                                  child: Icon(Icons
                                                                      .keyboard_arrow_down),
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .hintColor,
                                                              ),
                                                              items: [
                                                                DropdownMenuItem(
                                                                  value: 100,
                                                                  child:
                                                                      customTextStyleBody(
                                                                    text:
                                                                        "100%",
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value: 70,
                                                                  child:
                                                                      customTextStyleBody(
                                                                    text: "70%",
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value: 50,
                                                                  child:
                                                                      customTextStyleBody(
                                                                    text: "50%",
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                              onChanged:
                                                                  ((value) {
                                                                setState2(
                                                                  () {
                                                                    // for (var i = 0;
                                                                    //     i <
                                                                    //         khoiluongPopUp
                                                                    //             .length;
                                                                    //     i++) {
                                                                    //   khoiluongPopUp[
                                                                    //       i] = (double.parse(khoiluongPopUp[
                                                                    //               i]) /
                                                                    //           soduCK *
                                                                    //           100)
                                                                    //       .toStringAsFixed(
                                                                    //           0);
                                                                    // }
                                                                    soduCK =
                                                                        value!;
                                                                    for (var i =
                                                                            0;
                                                                        i < khoiluongPopUp.length;
                                                                        i++) {
                                                                      khoiluongPopUp[
                                                                          i] = (double.parse(khoiluongBandauPopUp[i]) *
                                                                              soduCK /
                                                                              100)
                                                                          .toStringAsFixed(
                                                                              0);
                                                                      if (int.parse(
                                                                              khoiluongPopUp[i]) >
                                                                          100) {
                                                                        khoiluongPopUp[i] = khoiluongPopUp[i].replaceRange(
                                                                            khoiluongPopUp[i].length -
                                                                                2,
                                                                            khoiluongPopUp[i].length,
                                                                            '00');
                                                                      }
                                                                    }
                                                                  },
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        customTextStyleBody(
                                                          text: "Loại giá bán",
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .color!,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          height: 30,
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2(
                                                              value: loaiGia,
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                  border: Border.all(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .hintColor),
                                                                ),
                                                              ),
                                                              iconStyleData:
                                                                  IconStyleData(
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              8),
                                                                  child: Icon(Icons
                                                                      .keyboard_arrow_down),
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .hintColor,
                                                              ),
                                                              items: [
                                                                DropdownMenuItem(
                                                                  value: "LO",
                                                                  child:
                                                                      customTextStyleBody(
                                                                    text: "LO",
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value: "TT",
                                                                  child:
                                                                      customTextStyleBody(
                                                                    text: "TT",
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                              onChanged:
                                                                  ((value) {
                                                                setState2(() {
                                                                  loaiGia =
                                                                      value!;
                                                                });
                                                              }),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    //checkbox
                                                    SizedBox(
                                                      width: 10,
                                                      child: Checkbox(
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        value: isSelectAllpopUp,
                                                        side: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                        ),
                                                        onChanged:
                                                            (bool? value) {
                                                          setState2(() {
                                                            isSelectAllpopUp =
                                                                value!;
                                                            for (int i = 0;
                                                                i <
                                                                    checkAllSellPopUp
                                                                        .length;
                                                                i++) {
                                                              checkAllSellPopUp[
                                                                      i] =
                                                                  isSelectAllpopUp;
                                                            }
                                                          });
                                                        },
                                                        activeColor: Theme.of(
                                                                context)
                                                            .secondaryHeaderColor,
                                                      ),
                                                    ),
                                                    //ma Ck
                                                    SizedBox(
                                                      width: 35,
                                                      child:
                                                          customTextStyleBody(
                                                        text: "Mã CK",
                                                        size: 10,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .color!,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        txalign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    //khoi luong
                                                    SizedBox(
                                                      width: 60,
                                                      child:
                                                          customTextStyleBody(
                                                        text: "Khối lượng",
                                                        size: 10,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .color!,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        txalign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    //gia san
                                                    SizedBox(
                                                      width: 60,
                                                      child:
                                                          customTextStyleBody(
                                                        text: "Giá",
                                                        size: 10,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .color!,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        txalign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    //sua
                                                    SizedBox(
                                                      width: 30,
                                                      child:
                                                          customTextStyleBody(
                                                        text: "Sửa",
                                                        size: 10,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .color!,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        txalign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                for (var i = 0;
                                                    i < symbolManySell.length;
                                                    i++)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      //checkbox
                                                      SizedBox(
                                                        width: 10,
                                                        child: Checkbox(
                                                          materialTapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          side: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor),
                                                          value:
                                                              checkAllSellPopUp[
                                                                  i],
                                                          onChanged:
                                                              (bool? value) {
                                                            setState2(() {
                                                              checkAllSellPopUp[
                                                                  i] = value!;
                                                              isSelectAllpopUp =
                                                                  checkAllSellPopUp.every(
                                                                      (element) =>
                                                                          element);
                                                            });
                                                          },
                                                          activeColor: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                        ),
                                                      ),
                                                      //ma ck
                                                      SizedBox(
                                                        width: 35,
                                                        child:
                                                            customTextStyleBody(
                                                          text:
                                                              symbolManySell[i],
                                                          size: 10,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          txalign:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                      //Khoi luong
                                                      SizedBox(
                                                        width: 60,
                                                        child: (isEditedPopUp[
                                                                i])
                                                            ? SizedBox(
                                                                height:
                                                                    (errorKL ==
                                                                            null)
                                                                        ? 20
                                                                        : 40,
                                                                child:
                                                                    TextField(
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .digitsOnly,
                                                                  ],
                                                                  cursorColor: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  controller:
                                                                      editKL,
                                                                  onChanged:
                                                                      (value) {
                                                                    if (editKL
                                                                        .text
                                                                        .isEmpty) {
                                                                      setState2(
                                                                          () {
                                                                        errorKL =
                                                                            "KL không được để trống";
                                                                      });
                                                                    } else if (int.parse(
                                                                            editKL.text) ==
                                                                        0) {
                                                                      setState2(
                                                                          () {
                                                                        errorKL =
                                                                            "KL phải khác 0";
                                                                      });
                                                                    } else {
                                                                      setState2(
                                                                          () {
                                                                        errorKL =
                                                                            null;
                                                                      });
                                                                    }
                                                                  },
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                    ),
                                                                    errorText:
                                                                        errorKL,
                                                                    errorMaxLines:
                                                                        2,
                                                                    errorStyle:
                                                                        const TextStyle(
                                                                            fontSize:
                                                                                6),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                              color: Colors.red),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                              color: Colors.red),
                                                                    ),
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                8),
                                                                  ),
                                                                ),
                                                              )
                                                            : customTextStyleBody(
                                                                text:
                                                                    // (int.parse(
                                                                    //             khoiluongPopUp[
                                                                    //                 i]) >
                                                                    //         100)
                                                                    //     ?
                                                                    Utils().formatNumber(
                                                                        int.parse(
                                                                            khoiluongPopUp[i])),
                                                                // : khoiluongPopUp[
                                                                //     i],
                                                                size: 10,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                txalign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                      ),
                                                      //gia san
                                                      SizedBox(
                                                        width: 60,
                                                        child: (loaiGia == "LO")
                                                            ? (isEditedPopUp[i])
                                                                ? SizedBox(
                                                                    height: (errorGiadat ==
                                                                            null)
                                                                        ? 20
                                                                        : 40,
                                                                    child:
                                                                        TextField(
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp(r'[\d.]')),
                                                                      ],
                                                                      maxLength:
                                                                          5,
                                                                      buildCounter: (BuildContext context,
                                                                              {int? currentLength,
                                                                              int? maxLength,
                                                                              bool? isFocused}) =>
                                                                          null,
                                                                      cursorColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                      controller:
                                                                          editGiaDat,
                                                                      onChanged:
                                                                          (value) {
                                                                        double
                                                                            a =
                                                                            double.parse(editGiaDat.text);
                                                                        if (editGiaDat
                                                                            .text
                                                                            .isEmpty) {
                                                                          setState2(
                                                                              () {
                                                                            errorGiadat =
                                                                                "Giá đặt không được để trống";
                                                                          });
                                                                        } else if (a >
                                                                                ceilPrice[i] ||
                                                                            a < floorPrice[i]) {
                                                                          setState2(
                                                                              () {
                                                                            errorGiadat =
                                                                                "Giá đặt phải nằm trong khoảng trần - sàn";
                                                                          });
                                                                        } else {
                                                                          setState2(
                                                                              () {
                                                                            errorGiadat =
                                                                                null;
                                                                          });
                                                                        }
                                                                      },
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Theme.of(context).hintColor,
                                                                          ),
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Theme.of(context).hintColor,
                                                                          ),
                                                                        ),
                                                                        errorText:
                                                                            errorGiadat,
                                                                        errorMaxLines:
                                                                            2,
                                                                        errorStyle:
                                                                            const TextStyle(fontSize: 6),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        ),
                                                                        contentPadding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                8),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : customTextStyleBody(
                                                                    text:
                                                                        giadatPopUp[
                                                                            i],
                                                                    size: 10,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    txalign:
                                                                        TextAlign
                                                                            .start,
                                                                  )
                                                            : customTextStyleBody(
                                                                text:
                                                                    giadatTTpopUp[
                                                                        i],
                                                                size: 10,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                txalign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                      ),
                                                      //button sua
                                                      SizedBox(
                                                        width: 30,
                                                        height: 20,
                                                        child: TextButton(
                                                          onPressed: isEditedPopUp[
                                                                  i]
                                                              ? () {
                                                                  if (errorKL !=
                                                                          null ||
                                                                      errorGiadat !=
                                                                          null) {
                                                                    return;
                                                                  } else {
                                                                    setState2(
                                                                        () {
                                                                      isConfirm =
                                                                          true;
                                                                      khoiluongPopUp[
                                                                              i] =
                                                                          editKL
                                                                              .text;
                                                                      giadatPopUp[
                                                                              i] =
                                                                          editGiaDat
                                                                              .text;
                                                                      isEditedPopUp[
                                                                              i] =
                                                                          !isEditedPopUp[
                                                                              i];
                                                                    });
                                                                  }
                                                                }
                                                              : isEditedPopUp.any(
                                                                      (element) =>
                                                                          element ==
                                                                          true)
                                                                  ? null
                                                                  : () {
                                                                      setState2(
                                                                          () {
                                                                        isConfirm =
                                                                            false;
                                                                        editKL.text =
                                                                            khoiluongPopUp[i];

                                                                        editGiaDat.text =
                                                                            giadatPopUp[i];
                                                                        isEditedPopUp[i] =
                                                                            !isEditedPopUp[i];
                                                                      });
                                                                    },
                                                          style: TextButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              side: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                              ),
                                                            ),
                                                          ),
                                                          child: FittedBox(
                                                            fit: BoxFit.none,
                                                            child:
                                                                customTextStyleBody(
                                                              text:
                                                                  (isEditedPopUp[
                                                                          i])
                                                                      ? "Lưu"
                                                                      : "Sửa",
                                                              color: Theme.of(
                                                                      context)
                                                                  .secondaryHeaderColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                customTextStyleBody(
                                                  text: "Mật khẩu GD",
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .color!,
                                                  size: 10,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                      width: 200,
                                                      child: TextField(
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        controller: passTrans,
                                                        obscureText: !isObscure,
                                                        decoration:
                                                            InputDecoration(
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            borderSide: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            borderSide: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor),
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8),
                                                          suffix:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState2(() {
                                                                isObscure =
                                                                    !isObscure;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 8),
                                                              child: Icon(
                                                                (isObscure)
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off,
                                                                size: 16,
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                      child: Checkbox(
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        side: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                        ),
                                                        value:
                                                            isSavePassTransAsset,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState2(() {
                                                            isSavePassTransAsset =
                                                                value!;
                                                          });
                                                          HydratedBloc.storage
                                                              .write(
                                                                  'isSavePassTransAsset',
                                                                  value);
                                                        },
                                                        activeColor: Theme.of(
                                                                context)
                                                            .secondaryHeaderColor,
                                                      ),
                                                    ),
                                                    customTextStyleBody(
                                                      text: "Lưu",
                                                      size: 10,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ],
                                                ),
                                                customTextStyleBody(
                                                  text:
                                                      "*Vui lòng nhập mật khẩu giao dịch được cấp khi mở tài khoản!",
                                                  size: 10,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w400,
                                                  txalign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: (isConfirm)
                                                ? () async {
                                                    for (var i = 0;
                                                        i <
                                                            symbolManySell
                                                                .length;
                                                        i++) {
                                                      if (checkAllSellPopUp[
                                                              i] ==
                                                          true) {
                                                        final response =
                                                            await OrderExcute(
                                                          widget.acctno,
                                                          "NS",
                                                          passTrans.text,
                                                          (loaiGia == "LO")
                                                              ? giadatPopUp[i]
                                                              : giadatTTpopUp[
                                                                  i],
                                                          int.parse(
                                                              khoiluongPopUp[i]
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          r','),
                                                                      '')),
                                                          symbolManySell[i],
                                                        );
                                                        if (response
                                                            .isNotEmpty) {
                                                          //print(response[0]['code']);
                                                          print(response);
                                                          if (response[0] ==
                                                              400) {
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
                                                                text:
                                                                    "Thất bại, ${response[1]}",
                                                              ),
                                                            );
                                                          } else if (response[0]
                                                                  ['code'] ==
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
                                                                text:
                                                                    response[0]
                                                                        ['msg'],
                                                              ),
                                                            );
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
                                                                text:
                                                                    "Thất bại, ${response[0]['msg']}",
                                                              ),
                                                            );
                                                          }
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
                                                              text: "Thất bại",
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    }
                                                    Navigator.of(context).pop();
                                                    setState(
                                                      () {
                                                        checkSell.setAll(
                                                            0,
                                                            List<bool>.filled(
                                                                checkSell
                                                                    .length,
                                                                false));
                                                        isEnableSell = false;
                                                        soduCK = 100;
                                                        loaiGia = "LO";
                                                      },
                                                    );
                                                  }
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              disabledBackgroundColor:
                                                  const Color(0xffa0a3af),
                                              backgroundColor: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .background,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            child: customTextStyleBody(
                                              text: "Xác nhận",
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .primary,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState2(() {
                                                soduCK = 100;
                                                loaiGia = "LO";
                                                errorKL = null;
                                                errorGiadat = null;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xffa0a3af),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            child: customTextStyleBody(
                                              text: "Hủy bỏ",
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .primary,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          : null,
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: customTextStyleBody(
                          text: appLocal.assetStockForm('sellmulcode'),
                          size: 12,
                          color: (isEnableSell)
                              ? const Color(0xFFF04A47)
                              : const Color(0xffa0a3af),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 5, right: 4),
                        width: 30,

                        // color: Colors.yellow,
                        child: Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          visualDensity: VisualDensity.compact,
                          onChanged: (bool? value) {
                            _toggleSelectAll(value);
                          },
                          value: isSelectAll,
                          side: BorderSide(
                            color: Theme.of(context).hintColor,
                          ),
                          activeColor: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .background,
                          checkColor: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .primary,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: customTextStyleBody(
                          text: appLocal.assetStockForm('symbol'),
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          size: 10,
                          txalign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: customTextStyleBody(
                          text: appLocal.assetStockForm('market'),
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          size: 10,
                          txalign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: customTextStyleBody(
                          text: appLocal.assetStockForm('costprice'),
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          size: 10,
                          txalign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: customTextStyleBody(
                          text: appLocal.assetStockForm('price'),
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          size: 10,
                          txalign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: customTextStyleBody(
                          text: appLocal.assetStockForm('availablevol'),
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          size: 10,
                          txalign: TextAlign.end,
                        ),
                      ),
                      SizedBox(
                        width: 71,
                        child: customTextStyleBody(
                          text: "${appLocal.assetStockForm('gainloss')} (%)",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          size: 10,
                          txalign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                for (var i = 0; i < widget.stockData.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSelected[i] = !_isSelected[i];
                          (!_isSelected[i]) ? _isVisible[i] = false : null;
                        });
                      },
                      child: AnimatedContainer(
                        decoration: BoxDecoration(
                          // color: Theme.of(context).colorScheme.primary,
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(milliseconds: 700),
                        width: double.infinity,
                        height: _isSelected[i] ? 194 : 44,
                        curve: Curves.easeInOut,
                        onEnd: _isSelected[i]
                            ? () {
                                setState(() {
                                  _isVisible[i] = true;
                                });
                              }
                            : () {},
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //checkbox
                                  Container(
                                    width: 30,
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 4),
                                    child: (widget.stockData[i]['trade'] == "0")
                                        ? Checkbox(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            visualDensity:
                                                VisualDensity.compact,
                                            side: BorderSide(
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                            fillColor: MaterialStatePropertyAll(
                                                Theme.of(context).hintColor),
                                            value: false,
                                            onChanged: null,
                                          )
                                        : Checkbox(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            visualDensity:
                                                VisualDensity.compact,
                                            side: BorderSide(
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                checkSell[i] = value!;
                                                isSelectAll = checkSell.every(
                                                    (element) => element);
                                              });
                                              _updateEnableSell();
                                            },
                                            value: checkSell[i],
                                            activeColor: Theme.of(context)
                                                .buttonTheme
                                                .colorScheme!
                                                .background,
                                            checkColor: Theme.of(context)
                                                .buttonTheme
                                                .colorScheme!
                                                .primary,
                                          ),
                                  ),
                                  // ma ck : done
                                  SizedBox(
                                    width: 40,
                                    child: customTextStyleBody(
                                      text: widget.stockData[i]['symbol'],
                                      txalign: TextAlign.start,
                                      color: int.parse(((marketInfo[widget.stockData[i][
                                                                          'symbol']]
                                                                      ?.matchPrice ??
                                                                  0) *
                                                              1000)
                                                          .toStringAsFixed(0)) *
                                                      int.parse(
                                                          widget.stockData[i]
                                                              ['totalvolume']) -
                                                  int.parse(widget.stockData[i]
                                                      ['costvalue']) >
                                              0
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w500,
                                      size: 12,
                                    ),
                                  ),
                                  // san ck: done
                                  SizedBox(
                                    width: 40,
                                    child: customTextStyleBody(
                                      text: marketInfo[widget.stockData[i]
                                                  ['symbol']]
                                              ?.marketName ??
                                          "",
                                      txalign: TextAlign.start,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                      size: 12,
                                    ),
                                  ),
                                  // gia von : done
                                  SizedBox(
                                    width: 40,
                                    child: customTextStyleBody(
                                      text: (int.parse(widget.stockData[i]
                                                  ['costprice']) /
                                              1000)
                                          .toStringAsFixed(2),
                                      txalign: TextAlign.start,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                      size: 12,
                                    ),
                                  ),
                                  //gia TT : done
                                  SizedBox(
                                    width: 40,
                                    child: customTextStyleBody(
                                      // text: Utils().formatNumber(int.parse(
                                      //     ((marketInfo[widget.stockData[i]
                                      //                         ['symbol']]
                                      //                     ?.matchPrice ??
                                      //                 0) *
                                      //             1000)
                                      //         .toStringAsFixed(0))),
                                      text: (marketInfo[widget.stockData[i]
                                                      ['symbol']]
                                                  ?.matchPrice ??
                                              0)
                                          .toStringAsFixed(2),
                                      color: Theme.of(context).primaryColor,
                                      txalign: TextAlign.center,
                                      fontWeight: FontWeight.w500,
                                      size: 12,
                                    ),
                                  ),
                                  //KL kha dung: done
                                  SizedBox(
                                    width: 60,
                                    child: customTextStyleBody(
                                      text: Utils().formatNumber(int.parse(
                                          widget.stockData[i]['trade'])),
                                      txalign: TextAlign.end,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                      size: 12,
                                    ),
                                  ),
                                  // lai/lo % : done
                                  SizedBox(
                                    width: 71,
                                    child: customTextStyleBody(
                                      text:
                                          "${(int.parse(widget.stockData[i]['costvalue']) != 0) ? (((int.parse(((marketInfo[widget.stockData[i]['symbol']]?.matchPrice ?? 0) * 1000).toStringAsFixed(0)) * int.parse(widget.stockData[i]['totalvolume'])) / int.parse(widget.stockData[i]['costvalue']) - 1) * 100).toStringAsFixed(2) : 0}%",
                                      color: ((int.parse(((marketInfo[widget
                                                                          .stockData[i]
                                                                      [
                                                                      'symbol']]
                                                                  ?.matchPrice ??
                                                              0) *
                                                          1000)
                                                      .toStringAsFixed(0)) *
                                                  int.parse(widget.stockData[i]
                                                      ['totalvolume'])) >
                                              int.parse(widget.stockData[i]
                                                  ['costvalue']))
                                          ? const Color(0xff4FD08A)
                                          : const Color(0xFFF04A47),
                                      txalign: TextAlign.end,
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Visibility(
                                visible: _isVisible[i],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //tong von : done
                                        ThongTinTS(
                                          text: appLocal
                                              .assetStockForm('capitalvalue'),
                                          number: Utils().formatNumber(
                                              int.parse(widget.stockData[i]
                                                  ['costvalue'])),
                                        ),
                                        //gia tri TT: done
                                        ThongTinTS(
                                          text: appLocal
                                              .assetStockForm('marketvalue'),
                                          number: Utils().formatNumber(int.parse(
                                                  ((marketInfo[widget.stockData[
                                                                          i][
                                                                      'symbol']]
                                                                  ?.matchPrice ??
                                                              0) *
                                                          1000)
                                                      .toStringAsFixed(0)) *
                                              int.parse(widget.stockData[i]
                                                  ['totalvolume'])),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //Tong KL : phan van volumn vs qtty
                                        ThongTinTS(
                                          text: appLocal
                                              .assetStockForm('totalvol'),
                                          number: Utils().formatNumber(
                                              int.parse(widget.stockData[i]
                                                  ['totalvolume'])),
                                        ),
                                        //KL kha dung: done
                                        ThongTinTS(
                                          text: appLocal
                                              .assetStockForm('availablevol'),
                                          number: Utils().formatNumber(
                                              int.parse(widget.stockData[i]
                                                  ['trade'])),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //Khong kha dung: done
                                        ThongTinTS(
                                          text: appLocal
                                              .assetStockForm('shareUnA'),
                                          number:
                                              "${widget.stockData[i]['blocked']}",
                                        ),
                                        //Lai lo : done
                                        ThongTinTS(
                                          text: appLocal
                                              .assetStockForm('gainloss'),
                                          number: Utils().formatNumber(int.parse(
                                                      ((marketInfo[widget.stockData[i]['symbol']]
                                                                      ?.matchPrice ??
                                                                  0) *
                                                              1000)
                                                          .toStringAsFixed(0)) *
                                                  int.parse(widget.stockData[i]
                                                      ['totalvolume']) -
                                              int.parse(widget.stockData[i]
                                                  ['costvalue'])),
                                          colorNumber: ((int.parse(((marketInfo[widget.stockData[i]['symbol']]
                                                                          ?.matchPrice ??
                                                                      0) *
                                                                  1000)
                                                              .toStringAsFixed(
                                                                  0)) *
                                                          int.parse(widget
                                                                  .stockData[i]
                                                              ['totalvolume']) -
                                                      int.parse(
                                                          widget.stockData[i]
                                                              ['costvalue'])) <
                                                  0)
                                              ? const Color(0xFFF04A47)
                                              : const Color(0xff4FD08A),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    //KL cho ve: done
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 215,
                                          height: 80,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 82,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    customTextStyleBody(
                                                      text: appLocal
                                                          .assetStockForm(
                                                              'buypending'),
                                                      size: 12,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .color!,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    customTextStyleBody(
                                                      text: " • T0",
                                                      size: 12,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .color!,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    customTextStyleBody(
                                                      text: " • T1",
                                                      size: 12,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .color!,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    customTextStyleBody(
                                                      text: " • T2",
                                                      size: 12,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .color!,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 84,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    customTextStyleBody(
                                                        text: ""),
                                                    customTextStyleBody(
                                                      text:
                                                          " • ${Utils().formatNumber(int.parse(widget.stockData[i]['t0']))}",
                                                      size: 12,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    customTextStyleBody(
                                                      text:
                                                          " • ${Utils().formatNumber(int.parse(widget.stockData[i]['t1']))}",
                                                      size: 12,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    customTextStyleBody(
                                                      text:
                                                          " • ${Utils().formatNumber(int.parse(widget.stockData[i]['t2']))}",
                                                      size: 12,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 140,
                                          height: 30,
                                          margin:
                                              const EdgeInsets.only(right: 6),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xffF04A47),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BottomBar(
                                                    current: 2,
                                                    symbol: widget.stockData[i]
                                                        ['symbol'],
                                                    khoiluong: widget
                                                        .stockData[i]['trade'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: customTextStyleBody(
                                              text: appLocal
                                                  .buttonForm('sellButton'),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // String? get errorkhoiluong {
  //   final text = editKL.value.text;
  //   if (text.isEmpty) {
  //     return "Khối lượng không được để trống";
  //   }
  //   return null;
  // }

  // String? get errorGiaDat {
  //   final text = editGiaDat.value.text;
  //   if (text.isEmpty) {
  //     return "Giá đặt không được để trống";
  //   }
  // }
}

class ThongTinTS extends StatelessWidget {
  ThongTinTS({
    super.key,
    required this.text,
    required this.number,
    this.colorNumber,
  });

  String text;
  String number;
  Color? colorNumber;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 155.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: text,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
            size: 12,
          ),
          customTextStyleBody(
            text: number,
            color: (colorNumber == null)
                ? Theme.of(context).primaryColor
                : colorNumber!,
            fontWeight: FontWeight.w500,
            size: 12,
          ),
        ],
      ),
    );
  }
}
