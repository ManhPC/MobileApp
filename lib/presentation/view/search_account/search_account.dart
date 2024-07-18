// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nvs_trading/data/services/generalOTPnoAuth.dart';
import 'package:nvs_trading/presentation/view/shared/otp.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchAccount extends StatefulWidget {
  const SearchAccount({super.key});

  @override
  State<SearchAccount> createState() => _SearchAccountState();
}

class _SearchAccountState extends State<SearchAccount> {
  TextEditingController idCode = TextEditingController();
  TextEditingController phone = TextEditingController();

  String idCodeValidate = "Số CCCD/CMND không được để trống";
  String idCodeValidate1 = "Chỉ nhập số và có độ dài 9 hoặc 12 số";
  String phoneNumberValidate = "Số điện thoại không được để trống";
  String phoneNumberValidate1 = "Chỉ nhập số và có độ dài 10 số";
  var a;
  var b;

  bool idCodeEdited = false;
  bool phoneNumberEdited = false;
  String p1 = 'FORGOTUSERNAME';

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    idCode.addListener(_updateIdCode);
    phone.addListener(_updatePhone);
  }

  void _updateIdCode() {
    setState(() {
      _errorIdCode;
    });
  }

  void _updatePhone() {
    setState(() {
      _errorPhoneNumber;
    });
  }

  @override
  void dispose() {
    idCode.removeListener(_updateIdCode);
    phone.removeListener(_updatePhone);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocalizations.searchAccount('searchaccount')),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).cardColor),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customTextStyleBody(
              text: appLocalizations.searchAccount('message'),
              color: Theme.of(context).primaryColor,
              txalign: TextAlign.start,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: customTextStyleBody(
                    text: appLocalizations.searchAccount('idcard'),
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    txalign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: idCode,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      errorText: idCodeEdited ? _errorIdCode : a,
                      errorMaxLines: 2,
                      errorStyle:
                          const TextStyle(fontSize: 10, color: Colors.red),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      hintText: appLocalizations.searchAccount('idcard'),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                    ),
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
                SizedBox(
                  width: 100,
                  child: customTextStyleBody(
                    text: appLocalizations.searchAccount('phone'),
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    txalign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: phone,
                    decoration: InputDecoration(
                      errorText: phoneNumberEdited ? _errorPhoneNumber : b,
                      errorMaxLines: 2,
                      errorStyle:
                          const TextStyle(fontSize: 10, color: Colors.red),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      hintText: appLocalizations.searchAccount('phone'),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                    ),
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
                checkError();
              },
              child: customTextStyleBody(
                text: appLocalizations.searchAccount('button'),
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? get _errorIdCode {
    final text = idCode.value.text;
    RegExp regex = RegExp(r'^\d{9}(?:\d{3})?$');
    if (text.isNotEmpty) {
      idCodeEdited = true;
    }
    if (text.isEmpty && idCodeEdited) {
      return idCodeValidate;
    } else if (!regex.hasMatch(text)) {
      return idCodeValidate1;
    }
    return null;
  }

  String? get _errorPhoneNumber {
    final text = phone.value.text;
    RegExp regex = RegExp(r'^\d{10}$');
    if (text.isNotEmpty) {
      phoneNumberEdited = true;
    }
    if (text.isEmpty && phoneNumberEdited) {
      return phoneNumberValidate;
    } else if (!regex.hasMatch(text) && phoneNumberEdited) {
      return phoneNumberValidate1;
    }
    return null;
  }

  Future<void> checkError() async {
    // check them neu can|| RegExp(r'[a-zA-Z]').hasMatch(idCode.text)

    if (_errorIdCode == null &&
        _errorPhoneNumber == null &&
        idCode.text.isNotEmpty &&
        phone.text.isNotEmpty) {
      final response = await generalOTPnoAuth(p1, idCode.text, phone.text, " ");
      if (response.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTP(
              options: 'tracuuSTK',
              idCode: idCode.text,
              phone: phone.text,
              responseData: response,
              type: p1,
            ),
          ),
        );
      } else {
        fToast.showToast(
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 2),
          child: msgNotification(
            color: Colors.red,
            icon: Icons.cancel,
            text: "Thất bại",
          ),
        );
      }
    } else {
      setState(() {
        a = idCodeValidate;
        b = phoneNumberValidate;
      });
    }
  }
}
