// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/data/model/account_info.dart';
import 'package:nvs_trading/presentation/view/provider/getInfoAccount.dart';
import 'package:nvs_trading/data/services/CA-SignRegis.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListDigitalSign extends StatefulWidget {
  ListDigitalSign({
    super.key,
    required this.pageController,
  });

  PageController pageController;

  @override
  State<ListDigitalSign> createState() => _ListDigitalSignState();
}

class _ListDigitalSignState extends State<ListDigitalSign> {
  late Future<List<AccountInfoModel>> response;
  bool isObscure = false;

  late FToast fToast;

  bool isObscureUpdate = false;
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isStartDateEdited = false;
  bool isEndDateEdited = false;
  bool isPasswordEdited = false;
  bool isClickConfirm = false;

  bool isChange = false;

  String passwordValidate = "Không được để trống";
  String startDateEmpty = "Từ ngày không được để trống";
  String endDateEmpty = "Đến ngày không được để trống";
  String startDateValidate = "Phải nhỏ hơn hoặc bằng đến ngày";
  String endDateValidate = "Phải lớn hơn hoặc bằng từ ngày";

  var b;
  var c;
  var d;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

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

  void checkPassword() {
    setState(() {
      _errorPassword;
    });
  }

  @override
  void dispose() {
    password.removeListener(checkPassword);
    _startDate.removeListener(checkStartDate);
    _endDate.removeListener(checkEndDate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    response = Provider.of<GetInfoAccount>(context).getInfoAccount;
    return FutureBuilder(
      future: response,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.blue,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          final cust = snapshot.data!;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: FutureBuilder(
              future: CaSignRegistration(
                  cust.first.custid, HydratedBloc.storage.read('token')),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  final rs = snapshot.data ?? [];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i in rs)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customTextStyleBody(
                                        text: i.personal_UserId,
                                        size: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 50,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Color(0xffF04A47),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              ),
                                              onPressed: () async {
                                                print(i.autoId);
                                                final btnDelete =
                                                    await deleteCaSignRegistration(
                                                        i.autoId,
                                                        HydratedBloc.storage
                                                            .read('token'));
                                                if (btnDelete == 0) {
                                                  fToast.showToast(
                                                    gravity: ToastGravity.TOP,
                                                    toastDuration:
                                                        const Duration(
                                                            seconds: 2),
                                                    child: msgNotification(
                                                      color: Colors.green,
                                                      icon: Icons.check_circle,
                                                      text: "Xóa thành công",
                                                    ),
                                                  );

                                                  setState(() {});
                                                } else {
                                                  fToast.showToast(
                                                    gravity: ToastGravity.TOP,
                                                    toastDuration:
                                                        const Duration(
                                                            seconds: 2),
                                                    child: msgNotification(
                                                      color: Colors.red,
                                                      icon: Icons.cancel,
                                                      text: "Xóa thất bại",
                                                    ),
                                                  );
                                                }
                                              },
                                              child: FittedBox(
                                                fit: BoxFit.none,
                                                child: customTextStyleBody(
                                                  text: appLocal
                                                      .buttonForm('delete'),
                                                  color:
                                                      const Color(0xffF04A47),
                                                  fontWeight: FontWeight.w400,
                                                  size: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          SizedBox(
                                            height: 20,
                                            width: 50,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Color(0xffE7AB21),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              ),
                                              onPressed: () {
                                                fetchUpdate(
                                                  context,
                                                  "${cust.first.custodycd} - ${cust.first.fullname}",
                                                  i.autoId,
                                                  cust.first.custid,
                                                  i.fromDate,
                                                  i.toDate,
                                                  i.personal_UserId,
                                                  i.personal_Pass,
                                                  i.status_Vn,
                                                  i.description,
                                                );
                                              },
                                              child: FittedBox(
                                                fit: BoxFit.none,
                                                child: customTextStyleBody(
                                                  text: appLocal
                                                      .buttonForm('update'),
                                                  color:
                                                      const Color(0xffE7AB21),
                                                  fontWeight: FontWeight.w400,
                                                  size: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: customTextStyleBody(
                                              text: appLocal
                                                  .digitalSignature('frDate'),
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                              txalign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 77.5,
                                            child: customTextStyleBody(
                                              text: DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.parse(
                                                      i.fromDate)),
                                              fontWeight: FontWeight.w700,
                                              txalign: TextAlign.start,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: customTextStyleBody(
                                              text: appLocal
                                                  .digitalSignature('toDate'),
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                              txalign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 77.5,
                                            child: customTextStyleBody(
                                              text: DateFormat('dd/MM/yyyy')
                                                  .format(
                                                      DateTime.parse(i.toDate)),
                                              fontWeight: FontWeight.w700,
                                              txalign: TextAlign.start,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: customTextStyleBody(
                                            text: appLocal
                                                .digitalSignature('loginpass'),
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                            txalign: TextAlign.start,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 77.5,
                                          child: customTextStyleBody(
                                            text: isObscure
                                                ? i.personal_Pass
                                                : "•" * i.personal_Pass.length,
                                            fontWeight: FontWeight.w700,
                                            txalign: TextAlign.start,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: customTextStyleBody(
                                            text: appLocal
                                                .digitalSignature('status'),
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                            txalign: TextAlign.start,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 77.5,
                                          child: customTextStyleBody(
                                            text: i.status_Vn,
                                            fontWeight: FontWeight.w700,
                                            txalign: TextAlign.start,
                                            color: const Color(0xffCCAC3D),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: customTextStyleBody(
                                        text: appLocal
                                            .digitalSignature('description'),
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.start,
                                      ),
                                    ),
                                    customTextStyleBody(
                                      text: (i.description == "null")
                                          ? ""
                                          : i.description,
                                      fontWeight: FontWeight.w700,
                                      txalign: TextAlign.start,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  ],
                                )
                              ],
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

  Future<dynamic> fetchUpdate(
    BuildContext context,
    String khachhang,
    int autoId,
    String custInfo,
    String fromDate,
    String toDate,
    String userId,
    String userPass,
    String status,
    String description1,
  ) {
    _startDate.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(fromDate));
    _endDate.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(toDate));
    password.text = userPass;
    if (description1 == "null") {
      description1 = "";
    }
    description.text = description1;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        var appLocal = AppLocalizations.of(context)!;
        return AlertDialog(
          title: customTextStyleBody(
            text: appLocal.digitalSignature('titleUpdate'),
            color: Theme.of(context).primaryColor,
            size: 18,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: appLocal.digitalSignature('cust'),
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor,
                        border: Border.all(
                          color: const Color(0xffa0a3af),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: MediaQuery.of(context).size.width - 250,
                      height: 38,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: customTextStyleBody(
                          text: khachhang,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                          txalign: TextAlign.start,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
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
                      width: MediaQuery.of(context).size.width - 250,
                      child: TextField(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateFormat("dd/MM/yyyy").parse(_startDate.text),
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
                          errorStyle:
                              const TextStyle(fontSize: 10, color: Colors.red),
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
                          suffixIcon: Image.asset("assets/icons/Vector.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
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
                      width: MediaQuery.of(context).size.width - 250,
                      child: TextField(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateFormat('dd/MM/yyyy').parse(_endDate.text),
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
                          errorStyle:
                              const TextStyle(fontSize: 10, color: Colors.red),
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
                          suffixIcon: Image.asset("assets/icons/Vector.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 110,
                      child: customTextStyleBody(
                        text: "${appLocal.digitalSignature('username')} *",
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.start,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor,
                        border: Border.all(
                          color: const Color(0xffa0a3af),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: MediaQuery.of(context).size.width - 250,
                      height: 38,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: customTextStyleBody(
                        text: userId,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: customTextStyleBody(
                        text: "${appLocal.digitalSignature('loginpass')} *",
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 250,
                      height: (isPasswordEdited)
                          ? ((_errorPassword == null) ? 38 : 58)
                          : (isClickConfirm ? 58 : 38),
                      child: TextField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: password,
                        style: const TextStyle(fontSize: 14),
                        obscureText: !isObscureUpdate,
                        decoration: InputDecoration(
                          errorText: isPasswordEdited ? _errorPassword : b,
                          errorStyle:
                              const TextStyle(fontSize: 10, color: Colors.red),
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
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: appLocal.digitalSignature('status'),
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor,
                        border: Border.all(
                          color: const Color(0xffa0a3af),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: MediaQuery.of(context).size.width - 250,
                      height: 38,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: customTextStyleBody(
                        text: status,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
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
                      width: MediaQuery.of(context).size.width - 250,
                      height: 102,
                      child: TextField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: description,
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText: appLocal.digitalSignature('description'),
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.only(left: 8, top: 4)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).buttonTheme.colorScheme!.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () async {
                if (_errorPassword == null &&
                    password.text.isNotEmpty &&
                    errorStartDate == null &&
                    errorEndDate == null &&
                    _startDate.text.isNotEmpty &&
                    _endDate.text.isNotEmpty) {
                  final btnUpdate = await updateCaSignRegistration(
                    khachhang,
                    autoId,
                    custInfo,
                    description.text,
                    _startDate.text,
                    password.text,
                    userId,
                    status,
                    _endDate.text,
                    HydratedBloc.storage.read('token'),
                  );
                  if (btnUpdate.statusCode == 200 &&
                      btnUpdate.data['errorCode'] == 0) {
                    fToast.showToast(
                      gravity: ToastGravity.TOP,
                      toastDuration: const Duration(seconds: 2),
                      child: msgNotification(
                        color: Colors.green,
                        icon: Icons.check_circle,
                        text: "Thành công",
                      ),
                    );
                    Navigator.of(context).pop();
                    setState(() {});
                  } else {
                    fToast.showToast(
                      gravity: ToastGravity.TOP,
                      toastDuration: const Duration(seconds: 2),
                      child: msgNotification(
                        color: Colors.red,
                        icon: Icons.cancel,
                        text: "Thất bại, ${btnUpdate.data['errorMsg']}",
                      ),
                    );
                  }
                } else {
                  setState(() {
                    b = passwordValidate;
                    c = startDateEmpty;
                    d = endDateEmpty;
                  });
                }
              },
              child: customTextStyleBody(
                text: appLocal.buttonForm('save'),
                size: 14,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      },
    );
  }
}
