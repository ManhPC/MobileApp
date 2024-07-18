import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/services/generalOTP.dart';
import 'package:nvs_trading/presentation/view/shared/otp.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class ChangePasswordTransaction extends StatefulWidget {
  const ChangePasswordTransaction({super.key});

  @override
  State<ChangePasswordTransaction> createState() =>
      _ChangePasswordTransactionState();
}

class _ChangePasswordTransactionState extends State<ChangePasswordTransaction> {
  String token = HydratedBloc.storage.read('token');
  bool _isObscureCurrent = false;
  bool _isObscureNew = false;
  bool _isObscureAuth = false;

  TextEditingController oldPass = TextEditingController();
  var a;
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  bool isOldPassEdited = false;
  bool isNewPassEdited = false;
  bool isConfirmPassEdited = false;

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    oldPass.addListener(checkOldPass);
    newPass.addListener(checkNewPass);
    confirmPass.addListener(checkConfirmPass);
  }

  void checkOldPass() {
    setState(() {
      _errorOldPass;
    });
  }

  void checkNewPass() {
    setState(() {
      _errorNewPass;
    });
  }

  void checkConfirmPass() {
    setState(() {
      _errorConfirmPass;
    });
  }

  @override
  void dispose() {
    oldPass.removeListener(checkOldPass);
    newPass.removeListener(checkNewPass);
    confirmPass.removeListener(checkConfirmPass);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: ""),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: customTextStyleBody(
                text: "Đổi mật khẩu giao dịch",
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextStyleBody(
                  text: "Mật khẩu hiện tại",
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  fontWeight: FontWeight.w400,
                  size: 14,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: TextField(
                    controller: oldPass,
                    cursorColor: Theme.of(context).primaryColor,
                    obscureText: !_isObscureCurrent,
                    decoration: InputDecoration(
                      hintText: "Nhập mật khẩu hiện tại",
                      hintStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      errorText: isOldPassEdited ? _errorOldPass : a,
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
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
                    text: "Mật khẩu mới",
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    size: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    child: TextField(
                      controller: newPass,
                      cursorColor: Theme.of(context).primaryColor,
                      obscureText: !_isObscureNew,
                      maxLength: 6,
                      buildCounter: (BuildContext context,
                              {int? currentLength,
                              int? maxLength,
                              bool? isFocused}) =>
                          null,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: "Nhập mật khẩu mới",
                        hintStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 12,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
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
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        errorText: isNewPassEdited ? _errorNewPass : a,
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                        ),
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
                  text: "Xác thực mật khẩu mới",
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                  size: 14,
                  fontWeight: FontWeight.w400,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: TextField(
                    controller: confirmPass,
                    cursorColor: Theme.of(context).primaryColor,
                    obscureText: !_isObscureAuth,
                    maxLength: 6,
                    buildCounter: (BuildContext context,
                            {int? currentLength,
                            int? maxLength,
                            bool? isFocused}) =>
                        null,
                    decoration: InputDecoration(
                      hintText: "Nhập lại mật khẩu mới",
                      hintStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      errorText: isConfirmPassEdited ? _errorConfirmPass : a,
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                      ),
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
                    "*Lưu ý: Mật khẩu phải từ 6 ký tự số và không có ký tự đặc biệt. Mật khẩu mới không được trùng với mật khẩu hiện tại.",
                txalign: TextAlign.start,
                color: const Color(0xFFEE7420),
              ),
            ),
          ],
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
          onPressed: () async {
            if (_errorOldPass == null &&
                _errorNewPass == null &&
                _errorConfirmPass == null &&
                oldPass.text.isNotEmpty &&
                newPass.text.isNotEmpty &&
                confirmPass.text.isNotEmpty) {
              final res = await generalOTPAuth("CHANGEPASSTRAN", oldPass.text,
                  newPass.text, confirmPass.text, token);
              if (res.isEmpty) {
                fToast.showToast(
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(seconds: 2),
                  child: msgNotification(
                    color: Colors.red,
                    icon: Icons.error,
                    text: "[-100114]: Sai mật khẩu giao dịch!",
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OTP(
                      options: "change_pass_trans",
                      responseData: res,
                      oldPass: oldPass.text,
                      newPass: newPass.text,
                      confirmPass: confirmPass.text,
                      type: "CHANGEPASSTRAN",
                    ),
                  ),
                );
              }
            } else {
              setState(() {
                a = "Không được để trống";
              });
            }
          },
          child: customTextStyleBody(
            text: "Xác nhận",
            size: 14,
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
        ),
      ),
    );
  }

  String? get _errorOldPass {
    final text = oldPass.value.text;
    final noWhitespaceCheck = RegExp(r'^[^\s]+$');
    final characterCheck = RegExp(r'^(?=.*[@!#\$%^&*().\[\]])[\s\S]+$');
    if (text.isNotEmpty) {
      isOldPassEdited = true;
    }
    if (text.isEmpty && isOldPassEdited) {
      return "Không được để trống";
    } else if (!noWhitespaceCheck.hasMatch(text) && isOldPassEdited) {
      return "Không được để khoảng trắng";
    } else if (characterCheck.hasMatch(text) && isOldPassEdited) {
      return "Không được nhập ký tự đặc biệt";
    }
    return null;
  }

  String? get _errorNewPass {
    final text = newPass.value.text;
    final text2 = oldPass.value.text;
    if (text.isNotEmpty) {
      isNewPassEdited = true;
    }

    if (text.isEmpty && isNewPassEdited) {
      return "Không được để trống";
    } else if (text == text2 && isNewPassEdited) {
      return "Mật khẩu mới không được trùng với mật khẩu cũ!";
    } else if (text.length < 6 && isNewPassEdited) {
      return "Mật khẩu giao dịch phải gồm 6 ký tự số!";
    }
    return null;
  }

  String? get _errorConfirmPass {
    final text = confirmPass.value.text;
    final text2 = newPass.value.text;
    if (text.isNotEmpty) {
      isConfirmPassEdited = true;
    }
    if (text.isEmpty && isConfirmPassEdited) {
      return "Không được để trống";
    } else if (text != text2 && isConfirmPassEdited) {
      return "Mật khẩu xác nhận không trùng khớp với mật khẩu mới.";
    }
    return null;
  }
}
