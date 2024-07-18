// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nvs_trading/data/model/forget_username.dart';
import 'package:nvs_trading/data/services/forgetUsername.dart';
import 'package:nvs_trading/presentation/view/search_account/search_account.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultAccount extends StatefulWidget {
  ResultAccount(
      {super.key,
      required this.idCode,
      required this.otpId,
      required this.otpCode,
      required this.phone});
  String idCode;
  String otpId;
  String otpCode;
  String phone;

  @override
  State<ResultAccount> createState() => _ResultAccountState();
}

class _ResultAccountState extends State<ResultAccount> {
  late Future<List<ForgotUsername>> _resultFuture;

  @override
  void initState() {
    super.initState();
    _resultFuture = forgotUserName(
      widget.idCode,
      widget.otpId,
      widget.otpCode,
      widget.phone,
    );
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocalizations.searchAccount('searchaccount')),
      body: FutureBuilder(
        future: _resultFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final accountResult = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).cardColor),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTextStyleBody(
                        text: appLocalizations.searchAccount('accountnumber'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        width: 150,
                        child: customTextStyleBody(
                          text: accountResult.first.custodycd,
                          txalign: TextAlign.start,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTextStyleBody(
                        text: appLocalizations.searchAccount('accountname'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        width: 150,
                        child: customTextStyleBody(
                          text: accountResult.first.fullname,
                          txalign: TextAlign.start,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor:
                          Theme.of(context).buttonTheme.colorScheme!.background,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SearchAccount()),
                      );
                    },
                    child: customTextStyleBody(
                      text: appLocalizations.buttonForm('confirm'),
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
