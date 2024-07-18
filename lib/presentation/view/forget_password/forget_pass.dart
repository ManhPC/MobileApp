import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nvs_trading/data/services/validateForgotPass.dart';
import 'package:nvs_trading/presentation/view/forget_password/new_pass.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  TextEditingController custodycd = TextEditingController();
  TextEditingController idCode = TextEditingController();

  bool isCustodyEdited = false;
  bool isIdCodeEdited = false;
  late FToast fToast;

  var a;
  var b;

  String custodyValidate = "Không được để trống";
  String idCodeValidate = "Không được để trống";
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    custodycd.addListener(_updateErrorTextCustody);
    idCode.addListener(_updateErrorTextIdCode);
  }

  void _updateErrorTextCustody() {
    setState(() {
      _errorCustody;
    });
  }

  void _updateErrorTextIdCode() {
    setState(() {
      _errorIdCode;
    });
  }

  @override
  void dispose() {
    custodycd.removeListener(_updateErrorTextCustody);
    idCode.removeListener(_updateErrorTextIdCode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocalizations.forgetPassword('forgotpassword')),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: customTextStyleBody(
                    text: appLocalizations.forgetPassword('accountnumber'),
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    txalign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: custodycd,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      errorText: isCustodyEdited ? _errorCustody : a,
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
                      hintText:
                          appLocalizations.forgetPassword('accountnumber'),
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
                    text: appLocalizations.forgetPassword('idcard'),
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    txalign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: idCode,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      errorText: isIdCodeEdited ? _errorIdCode : b,
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
                      hintText: appLocalizations.forgetPassword('idcard'),
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
                text: appLocalizations.buttonForm('continue'),
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? get _errorCustody {
    final text = custodycd.value.text;
    if (text.isNotEmpty) {
      isCustodyEdited = true;
    }
    if (text.isEmpty && isCustodyEdited) {
      return custodyValidate;
    }
    return null;
  }

  String? get _errorIdCode {
    final text = idCode.value.text;
    if (text.isNotEmpty) {
      isIdCodeEdited = true;
    }
    if (text.isEmpty && isIdCodeEdited) {
      return idCodeValidate;
    }
    return null;
  }

  Future<void> checkError() async {
    if (_errorCustody == null &&
        _errorIdCode == null &&
        custodycd.text.isNotEmpty &&
        idCode.text.isNotEmpty) {
      final responseData =
          await ValidateForgotPass(custodycd.text, idCode.text);
      if (responseData!.statusCode == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewPass(custodycd: custodycd.text)));
      } else {
        fToast.showToast(
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 2),
          child: msgNotification(
            color: Colors.red,
            icon: Icons.cancel,
            text: "Thất bại\n${responseData.data['message']}",
          ),
        );
      }
    } else {
      setState(() {
        a = custodyValidate;
        b = idCodeValidate;
      });
    }
  }
}
