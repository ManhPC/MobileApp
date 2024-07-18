// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getSmsSettingList.dart';
import 'package:nvs_trading/data/services/updateSmsSetting.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingSms extends StatefulWidget {
  const SettingSms({super.key});

  @override
  State<SettingSms> createState() => _SettingSmsState();
}

class _SettingSmsState extends State<SettingSms> {
  bool BDSDT = false;
  bool BDSDCK = false;
  bool TBKL = false;
  bool TTTK = false;
  bool TBDV = false;

  String Content1 = "";
  String Content2 = "";
  String Content3 = "";
  String Content4 = "";
  String Content5 = "";

  late List<dynamic> getListSms;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    fetchData();
  }

  void fetchData() async {
    try {
      final response = await GetSMSSettingList(
        HydratedBloc.storage.read('custodycd'),
        HydratedBloc.storage.read('token'),
      );

      if (response.isNotEmpty) {
        setState(() {
          String settingcode = response[0]['settingcode'];
          BDSDT = settingcode[0] == 'Y';
          BDSDCK = settingcode[1] == 'Y';
          TBKL = settingcode[2] == 'Y';
          TTTK = settingcode[3] == 'Y';
          TBDV = settingcode[4] == 'Y';
        });
      }
      // print(response.first['settingcode']);
      // print(BDSDT);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocalizations.smssetting('smssetting')),
      body: FutureBuilder(
        future:
            GetAllCode("API", "SMSSETTING", HydratedBloc.storage.read('token')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<dynamic> data = snapshot.data!;
            for (var i in data) {
              switch (i['cdval']) {
                case '0':
                  Content1 = i['vN_CDCONTENT'];
                case '1':
                  Content2 = i['vN_CDCONTENT'];
                case '2':
                  Content3 = i['vN_CDCONTENT'];
                case '3':
                  Content4 = i['vN_CDCONTENT'];
                case '4':
                  Content5 = i['vN_CDCONTENT'];
              }
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customTextStyleBody(
                            text: appLocalizations.smssetting('smssetting'),
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                          customTextStyleBody(
                            text: appLocalizations.smssetting('msg'),
                            size: 14,
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            txalign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      width: double.infinity,
                      height: 46,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: Content1.split('|').first,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                          Checkbox(
                            value: BDSDT,
                            onChanged: (bool? value) {
                              setState(() {
                                BDSDT = value!;
                              });
                            },
                            activeColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .background,
                            checkColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      width: double.infinity,
                      height: 46,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: Content2.split('|').first,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                          Checkbox(
                            value: BDSDCK,
                            onChanged: (bool? value) {
                              setState(() {
                                BDSDCK = value!;
                              });
                            },
                            activeColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .background,
                            checkColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      width: double.infinity,
                      height: 46,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: Content3.split('|').first,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                          Checkbox(
                            value: TBKL,
                            onChanged: (bool? value) {
                              setState(() {
                                TBKL = value!;
                              });
                            },
                            activeColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .background,
                            checkColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      width: double.infinity,
                      height: 46,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: Content4.split('|').first,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                          Checkbox(
                            value: TTTK,
                            onChanged: (bool? value) {
                              setState(() {
                                TTTK = value!;
                              });
                            },
                            activeColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .background,
                            checkColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      width: double.infinity,
                      height: 46,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: Content5.split('|').first,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                          Checkbox(
                            value: TBDV,
                            onChanged: (bool? value) {
                              setState(() {
                                TBDV = value!;
                              });
                            },
                            activeColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .background,
                            checkColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomSheet: Container(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).buttonTheme.colorScheme!.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            String code = "";
            if (BDSDT) {
              code += "Y";
            } else {
              code += "N";
            }
            if (BDSDCK) {
              code += "Y";
            } else {
              code += "N";
            }
            if (TBKL) {
              code += "Y";
            } else {
              code += "N";
            }
            if (TTTK) {
              code += "Y";
            } else {
              code += "N";
            }
            if (TBDV) {
              code += "Y";
            } else {
              code += "N";
            }
            final updateSms = await updateSmsSetting(
              code,
              HydratedBloc.storage.read('custodycd'),
              HydratedBloc.storage.read('token'),
            );
            if (updateSms == 200) {
              fToast.showToast(
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(seconds: 2),
                child: msgNotification(
                  color: Colors.green,
                  icon: Icons.check_circle,
                  text: "Thành công \nĐăng kí SMS thành công",
                ),
              );
              fetchData();
            }
          },
          child: customTextStyleBody(
            text: appLocalizations.buttonForm('confirm'),
            size: 14,
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
        ),
      ),
    );
  }
}
