import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/cash_info.dart';
import 'package:nvs_trading/data/services/assetsOverView.dart';
import 'package:nvs_trading/data/services/cashInfo.dart';
import 'package:nvs_trading/data/services/getStockInfo.dart';
import 'package:nvs_trading/presentation/view/asset_page/form/genaral_Info.dart';
import 'package:nvs_trading/presentation/view/asset_page/form/money_Info.dart';
import 'package:nvs_trading/presentation/view/asset_page/form/stock_Info.dart';
import 'package:nvs_trading/presentation/view/asset_page/outstanding_debt_information.dart';
import 'package:nvs_trading/presentation/view/provider/changeAcctno.dart';
import 'package:nvs_trading/presentation/widget/chooseAcctno.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  bool _isObscure = false;
  List<String> tabbarMG = [];
  List<String> tabbarNM = [];

  int currentIndex = 0;

  String acctno = "";
  String custodycd = HydratedBloc.storage.read('custodycd');
  String token = HydratedBloc.storage.read('token');

  int indexAcctno = 0;

  List<dynamic> assetsData = [];
  List<CashInfoModel> cashInfoData = [];
  List<dynamic> responseStockInfo = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final changeAcctno = Provider.of<ChangeAcctno>(context, listen: false);
      setState(() {
        acctno = changeAcctno.acctno;
      });
      fetchAllData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final changeAcctno = Provider.of<ChangeAcctno>(context);
    if (acctno != changeAcctno.acctno) {
      setState(() {
        acctno = changeAcctno.acctno;
        currentIndex = 0;
      });
      fetchAllData();
    }
  }

  void fetchAllData() {
    fetchAssets();
    fetchCashInfo();
    fetchStock();
  }

  void fetchAssets() async {
    final response = await AssetsOverView(custodycd);
    setState(() {
      assetsData = response;
      indexAcctno = assetsData.indexWhere((e) => e['acctno'] == acctno);
    });
    print(indexAcctno);
  }

  void fetchCashInfo() async {
    final response = await getCashInfo(custodycd, acctno);
    if (response.isNotEmpty) {
      setState(() {
        cashInfoData = response;
      });
    } else {
      print("Sai bị rỗng");
    }
  }

  void fetchStock() async {
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

  bool isFirstTimeLanguage = true;
  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    var language = appLocal.localeName;
    if (isFirstTimeLanguage) {
      if (language == 'vi') {
        tabbarMG = [
          "Thông tin tài sản",
          "Số dư tiền",
          "Số dư chứng khoán",
        ];
        tabbarNM = [
          "Số dư tiền",
          "Số dư chứng khoán",
        ];
      } else {
        tabbarMG = [
          "Asset information",
          "Account balance",
          "Securities balance",
        ];
        tabbarNM = [
          "Account balance",
          "Securities balance",
        ];
      }
    }
    return assetsData.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: customTextStyleAppbar(
                text: appLocal.assetPageForm('assetPM'),
                size: (language == 'vi') ? 18 : 16,
              ),
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const ChooseAcctno(),
                  ),
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: (acctno.endsWith("NM"))
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          height: 158,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customTextStyleBody(
                                    text: appLocal.assetPageForm('account'),
                                    size: 16,
                                    fontWeight: FontWeight.w500,
                                    txalign: TextAlign.start,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    height: 24,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                            builder: (context) =>
                                                const OutDebtInfo(),
                                          ),
                                        );
                                      },
                                      child: customTextStyleBody(
                                        text: appLocal
                                            .assetPageForm('outdebtinfo'),
                                        color: Theme.of(context)
                                            .buttonTheme
                                            .colorScheme!
                                            .background,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text:
                                            appLocal.assetPageForm('netassets'),
                                        txalign: TextAlign.start,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                      ),
                                      Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: _isObscure
                                                      ? "${Utils().formatNumber(assetsData[indexAcctno]['nav'])} "
                                                      : "${"*" * (assetsData[indexAcctno]['nav'].toString().length)} ",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "VND   ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            },
                                            child: Icon(
                                              _isObscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              size: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 67,
                                    height: 60,
                                    child: Image.asset(
                                      "assets/images/Mask Group.png",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: appLocal.assetPageForm('cash'),
                                        size: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: _isObscure
                                                  ? "${Utils().formatNumber(assetsData[indexAcctno]['cash'])} "
                                                  : "${"*" * (assetsData[indexAcctno]['cash'].toString().length)} ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " VND",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        // text: "Tiền đã ứng trước",
                                        text: appLocal
                                            .assetPageForm('securities'),
                                        size: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: _isObscure
                                                  ? "${Utils().formatNumber(assetsData[indexAcctno]['marketvalue'])} "
                                                  : "${"*" * (assetsData[indexAcctno]['marketvalue'].toString().length)} ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " VND",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(8),
                          height: 158,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customTextStyleBody(
                                    text: appLocal.assetPageForm('account'),
                                    size: 16,
                                    fontWeight: FontWeight.w500,
                                    txalign: TextAlign.start,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    height: 24,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                            builder: (context) =>
                                                const OutDebtInfo(),
                                          ),
                                        );
                                      },
                                      child: customTextStyleBody(
                                        text: appLocal
                                            .assetPageForm('outdebtinfo'),
                                        color: Theme.of(context)
                                            .buttonTheme
                                            .colorScheme!
                                            .background,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: appLocal
                                            .assetPageForm('totalactualassets'),
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.start,
                                      ),
                                      Row(
                                        children: [
                                          // RichText(
                                          //   text: TextSpan(
                                          //     children: [
                                          //       TextSpan(
                                          //         text: _isObscure
                                          //             ? "${Utils().formatNumber(assetsData[indexAcctno]['totalasset'])} "
                                          //             : "${"*" * (assetsData[indexAcctno]['totalasset'].toString().length)} ",
                                          //         style: TextStyle(
                                          //           fontSize: 16,
                                          //           color: Theme.of(context)
                                          //               .primaryColor,
                                          //         ),
                                          //       ),
                                          //       TextSpan(
                                          //         text: "VND   ",
                                          //         style: TextStyle(
                                          //           fontSize: 12,
                                          //           color: Theme.of(context)
                                          //               .primaryColor,
                                          //         ),
                                          //       )
                                          //     ],
                                          //   ),
                                          // ),
                                          SizedBox(
                                            width: 110,
                                            child: AutoSizeText(
                                              _isObscure
                                                  ? "${Utils().formatNumber(assetsData[indexAcctno]['totalasset'])} "
                                                  : "${"*" * (assetsData[indexAcctno]['totalasset'].toString().length)} ",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          customTextStyleBody(
                                            text: "VND",
                                            size: 12,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: appLocal
                                            .assetPageForm('actualnetassets'),
                                        txalign: TextAlign.start,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                      ),
                                      Row(
                                        children: [
                                          // RichText(
                                          //   text: TextSpan(
                                          //     children: [
                                          //       TextSpan(
                                          //         text: _isObscure
                                          //             ? "${Utils().formatNumber(assetsData[indexAcctno]['nav'])} "
                                          //             : "${"*" * (assetsData[indexAcctno]['nav'].toString().length)} ",
                                          //         style: TextStyle(
                                          //           fontSize: 16,
                                          //           color: Theme.of(context)
                                          //               .primaryColor,
                                          //         ),
                                          //       ),
                                          //       TextSpan(
                                          //         text: "VND   ",
                                          //         style: TextStyle(
                                          //           fontSize: 12,
                                          //           color: Theme.of(context)
                                          //               .primaryColor,
                                          //         ),
                                          //       )
                                          //     ],
                                          //   ),
                                          // ),
                                          SizedBox(
                                            width: 110,
                                            child: AutoSizeText(
                                              _isObscure
                                                  ? "${Utils().formatNumber(assetsData[indexAcctno]['nav'])} "
                                                  : "${"*" * (assetsData[indexAcctno]['nav'].toString().length)} ",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          customTextStyleBody(
                                            text: "VND ",
                                            size: 12,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            },
                                            child: Icon(
                                              _isObscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              size: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 67,
                                    height: 60,
                                    child: Image.asset(
                                      "assets/images/Mask Group.png",
                                      scale: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: appLocal
                                            .assetPageForm('availablecash'),
                                        size: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: _isObscure
                                                  ? "${Utils().formatNumber(assetsData[indexAcctno]['withdrawable'])} "
                                                  : "${"*" * (assetsData[indexAcctno]['withdrawable'].toString().length)} ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " VND",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        // text: "Tiền đã ứng trước",
                                        text:
                                            appLocal.assetPageForm('totaldebt'),
                                        size: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: _isObscure
                                                  ? "${Utils().formatNumber(assetsData[indexAcctno]['totalloan'])} "
                                                  : "${"*" * (assetsData[indexAcctno]['totalloan'].toString().length)} ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " VND",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 42,
                                  ),
                                  Column(
                                    children: [
                                      customTextStyleBody(
                                        text:
                                            appLocal.assetPageForm('rttRatio'),
                                        size: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                      ),
                                      customTextStyleBody(
                                        text: (cashInfoData.first.rtt! % 100 ==
                                                0)
                                            ? Utils().formatNumber(
                                                cashInfoData.first.rtt!.toInt())
                                            : "${cashInfoData.first.rtt ?? 0}%",
                                        color: const Color(0xff4FD08A),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: acctno.endsWith("NM")
                        ? tabbarNM.length
                        : tabbarMG.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: (currentIndex == index)
                                  ? BorderSide(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 16, top: 8),
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: customTextStyleBody(
                            text: (acctno.endsWith("NM"))
                                ? tabbarNM[index]
                                : tabbarMG[index],
                            color: (currentIndex == index)
                                ? Theme.of(context).secondaryHeaderColor
                                : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: (acctno.endsWith("NM"))
                        ? (currentIndex == 0
                            ? MoneyInfo(
                                cashInfo: cashInfoData,
                              )
                            : StockInfo(
                                acctno: acctno,
                                assetsData: assetsData,
                                indexAcctno: indexAcctno,
                                stockData: responseStockInfo,
                              ))
                        : (currentIndex == 0)
                            ? GeneralInfo(
                                cashInfo: cashInfoData,
                                assetData: assetsData,
                                indexAcctno: indexAcctno,
                              )
                            : (currentIndex == 1)
                                ? MoneyInfo(
                                    cashInfo: cashInfoData,
                                  )
                                : StockInfo(
                                    acctno: acctno,
                                    assetsData: assetsData,
                                    indexAcctno: indexAcctno,
                                    stockData: responseStockInfo,
                                  ),
                  ),
                ),
              ],
            ),
          );
  }
}
