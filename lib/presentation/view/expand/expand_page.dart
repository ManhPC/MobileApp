import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nvs_trading/presentation/theme/themeProvider.dart';
import 'package:nvs_trading/presentation/view/authentication/authentication_bloc.dart';
import 'package:nvs_trading/presentation/view/authentication/authentication_event.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/account_info.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/change_password_login.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/change_password_transaction.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/digital_sign_info/digital_sign_info.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/finger_print/finger_print.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/finger_print/finger_print_bloc.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/language.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/loss_warning/loss_warning.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/setting_sms.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/bank_account_link.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/benefit_acc/beneficiary_account.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/money_statement_history.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/payment_on_account/payment_on_account.dart';
import 'package:nvs_trading/presentation/view/expand/QuanLyDuNo/tra_no.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/transfer_money_in/transfer_money_in.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/transfer_money_out/transfer_money_out_bank.dart';
import 'package:nvs_trading/presentation/view/expand/rights_trading/register/register_rights.dart';
import 'package:nvs_trading/presentation/view/expand/rights_trading/search/search_rights.dart';
import 'package:nvs_trading/presentation/view/expand/smart_otp/doimaPin/changeOTP.dart';
import 'package:nvs_trading/presentation/view/expand/smart_otp/deliveryOTP.dart';
import 'package:nvs_trading/presentation/view/expand/smart_otp/getOTP.dart';
import 'package:nvs_trading/presentation/view/expand/smart_otp/thietlapmaPin/registerOTP.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/list_send_money/list_send_money.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/partner_bank.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/request_send_money/request_send_money.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/search_interest_rate.dart';
import 'package:nvs_trading/presentation/view/expand/transfer_stock/transfer_stock.dart';
import 'package:nvs_trading/presentation/view/expand/transfer_stock/transfer_stock_history.dart';
import 'package:nvs_trading/presentation/view/shared/otp.dart';
import 'package:nvs_trading/presentation/widget/chooseAcctno.dart';

import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';

class ExtendPage extends StatefulWidget {
  const ExtendPage({super.key});

  @override
  State<ExtendPage> createState() => _ExtendPageState();
}

class _ExtendPageState extends State<ExtendPage> {
  int _chooseIndex = 0;

