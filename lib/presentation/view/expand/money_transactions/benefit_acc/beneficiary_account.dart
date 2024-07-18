import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/bank_acctno_info.dart';
import 'package:nvs_trading/data/services/actionWithBankAccount.dart';
import 'package:nvs_trading/data/services/getBankAcctnoInfo.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/benefit_acc/benef_acc_2.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/transfer_money_out/transfer_money_out_bank.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BeneficiaryAccount extends StatefulWidget {
  const BeneficiaryAccount({super.key});

  @override
  State<BeneficiaryAccount> createState() => _BeneficiaryAccountState();
}

class _BeneficiaryAccountState extends State<BeneficiaryAccount> {
  List<String> label = [
    'STT',
    'Ngân hàng',
    'STK ngân hàng',
    'Tên chủ TK',
    'Thao tác',
  ];
  String acctno = HydratedBloc.storage.read('acctno');
  String custodycd = HydratedBloc.storage.read('custodycd');
  List<BankAcctnoInfo> listBankAI = [];

  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    fetchAccountInfo();
  }

  Future<void> fetchAccountInfo() async {
    try {
      final response = await getBankAcctnoInfo(acctno, 'ALL', 'ALL');
      setState(() {
        listBankAI = response;
      });
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: local.beneficAccount('benefAccount')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: customTextStyleBody(
                text: local.beneficAccount('LORA'),
                size: 16,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            for (var i in listBankAI)
              Container(
                margin: const EdgeInsets.only(
                  bottom: 24,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 10, top: 18, bottom: 18),
                          child: SvgPicture.asset(
                            "assets/svg/bank/${i.bankId}.svg",
                            width: 24,
                            height: 24,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextStyleBody(
                              text: i.fullName,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                            Row(
                              children: [
                                customTextStyleBody(
                                  text: "${i.bankId} | ",
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                customTextStyleBody(
                                  text: i.bankAccount,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TransferMoneyOutBank(
                                  bankId: i.bankId,
                                ),
                              ),
                            );
                          },
                          child: SvgPicture.asset('assets/icons/cash.svg'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final response = await deleteBankAccount(
                                i.bankAccount, i.bankId, custodycd);
                            if (response.statusCode == 200) {
                              if (response.data['code'] == 200) {
                                fToast.showToast(
                                  gravity: ToastGravity.TOP,
                                  toastDuration: const Duration(seconds: 2),
                                  child: msgNotification(
                                    color: Colors.green,
                                    icon: Icons.check_circle,
                                    text: response.data['message'],
                                  ),
                                );

                                await fetchAccountInfo();
                                setState(() {});
                              } else {
                                fToast.showToast(
                                  gravity: ToastGravity.TOP,
                                  toastDuration: const Duration(seconds: 2),
                                  child: msgNotification(
                                    color: Colors.red,
                                    icon: Icons.error,
                                    text: response.data['message'],
                                  ),
                                );
                              }
                            } else {
                              print(response.statusCode);
                            }
                          },
                          child: SvgPicture.asset('assets/icons/delete.svg'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).buttonTheme.colorScheme!.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const BenefAcc2(),
              ),
            );
            print(result);
            if (result == true) {
              await fetchAccountInfo();
              setState(() {});
            }
          },
          child: customTextStyleBody(
            text: local.beneficAccount('addBenAcc'),
            size: 14,
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
        ),
      ),
    );
  }
}
