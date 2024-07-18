// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/data/model/account_info.dart';
import 'package:nvs_trading/presentation/view/provider/getInfoAccount.dart';
import 'package:nvs_trading/data/services/CA-SignRegis.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DangKyDigitalSign extends StatefulWidget {
  DangKyDigitalSign({
    super.key,
    required this.pageController,
  });

  PageController pageController;

  @override
  State<DangKyDigitalSign> createState() => _DangKyDigitalSignState();
}

class _DangKyDigitalSignState extends State<DangKyDigitalSign> {
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isObscure = false;

  bool isStartDateEdited = false;
  bool isEndDateEdited = false;
  bool isUsernameEdited = false;
  bool isPasswordEdited = false;
  bool isClickConfirm = false;

  String usernameValidate = "Không được để trống";
  String passwordValidate = "Không được để trống";
  String startDateEmpty = "Từ ngày không được để trống";
  String endDateEmpty = "Đến ngày không được để trống";
  String startDateValidate = "Phải nhỏ hơn hoặc bằng đến ngày";
  String endDateValidate = "Phải lớn hơn hoặc bằng từ ngày";

  var a;
  var b;
  var c;
  var d;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    userId.addListener(checkUserId);
    password.addListener(checkPassword);
    _startDate.addListener(checkStartDate);
    _endDate.addListener(checkEndDate);
  }

  void checkStartDate() {
    setState(() {
      errorStartDate;
    });
  }

  void checkEndDate() {
    setState(() {
      errorEndDate;
    });
  }

  void checkUserId() {
    setState(() {
      _errorUsername;
    });
  }

  void checkPassword() {
    setState(() {
      _errorPassword;
    });
  }

  @override
  void dispose() {
    userId.removeListener(checkUserId);
    password.removeListener(checkPassword);
    _startDate.removeListener(checkStartDate);
    _endDate.removeListener(checkEndDate);
    super.dispose();
  }

  String selectedStatus = "N";
  String UserInfo = "";
  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    final response = Provider.of<GetInfoAccount>(context).getInfoAccount;
    return FutureBuilder(
      future: response,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.blue,
          );
        }
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          final responseInfo = snapshot.data!;
          UserInfo =
              "${responseInfo.first.custodycd} - ${responseInfo.first.fullname}";
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(
                  top: 29, left: 16, right: 16, bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextStyleBody(
                          text: appLocal.digitalSignature('cust'),
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                        Container(
                          width: 200,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          padding:
                              const EdgeInsets.only(left: 8, top: 8, right: 8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: customTextStyleBody(
                              text: UserInfo,
                              fontWeight: FontWeight.w400,
                              txalign: TextAlign.start,
                              maxLines: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextStyleBody(
                          text: "${appLocal.digitalSignature('frDate')} *",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: (isStartDateEdited)
                              ? ((errorStartDate == null) ? 38 : 58)
                              : (isClickConfirm ? 58 : 38),
                          width: 200,
                          child: TextField(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.green, // Màu sắc chính
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  _startDate.text =
                                      DateFormat('dd/MM/yyyy').format(picked);
                                });
                              }
                            },
                            readOnly: true,
                            style: const TextStyle(fontSize: 14),
                            controller: _startDate,
                            decoration: InputDecoration(
                              errorText: isStartDateEdited ? errorStartDate : c,
                              errorStyle: const TextStyle(
                                  fontSize: 10, color: Colors.red),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffa0a3af)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffa0a3af)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.only(left: 8),
                              hintText: "dd/MM/yyyy",
                              suffixIcon:
                                  Image.asset("assets/icons/Vector.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextStyleBody(
                          text: "${appLocal.digitalSignature('toDate')} *",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: (isEndDateEdited)
                              ? ((errorEndDate == null) ? 38 : 58)
                              : (isClickConfirm ? 58 : 38),
                          width: 200,
                          child: TextField(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.green, // Màu sắc chính
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  _endDate.text =
                                      DateFormat('dd/MM/yyyy').format(picked);
                                });
                              }
                            },
                            readOnly: true,
                            style: const TextStyle(fontSize: 14),
                            controller: _endDate,
                            decoration: InputDecoration(
                              errorText: isEndDateEdited ? errorEndDate : d,
                              errorStyle: const TextStyle(
                                  fontSize: 10, color: Colors.red),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffa0a3af)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffa0a3af)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.only(left: 8),
                              hintText: "dd/MM/yyyy",
                              suffixIcon:
                                  Image.asset("assets/icons/Vector.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextStyleBody(
                          text: appLocal.digitalSignature('provider'),
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                        Container(
                          width: 200,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          padding:
                              const EdgeInsets.only(left: 8, top: 8, right: 8),
                          child: customTextStyleBody(
                            text: "Viettel",
                            fontWeight: FontWeight.w400,
                            txalign: TextAlign.start,
                            maxLines: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextStyleBody(
                          text: "${appLocal.digitalSignature('username')} *",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          width: 200,
                          height: (isUsernameEdited)
                              ? ((_errorUsername == null) ? 38 : 58)
                              : (isClickConfirm ? 58 : 38),
                          child: TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: userId,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              errorText: isUsernameEdited ? _errorUsername : a,
                              errorStyle: const TextStyle(
                                  fontSize: 10, color: Colors.red),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffa0a3af)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffa0a3af)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.only(left: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextStyleBody(
                          text: "${appLocal.digitalSignature('loginpass')} *",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          width: 200,
                          height: (isPasswordEdited)
                              ? ((_errorPassword == null) ? 38 : 58)
                              : (isClickConfirm ? 58 : 38),
                          child: TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: password,
                            style: const TextStyle(fontSize: 14),
                            obscureText: !isObscure,
                            decoration: InputDecoration(
                              errorText: isPasswordEdited ? _errorPassword : b,
                              errorStyle: const TextStyle(
                                  fontSize: 10, color: Colors.red),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffa0a3af)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffa0a3af)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.only(left: 8),
                              suffixIconColor: const Color(0xff595e72),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                child: Icon(
                                  isObscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FutureBuilder(
                      future: GetAllCode("API", "SIGNSTATUS",
                          HydratedBloc.storage.read('token')),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else {
                          final responseData = snapshot.data ?? [];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customTextStyleBody(
                                text: appLocal.digitalSignature('status'),
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .color!,
                                fontWeight: FontWeight.w400,
                              ),
                              Container(
                                width: 200,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                padding: const EdgeInsets.only(right: 8),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    value: selectedStatus,
                                    isExpanded: true,
                                    items: [
                                      for (var i in responseData)
                                        DropdownMenuItem(
                                          value: i['cdval'],
                                          child: customTextStyleBody(
                                            text: i['vN_CDCONTENT'],
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextStyleBody(
                          text: appLocal.digitalSignature('description'),
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffa0a3af)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          width: 200,
                          height: 102,
                          child: TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: description,
                            maxLines: 4,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText:
                                  appLocal.digitalSignature('description'),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.only(left: 8, top: 4),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            bottomSheet: Container(
              height: 60,
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.background,
                ),
                onPressed: () {
                  isClickConfirm = true;
                  checkError(responseInfo);
                },
                child: customTextStyleBody(
                  text: appLocal.buttonForm('confirm'),
                  size: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).buttonTheme.colorScheme!.primary,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  String? get errorStartDate {
    final textS = _startDate.value.text;
    final textE = _endDate.value.text;

    if (textS.isNotEmpty) {
      isStartDateEdited = true;
    }
    if (textS.isEmpty && isStartDateEdited) {
      return startDateEmpty;
    } else if (textS.isNotEmpty &&
        textE.isNotEmpty &&
        isStartDateEdited &&
        isEndDateEdited) {
      DateTime dateS = DateFormat("dd/MM/yyyy").parse(textS);
      DateTime dateE = DateFormat("dd/MM/yyyy").parse(textE);
      if (dateS.isAfter(dateE)) {
        return startDateValidate;
      }
    }
    return null;
  }

  String? get errorEndDate {
    final textS = _startDate.value.text;
    final textE = _endDate.value.text;
    if (textE.isNotEmpty) {
      isEndDateEdited = true;
    }
    if (textE.isEmpty && isEndDateEdited) {
      return endDateEmpty;
    } else if (textS.isNotEmpty &&
        textE.isNotEmpty &&
        isStartDateEdited &&
        isEndDateEdited) {
      DateTime dateS = DateFormat("dd/MM/yyyy").parse(textS);
      DateTime dateE = DateFormat("dd/MM/yyyy").parse(textE);
      if (dateE.isBefore(dateS)) {
        return endDateValidate;
      }
    }
    return null;
  }

  String? get _errorUsername {
    final text = userId.value.text;
    if (text.isNotEmpty) {
      isUsernameEdited = true;
    }
    if (text.isEmpty && isUsernameEdited) {
      return usernameValidate;
    }
    return null;
  }

  String? get _errorPassword {
    final text = password.value.text;
    if (text.isNotEmpty) {
      isPasswordEdited = true;
    }
    if (text.isEmpty && isPasswordEdited) {
      return passwordValidate;
    }
    return null;
  }

  Future<void> checkError(List<AccountInfoModel> responseInfo) async {
    if (_errorUsername == null &&
        _errorPassword == null &&
        userId.text.isNotEmpty &&
        password.text.isNotEmpty &&
        errorStartDate == null &&
        errorEndDate == null &&
        _startDate.text.isNotEmpty &&
        _endDate.text.isNotEmpty) {
      final btnAdd = await addCaSignRegistration(
        UserInfo,
        responseInfo.first.custid,
        description.text,
        _startDate.text,
        password.text,
        userId.text,
        selectedStatus,
        _endDate.text,
        HydratedBloc.storage.read('token'),
      );
      if (btnAdd.statusCode == 200 && btnAdd.data['errorCode'] == 0) {
        fToast.showToast(
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 2),
          child: msgNotification(
            color: Colors.green,
            icon: Icons.check_circle,
            text: "Thành công",
          ),
        );
        widget.pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        setState(() {
          _startDate.clear();
          _endDate.clear();
          userId.clear();
          password.clear();
          description.clear();
          isStartDateEdited = false;
          isEndDateEdited = false;
          isUsernameEdited = false;
          isPasswordEdited = false;
          a = null;
          b = null;
          c = null;
          d = null;
        });
      } else {
        fToast.showToast(
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 2),
          child: msgNotification(
            color: Colors.red,
            icon: Icons.cancel,
            text: "Thất bại, ${btnAdd.data['errorMsg']}",
          ),
        );
      }
    } else {
      setState(() {
        a = usernameValidate;
        b = passwordValidate;
        c = startDateEmpty;
        d = endDateEmpty;
      });
    }
  }
}
