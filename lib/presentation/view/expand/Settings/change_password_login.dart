// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/services/generalOTP.dart';
import 'package:nvs_trading/presentation/view/shared/otp.dart';

import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordLogin extends StatefulWidget {
  const ChangePasswordLogin({super.key});

  @override
  State<ChangePasswordLogin> createState() => _ChangePasswordLoginState();
}

class _ChangePasswordLoginState extends State<ChangePasswordLogin> {
  bool _isObscureCurrent = false;
  bool _isObscureNew = false;
  bool _isObscureAuth = false;

  String p1 = "CHANGEPASS";

  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmNewPass = TextEditingController();

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
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    newPass.addListener(_updateErrorTextNewPass);
    confirmNewPass.addListener(_updateErrorTextConfirm);
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
    confirmNewPass.removeListener(_updateErrorTextConfirm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: ""),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: customTextStyleBody(
                    text: appLocalizations.changeLoginPass('title'),
                    size: 20,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextStyleBody(
                      text: appLocalizations.changeLoginPass('oldpass'),
                      size: 14,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: TextField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: oldPass,
                        obscureText: !_isObscureCurrent,
                        decoration: InputDecoration(
                          hintText: appLocalizations.changeLoginPass('oldpass'),
                          hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 12,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
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
                          suffixIcon: GestureDetector(
                            child: Icon(
                              _isObscureCurrent
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 16,
                              color: const Color(0xFF797F8A),
                            ),
                            onTap: () {
                              setState(() {
                                _isObscureCurrent = !_isObscureCurrent;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyleBody(
                        text: appLocalizations.changeLoginPass('newpass'),
                        size: 14,
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        child: TextField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: newPass,
                          obscureText: !_isObscureNew,
                          decoration: InputDecoration(
                            errorText: isNewPassEdited ? _errorNewPass : a,
                            errorStyle: const TextStyle(
                                fontSize: 10, color: Colors.red),
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
                              borderRadius: BorderRadius.circular(4),
                            ),
                            isDense: true,
                            hintText:
                                appLocalizations.changeLoginPass('newpass'),
                            hintStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 12,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            suffixIcon: GestureDetector(
                              child: Icon(
                                _isObscureNew
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 16,
                                color: const Color(0xFF797F8A),
                              ),
                              onTap: () {
                                setState(() {
                                  _isObscureNew = !_isObscureNew;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextStyleBody(
                      text: appLocalizations.changeLoginPass('renewpass'),
                      size: 14,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: TextField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: confirmNewPass,
                        obscureText: !_isObscureAuth,
                        decoration: InputDecoration(
                          errorText: isConfirmPassEdited ? _errorConfirm : b,
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
                            borderRadius: BorderRadius.circular(4),
                          ),
                          isDense: true,
                          hintText:
                              appLocalizations.changeLoginPass('renewpass'),
                          hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 12,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          suffixIcon: GestureDetector(
                            child: Icon(
                              _isObscureAuth
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 16,
                              color: const Color(0xFF797F8A),
                            ),
                            onTap: () {
                              setState(() {
                                _isObscureAuth = !_isObscureAuth;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: customTextStyleBody(
                    text:
                        "*${appLocalizations.changeLoginPass('note')}${appLocalizations.changeLoginPass('exception')}",
                    txalign: TextAlign.start,
                    color: const Color(0xFFEE7420),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).buttonTheme.colorScheme!.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            checkError();
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
    final text = confirmNewPass.value.text;
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
        confirmNewPass.text.isNotEmpty) {
      final res = await generalOTPAuth(
        p1,
        oldPass.text,
        newPass.text,
        confirmNewPass.text,
        HydratedBloc.storage.read('token'),
      );
      if (res.isNotEmpty) {
        print("res: ${res.first.otpId}");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTP(
              options: "change_pass_login",
              responseData: res,
              oldPass: oldPass.text,
              newPass: newPass.text,
              confirmPass: confirmNewPass.text,
              type: p1,
            ),
          ),
        );
      } else {
        print("Loi");
        fToast.showToast(
          child: msgNotification(
            color: Colors.red,
            icon: Icons.cancel,
            text: "Sai mật khẩu!",
          ),
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 2),
        );
      }
    } else {
      setState(() {
        a = emptyNew;
        b = emptyConfirm;
      });
    }
  }
}
