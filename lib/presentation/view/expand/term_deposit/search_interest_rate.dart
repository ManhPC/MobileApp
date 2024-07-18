// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getBankSaving.dart';
import 'package:nvs_trading/data/services/getPartnerBank.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/request_send_money/request_send_money.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InterestRate extends StatefulWidget {
  const InterestRate({super.key});

  @override
  State<InterestRate> createState() => _InterestRateState();
}

class _InterestRateState extends State<InterestRate> {
  var _selectedBank;
  var _selectedKyhan;
  TextEditingController bankText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    String localename = appLocal.localeName;
    return Scaffold(
      appBar: appBar(text: appLocal.searchInterestRate('title')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: GetPartnerBank(HydratedBloc.storage.read('token')),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  final bankName = snapshot.data ?? [];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    height: 36,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_search.svg",
                          width: 20,
                          height: 20,
                        ),
                        Expanded(
                          // child: DropdownButtonHideUnderline(
                          //   child: DropdownButton2(
                          //     isExpanded: true,
                          //     value: _selectedBank,
                          //     hint: customTextStyleBody(
                          //       text: "Ngân hàng",
                          //       size: 10,
                          //       color: Theme.of(context).hintColor,
                          //     ),
                          //     iconStyleData: const IconStyleData(
                          //       iconSize: 20,
                          //       icon: Icon(Icons.keyboard_arrow_down),
                          //     ),
                          //     onChanged: (value) {
                          //       setState(() {
                          //         _selectedBank = value!;
                          //       });
                          //     },
                          //     menuItemStyleData: MenuItemStyleData(
                          //       height: 30,
                          //       selectedMenuItemBuilder: (context, child) {
                          //         return Container(
                          //           color: const Color(0xffe7ab21),
                          //           child: child,
                          //         );
                          //       },
                          //     ),
                          //     items: [
                          //       for (var i = 0; i < bankName.length; i++)
                          //         DropdownMenuItem(
                          //           value: bankName[i].bankId,
                          //           child: customTextStyleBody(
                          //             text:
                          //                 '${bankName[i].bankId} - ${bankName[i].bankName}',
                          //             color: Theme.of(context).primaryColor,
                          //             txalign: TextAlign.start,
                          //             textOverflow: TextOverflow.ellipsis,
                          //           ),
                          //         ),
                          //     ],
                          //   ),
                          // ),
                          child: SearchField(
                            hint: appLocal.searchInterestRate('bank'),
                            searchInputDecoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 8, bottom: 10),
                            ),
                            itemHeight: 40,
                            maxSuggestionsInViewPort: 2,
                            onSuggestionTap: (p0) {
                              setState(() {
                                _selectedBank = p0.searchKey;
                              });
                            },
                            onSubmit: (p0) {
                              if (p0 == "") {
                                setState(() {
                                  _selectedBank = null;
                                });
                              } else {
                                setState(() {
                                  _selectedBank = p0;
                                });
                              }
                            },
                            suggestionAction: SuggestionAction.unfocus,
                            controller: bankText,
                            suggestionStyle: const TextStyle(fontSize: 14),
                            suggestions: bankName
                                .map((e) => SearchFieldListItem(e.bankId))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            FutureBuilder(
              future: GetAllCode(
                  "API", "PERIOD", HydratedBloc.storage.read('token')),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  final periodData = snapshot.data ?? [];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          height: 36,
                          width: 161.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          padding: const EdgeInsets.only(right: 8),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              value: _selectedKyhan,
                              hint: customTextStyleBody(
                                text: appLocal.searchInterestRate('term'),
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w400,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedKyhan = value!;
                                });
                              },
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 120,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 30,
                              ),
                              items: [
                                for (var i = 0; i < periodData.length; i++)
                                  DropdownMenuItem(
                                    value: periodData[i]['cdval'].toString(),
                                    child: customTextStyleBody(
                                      text: localename == 'vi'
                                          ? periodData[i]['vN_CDCONTENT']
                                          : periodData[i]['cdcontent'],
                                      color: Theme.of(context).primaryColor,
                                      txalign: TextAlign.start,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        width: 161,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedBank = null;
                              _selectedKyhan = null;
                              bankText.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: customTextStyleBody(
                            text: appLocal.buttonForm('clearFilter'),
                            size: 14,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 26, bottom: 12),
                child: Column(
                  children: [
                    FutureBuilder(
                      future: GetBankSaving(
                          (_selectedBank == null) ? "ALL" : _selectedBank,
                          (_selectedKyhan == null) ? "ALL" : _selectedKyhan,
                          HydratedBloc.storage.read('token')),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else {
                          final bankInterestRateInfo = snapshot.data ?? [];
                          return Expanded(
                            child: ListView.builder(
                              itemCount: bankInterestRateInfo.length,
                              itemBuilder: (context, index) {
                                final info = bankInterestRateInfo[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  //height: 128,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customTextStyleBody(
                                            text: info.bankCode,
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          SizedBox(
                                            height: 24,
                                            width: 56,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RequestSendMoney(
                                                      bankName: info.bankCode,
                                                      kyhan: info.period,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  side: BorderSide(
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor,
                                                  ),
                                                ),
                                              ),
                                              child: customTextStyleBody(
                                                text:
                                                    appLocal.searchInterestRate(
                                                        'deposit'),
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontWeight: FontWeight.w400,
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
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: 162.5,
                                                height: 36,
                                                child: SharedWidget(
                                                  firstText: appLocal
                                                      .searchInterestRate(
                                                          'bank'),
                                                  secondText: info.bankName,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                width: 162.5,
                                                height: 36,
                                                child: SharedWidget(
                                                  firstText:
                                                      "${appLocal.searchInterestRate('interestRate')} (%)",
                                                  secondText:
                                                      "${info.rate}%/ 1 năm",
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: 162.5,
                                                height: 36,
                                                child: SharedWidget(
                                                  firstText: appLocal
                                                      .searchInterestRate(
                                                          'term'),
                                                  secondText: info.perIod_Name,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                width: 162.5,
                                                height: 36,
                                                child: SharedWidget(
                                                  firstText:
                                                      "${appLocal.searchInterestRate('preInterestRate')} (%)",
                                                  secondText:
                                                      "${info.pre_Rate}%/ 1 năm",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SharedWidget extends StatelessWidget {
  SharedWidget({
    super.key,
    required this.firstText,
    required this.secondText,
  });

  String firstText;
  String secondText;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: customTextStyleBody(
            text: firstText,
            txalign: TextAlign.start,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: 81.5,
          child: Tooltip(
            message: secondText,
            triggerMode: TooltipTriggerMode.tap,
            preferBelow: false,
            verticalOffset: 4,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            textStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: customTextStyleBody(
              text: secondText,
              txalign: TextAlign.start,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }
}
