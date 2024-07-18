// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getInfoCustomer.dart';
import 'package:nvs_trading/data/services/getStockInfo.dart';
import 'package:nvs_trading/data/services/insertWarning.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingWarning extends StatefulWidget {
  SettingWarning({super.key, required this.pageController});
  PageController pageController;

  @override
  State<SettingWarning> createState() => _SettingWarningState();
}

class _SettingWarningState extends State<SettingWarning> {
  var account;
  var typeUse;
  var maCK;
  var accountChoice;
  TextEditingController profitText = TextEditingController();
  TextEditingController lossText = TextEditingController();
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    initializeData();
  }

  void initializeData() async {
    account = HydratedBloc.storage.read('acctno');
    await fetchCustomerInfo(); // Chờ cho fetchCustomerInfo() hoàn thành
    resetTypeUse();
  }

  Future<void> fetchCustomerInfo() async {
    final res = await GetInfoCustomer(
      HydratedBloc.storage.read('custodycd'),
      HydratedBloc.storage.read('token'),
    );
    if (res.isNotEmpty) {
      for (var i in res) {
        if (i.acctno == account) {
          accountChoice = i.acctno;
        }
      }
    }
  }

  void resetTypeUse() {
    setState(() {
      typeUse = "000";
    });
  }

  void resetMaCK() {
    setState(() {
      maCK = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    String localename = appLocal.localeName;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 29),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: appLocal.losswarning('account'),
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w400,
                  ),
                  FutureBuilder(
                    future: GetInfoCustomer(
                      HydratedBloc.storage.read('custodycd'),
                      HydratedBloc.storage.read('token'),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        final resData = snapshot.data ?? [];
                        return Container(
                          height: 28,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border:
                                Border.all(color: Theme.of(context).hintColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              onChanged: (value) {
                                setState(() {
                                  account = value;
                                  fetchCustomerInfo();
                                  resetTypeUse();
                                  resetMaCK();
                                  profitText.clear();
                                  lossText.clear();
                                });
                              },
                              value: account,
                              items: [
                                for (var i in resData)
                                  DropdownMenuItem(
                                    value: i.acctno,
                                    child: customTextStyleBody(
                                      text: i.acctno,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                              ],
                              iconStyleData: IconStyleData(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 16,
                                iconEnabledColor: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: appLocal.losswarning('applicabletype'),
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w400,
                  ),
                  FutureBuilder(
                    future: GetAllCode(
                      "API",
                      "APPLYTYPE",
                      HydratedBloc.storage.read('token'),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        final responseData = snapshot.data ?? [];
                        return Container(
                          height: 28,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              onChanged: (value) {
                                setState(() {
                                  typeUse = value;
                                });
                              },
                              value: typeUse,
                              items: [
                                for (var i in responseData)
                                  DropdownMenuItem(
                                    value: i['cdval'],
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: customTextStyleBody(
                                        text: (localename == 'vi')
                                            ? i['vN_CDCONTENT']
                                            : i['cdcontent'],
                                        color: Theme.of(context).primaryColor,
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                              ],
                              isExpanded: true,
                              iconStyleData: IconStyleData(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 16,
                                iconEnabledColor: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: (typeUse == "001") ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: appLocal.losswarning('stockcode'),
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                    FutureBuilder(
                      future: GetStockInfo(
                        HydratedBloc.storage.read('custodycd'),
                        accountChoice.toString(),
                        HydratedBloc.storage.read('token'),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: Colors.blue,
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else {
                          final maCKData = snapshot.data!;

                          return Container(
                            height: 28,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                onChanged: (value) {
                                  setState(() {
                                    maCK = value;
                                  });
                                },
                                value: maCK,
                                items: [
                                  DropdownMenuItem(
                                    value: "ALL",
                                    child: customTextStyleBody(
                                      text: (localename == 'vi')
                                          ? "Tất cả"
                                          : 'All',
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  for (var i in maCKData)
                                    DropdownMenuItem(
                                      value: i['symbol'],
                                      child: customTextStyleBody(
                                        text: i['symbol'],
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                ],
                                isExpanded: true,
                                iconStyleData: IconStyleData(
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconSize: 16,
                                  iconEnabledColor: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: "${appLocal.losswarning('profit')} (%)",
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 28,
                    width: 200,
                    child: TextField(
                      cursorColor: Theme.of(context).primaryColor,
                      controller: profitText,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.only(left: 16),
                        hintText: appLocal.losswarning('profit'),
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: "${appLocal.losswarning('loss')} (%)",
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 28,
                    width: 200,
                    child: TextField(
                      cursorColor: Theme.of(context).primaryColor,
                      controller: lossText,
                      decoration: InputDecoration(
                        hintText: appLocal.losswarning('loss'),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.only(left: 16),
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).buttonTheme.colorScheme!.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          onPressed: () async {
            if (profitText.text.isEmpty || lossText.text.isEmpty) {
              fToast.showToast(
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(seconds: 2),
                child: msgNotification(
                  color: Colors.red,
                  icon: Icons.error,
                  text: "Chưa nhập lãi/ lỗ",
                ),
              );
            } else {
              final res = await InsertWarning(
                accountChoice,
                HydratedBloc.storage.read('custodycd'),
                lossText.text,
                profitText.text,
                maCK,
                typeUse,
                HydratedBloc.storage.read('token'),
              );
              if (res == 200) {
                fToast.showToast(
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(seconds: 2),
                  child: msgNotification(
                    color: Colors.green,
                    icon: Icons.check_circle,
                    text: "Thêm mới thành công!",
                  ),
                );
                widget.pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                });
              } else {
                fToast.showToast(
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(seconds: 2),
                  child: msgNotification(
                    color: Colors.red,
                    icon: Icons.cancel,
                    text: "Loại cảnh báo đã tồn tại",
                  ),
                );
              }
              setState(() {
                fetchCustomerInfo();
                resetTypeUse();
                resetMaCK();
                profitText.clear();
                lossText.clear();
              });
            }
          },
          child: customTextStyleBody(
            text: appLocal.buttonForm('apply'),
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
