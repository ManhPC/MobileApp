// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nvs_trading/data/services/generalOTPnoAuth.dart';
import 'package:nvs_trading/presentation/view/shared/otp.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPass extends StatefulWidget {
  NewPass({super.key, this.custodycd});
  String? custodycd;

  @override
  State<NewPass> createState() => _NewPassState();
}

class _NewPassState extends State<NewPass> {
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  bool checkLength = false;
  bool checkCharacter = false;
  bool checkNoSpace = false;

  bool isNewPassEdited = false;
  bool isConfirmPassEdited = false;

  String emptyNew = "Vui lòng nhập mật khẩu mới!";
  String lengthValidate = "Độ dài phải từ 8-32 ký tự!";
  String characterValidate =
      "Mật khẩu phải bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!";
  String noSpaceValidate = "Không bao gồm khoảng trắng.";
  String emptyConfirm = "Vui lòng nhập lại mật khẩu mới!";
  String confirmValidate =
      "Mật khẩu xác nhận không trùng khớp với mật khẩu mới.";

  var a;
  var b;

  String p1 = "FORGOTPASS";

  bool _isObscureNew = false;
  bool _isObscureConfirm = false;

  @override
  void initState() {
    super.initState();
    newPass.addListener(_updateErrorTextNewPass);
    confirmPass.addListener(_updateErrorTextConfirm);
  }

  void _updateErrorTextNewPass() {
    setState(() {
      _errorNewPass;
    });
  }

  void _updateErrorTextConfirm() {
    setState(() {
      _errorConfirm;
    });
  }

  @override
  void dispose() {
    newPass.removeListener(_updateErrorTextNewPass);
    confirmPass.removeListener(_updateErrorTextConfirm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocalizations.forgetPassword('resetpass')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 130,
                  child: customTextStyleBody(
                    text: appLocalizations.forgetPassword('newpass'),
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    txalign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: newPass,
                    obscureText: !_isObscureNew,
                    decoration: InputDecoration(
                      errorText: isNewPassEdited ? _errorNewPass : a,
                      errorMaxLines: 2,
                      errorStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
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
                      hintText: appLocalizations.forgetPassword('enternewpass'),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      suffixIconColor: Colors.grey,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isObscureNew = !_isObscureNew;
                          });
                        },
                        child: _isObscureNew
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
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
                  width: 130,
                  child: customTextStyleBody(
                    text: appLocalizations.forgetPassword('renewpass'),
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    txalign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 180,
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    obscureText: !_isObscureConfirm,
                    controller: confirmPass,
                    decoration: InputDecoration(
                      errorText: isConfirmPassEdited ? _errorConfirm : b,
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
                      hintText:
                          appLocalizations.forgetPassword('enterrenewpass'),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      suffixIconColor: Colors.grey,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isObscureConfirm = !_isObscureConfirm;
                          });
                        },
                        child: _isObscureConfirm
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            customTextStyleBody(
              text: appLocalizations.forgetPassword('msg'),
              size: 16,
              color: Theme.of(context).textTheme.titleSmall!.color!,
            ),
            customTextStyleBody(
              text: "• ${appLocalizations.forgetPassword('check1')}",
              color: isNewPassEdited
                  ? (checkLength
                      ? Colors.green
                      : Theme.of(context).textTheme.titleSmall!.color!)
                  : Theme.of(context).textTheme.titleSmall!.color!,
            ),
            customTextStyleBody(
              text: "• ${appLocalizations.forgetPassword('check2')}",
              color: isNewPassEdited
                  ? (checkCharacter
                      ? Colors.green
                      : Theme.of(context).textTheme.titleSmall!.color!)
                  : Theme.of(context).textTheme.titleSmall!.color!,
            ),
            customTextStyleBody(
              text: "• ${appLocalizations.forgetPassword('check3')}",
              color: isNewPassEdited
                  ? (checkNoSpace
                      ? Colors.green
                      : Theme.of(context).textTheme.titleSmall!.color!)
                  : Theme.of(context).textTheme.titleSmall!.color!,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Theme.of(context).cardColor,
                        )),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: customTextStyleBody(
                    text: appLocalizations.buttonForm('cancel'),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 20,
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
                    setState(() {
                      checkError();
                    });
                  },
                  child: customTextStyleBody(
                    text: appLocalizations.buttonForm('continue'),
                    color: Theme.of(context).buttonTheme.colorScheme!.primary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String? get _errorNewPass {
    final text = newPass.value.text;
    final lengthCheck = RegExp(r'^[\s\S]{8,32}$');
    final characterCheck = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@!#\$%^&*().\[\]])[\s\S]+$');
    final noWhitespaceCheck = RegExp(r'^[^\s]+$');

    int hasError1 = 0;
    int hasError2 = 0;
    int hasError3 = 0;
    int hasError4 = 0;
    if (text.isNotEmpty) {
      isNewPassEdited = true;
    }
    if (text.isEmpty && isNewPassEdited) {
      checkLength = false;
      checkNoSpace = false;
      checkCharacter = false;
      hasError1 = 1;
    }
    if (!lengthCheck.hasMatch(text) && isNewPassEdited) {
      checkLength = false;
      hasError2 = 1;
    } else {
      checkLength = true;
    }
    if (!noWhitespaceCheck.hasMatch(text) && isNewPassEdited) {
      checkNoSpace = false;
      hasError3 = 1;
    } else {
      checkNoSpace = true;
    }
    if (!characterCheck.hasMatch(text) && isNewPassEdited) {
      checkCharacter = false;
      hasError4 = 1;
    } else {
      checkCharacter = true;
    }
    if (hasError1 == 1) {
      return emptyNew;
    } else if (hasError2 == 1) {
      return lengthValidate;
    } else if (hasError3 == 1) {
      return noSpaceValidate;
    } else if (hasError4 == 1) {
      return characterValidate;
    }
    return null;
  }

  String? get _errorConfirm {
    final textNew = newPass.text;
    final text = confirmPass.value.text;
    if (text.isNotEmpty) {
      isConfirmPassEdited = true;
    }
    if (text.isEmpty && isConfirmPassEdited) {
      return emptyConfirm;
    } else if (text != textNew && isConfirmPassEdited) {
      return confirmValidate;
    }
    return null;
  }

  Future<void> checkError() async {
    if (_errorNewPass == null &&
        _errorConfirm == null &&
        newPass.text.isNotEmpty &&
        confirmPass.text.isNotEmpty) {
      final response = await generalOTPnoAuth(p1, widget.custodycd!, "", "");
      print("res: ${response.first.otpId}");
      if (response.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTP(
              options: 'quenPass',
              custodycd: widget.custodycd,
              newPass: newPass.text,
              responseData: response,
              type: p1,
            ),
          ),
        );
      } else {
        print("Loi");
      }
    } else {
      setState(() {
        a = emptyNew;
        b = emptyConfirm;
      });
    }
  }
}