  List<String> contentList = [
    "moneyTrans",
    "transferStock",
    "rightTrading",
    "termdeposit",
    "settings",
    "smartotp",
  ];

  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    double sizeButton = MediaQuery.of(context).size.width / 6;
    bool themeMode = Provider.of<ThemeProvider>(context).isDarkMode;
    var appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: customTextStyleAppbar(
          text: appLocalizations!.expandForm('expand'),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const ChooseAcctno(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 7.75, left: 7.75),
            child: Image.asset(
              "assets/icons/Combined Shape.png",
              color: const Color(0xff595e72),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                });
              },
              child: themeMode
                  ? const Icon(Icons.dark_mode)
                  : const Icon(
                      Icons.light_mode,
                      color: Colors.yellow,
                    ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: SearchBar(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/icons/ic_search.svg",
                    width: 20,
                    height: 20,
                  ),
                ),
                hintText: appLocalizations.expandForm('search'),
                hintStyle: const MaterialStatePropertyAll(
                  TextStyle(
                    color: Color(0xFF797F8A),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(contentList.length, (index) {
                    return TextButton(
                      onPressed: () {
                        setState(() {
                          _chooseIndex = index;
                        });
                        _scrollToText(index);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => (_chooseIndex == index)
                                ? Theme.of(context).colorScheme.tertiary
                                : Colors.transparent),
                        shape: MaterialStateProperty.resolveWith(
                          (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      child: customTextStyleBody(
                        text: appLocalizations.expandForm(contentList[index]),
                        fontWeight: FontWeight.w400,
                        color: (_chooseIndex == index)
                            ? const Color(0xFFE7AB21)
                            : Theme.of(context).primaryColor,
                      ),
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyleBody(
                        text: appLocalizations.expandForm(contentList[0]),
                        size: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildButtonColumn(
                                  appLocalizations.expandList1Form('dmiaa'),
                                  "assets/icons/NTVTK.png", () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentOnAccount()));
                              }),
                              buildButtonColumn(
                                  appLocalizations.expandList1Form('laba'),
                                  "assets/icons/LKTKNH.png", () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const BankAccountLink()));
                              }),
                              buildButtonColumn(
                                  appLocalizations.expandList1Form('tmtb'),
                                  "assets/icons/CTRNH.png", () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        TransferMoneyOutBank()));
                              }),
                              buildButtonColumn(
                                  appLocalizations.expandList1Form('imt'),
                                  "assets/icons/CTNB.png", () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const TransferMoneyIn()));
                              }),
                            ],
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildButtonColumn(
                                appLocalizations.expandList1Form('ba'),
                                "assets/icons/TKThuHuong.png", () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const BeneficiaryAccount()));
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList1Form('cr'),
                                "assets/icons/SaoKeTien.png", () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const MoneyStatement()));
                            }),
                            buildButtonColumn(
                                "Quản lý dư nợ", "assets/icons/SaoKeTien.png",
                                () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: ((context) => const TraNo()),
                                ),
                              );
                            }),
                            SizedBox(width: sizeButton + 10), // Khoảng trống
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyleBody(
                        text: appLocalizations.expandForm(contentList[1]),
                        size: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildButtonColumn(
                                appLocalizations.expandList2Form('ts'),
                                "assets/icons/transfer 1.png", () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const TransferStock()));
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList2Form('sth'),
                                "assets/icons/restore 1.png", () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const TransferStockHis()));
                            }),
                            SizedBox(width: sizeButton + 10), // Khoảng trống
                            SizedBox(width: sizeButton + 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyleBody(
                        text: appLocalizations.expandForm(contentList[2]),
                        size: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildButtonColumn(
                                appLocalizations.expandList3Form('lup'),
                                "assets/icons/preview 1.png", () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SearchRight()));
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList3Form('ryrtb'),
                                "assets/icons/poetry 1.png", () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const RegisterRight()));
                            }),
                            SizedBox(width: sizeButton + 10), // Khoảng trống
                            SizedBox(width: sizeButton + 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyleBody(
                        text: appLocalizations.expandForm(contentList[3]),
                        size: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildButtonColumn(
                                appLocalizations.expandList4Form('pb'),
                                "assets/icons/bank 1.png", () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const PartnerBank()));
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList4Form('luir'),
                                "assets/icons/report 1.png", () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const InterestRate()));
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList4Form('madr'),
                                "assets/icons/contract 1.png", () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RequestSendMoney(
                                    bankName: "",
                                    kyhan: "",
                                  ),
                                ),
                              );
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList4Form('lod'),
                                "assets/icons/to-do-list 1.png", () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ListSendMoney()));
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyleBody(
                        text: appLocalizations.expandForm(contentList[4]),
                        size: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildButtonColumn(
                                appLocalizations.expandList5Form('language'),
                                "assets/icons/global 1.png", () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Language(),
                                ),
                              );
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList5Form('bs'),
                                "assets/icons/fingerprint-scan 1.png", () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => FingerPrintBloc(),
                                    child: const FingerPrint(),
                                  ),
                                ),
                              );
                            }),
                            buildButtonColumn(
                              appLocalizations.expandList5Form('clp'),
                              "assets/icons/lock 1.png",
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordLogin(),
                                  ),
                                );
                              },
                            ),
                            buildButtonColumn(
                              appLocalizations.expandList5Form('ctp'),
                              "assets/icons/password 1.png",
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordTransaction(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildButtonColumn(
                                appLocalizations.expandList5Form('lw'),
                                "assets/icons/warning 1.png", () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LossWarning(),
                                ),
                              );
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList5Form('smss'),
                                "assets/icons/open-letters 1.png", () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingSms(),
                                ),
                              );
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList5Form('pi'),
                                "assets/icons/user 1.png", () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AccountInfo(),
                                ),
                              );
                            }),
                            buildButtonColumn(
                                appLocalizations.expandList5Form('dsi'),
                                "assets/icons/signature 1.png", () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const DigitalSignInfo(),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyleBody(
                        text: appLocalizations.expandForm(contentList[5]),
                        size: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildButtonColumn(
                              appLocalizations.expandList6Form('rso'),
                              "assets/icons/otp 1.png",
                              () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterOTP(typeOTP: 'register')));
                              },
                            ),
                            buildButtonColumn(
                              appLocalizations.expandList6Form('go'),
                              "assets/icons/padlock 1.png",
                              () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const GetOTP()));
                              },
                            ),
                            buildButtonColumn(
                              appLocalizations.expandList6Form('do'),
                              "assets/icons/password (1) 1.png",
                              () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const DeliveryOTP()));
                              },
                            ),
                            buildButtonColumn(
                              appLocalizations.expandList6Form('cso'),
                              "assets/icons/password (2) 1.png",
                              () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ChangeOTP()));
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildButtonColumn(
                              appLocalizations.expandList6Form('fso'),
                              "assets/icons/lock (1) 1.png",
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OTP(
                                      options: 'quenmaPin',
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: sizeButton + 10),
                            SizedBox(width: sizeButton + 10), // Khoảng trống
                            SizedBox(width: sizeButton + 10),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(LoggedOut());
                          },
                          child: customTextStyleBody(
                            text: "Đăng xuất",
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
  }

  void _scrollToText(int index) {
    double offset = 0;
    if (index == 1) {
      for (int i = 0; i < index; i++) {
        offset += 260;
      }
    } else if (index == 2) {
      for (int i = 0; i < index; i++) {
        offset += 200;
      }
    } else if (index == 3) {
      for (int i = 0; i < index; i++) {
        offset += 180;
      }
    } else if (index == 4) {
      for (int i = 0; i < index + 1; i++) {
        offset += 134.5;
      }
    } else {
      for (int i = 0; i < index; i++) {
        offset += 134.5;
      }
    }

    _scrollController.animateTo(offset,
        duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  Widget buildButtonColumn(String label, String name, VoidCallback onTap) {
    return Flexible(
      fit: FlexFit.loose,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 6 + 20,
        height: MediaQuery.of(context).size.width / 7 + 40,
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                height: MediaQuery.of(context).size.width / 7,
                width: MediaQuery.of(context).size.width / 7,
                decoration: BoxDecoration(
                  // color: const Color(0xFF292D38),
                  color:
                      Theme.of(context).buttonTheme.colorScheme!.onBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.asset(
                  name,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: customTextStyleBody(
                text: label,
                size: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColor,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
