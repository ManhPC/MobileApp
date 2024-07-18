// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/data/model/account_info.dart';
import 'package:nvs_trading/presentation/view/provider/getInfoAccount.dart';
import 'package:nvs_trading/data/services/getInfoCustomerDetail.dart';
import 'package:nvs_trading/data/services/updateCustomerInfo.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  late Future<List<AccountInfoModel>> responseData;

  List<String> title = [
    'op',
    'id',
    'poi',
    'address',
    'phone',
    'mobile',
    'email',
    'ct',
    'branch',
    'consultant',
    'is',
  ];

  bool isEdit = false;

  TextEditingController addressEdit = TextEditingController();
  TextEditingController phoneEdit = TextEditingController();
  TextEditingController emailEdit = TextEditingController();

  bool checkPhone = false;
  bool checkEmail = false;
  bool checkAddress = false;

  late FToast fToast;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;

    responseData = Provider.of<GetInfoAccount>(context).getInfoAccount;
    return FutureBuilder(
      future: responseData,
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
          // print(accountResult.first.custid!);
          List<String> titleData = [
            accountResult.first.idcode,
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(accountResult.first.iddate)),
            accountResult.first.idplace,
            accountResult.first.address,
            accountResult.first.phone,
            accountResult.first.mobile,
            accountResult.first.email,
            (appLocalizations.localeName == 'vi')
                ? accountResult.first.custtypE_TEXT
                : accountResult.first.custtypE_TEXT_EN,
            accountResult.first.brname,
            '',
            (appLocalizations.localeName == 'vi')
                ? accountResult.first.statuS_TEXT
                : accountResult.first.statuS_TEXT_EN,
          ];
          if (accountResult.first.phone != '') {
            phoneEdit.text = accountResult.first.phone;
          }
          if (accountResult.first.address != '') {
            addressEdit.text = accountResult.first.address;
          }
          if (accountResult.first.email != '') {
            emailEdit.text = accountResult.first.email;
          }
          String isDisabled = accountResult.first.allowadjust;
          return Scaffold(
            appBar: appBar(text: appLocalizations.expandList5Form('pi')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16, bottom: 12),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 22,
                          child: customTextStyleBody(
                            text: appLocalizations.expandList5Form('pi'),
                            size: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowInfo(
                          titleText: appLocalizations.accountForm('account'),
                          contentText: accountResult.first.custodycd,
                          contentColor: Theme.of(context).primaryColor,
                          paddingbottom: 8,
                        ),
                        RowInfo(
                          titleText: appLocalizations.accountForm('cn'),
                          contentText: accountResult.first.fullname,
                          contentColor: Theme.of(context).primaryColor,
                          paddingbottom: 0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 22,
                          child: customTextStyleBody(
                            text: appLocalizations.expandList5Form('pi'),
                            size: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        for (var i = 0; i < title.length; i++)
                          _buildRowInfo(
                            title: title,
                            i: i,
                            titleData: titleData,
                            isEdit: isEdit,
                            phoneEdit: phoneEdit,
                            addressEdit: addressEdit,
                            emailEdit: emailEdit,
                            checkPhone: checkPhone,
                            checkAddress: checkAddress,
                            checkEmail: checkEmail,
                            isDisabled: isDisabled,
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomSheet: Container(
              height: 60,
              width: double.infinity,
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(159.5, 34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: (isDisabled == "N")
                              ? const Color(0xffa0a3af)
                              : Theme.of(context)
                                  .bottomSheetTheme
                                  .modalBackgroundColor!,
                        ),
                      ),
                    ),
                    onPressed: () {
                      (isDisabled == "N")
                          ? null
                          : setState(() {
                              isEdit = !isEdit;
                            });
                    },
                    child: customTextStyleBody(
                      text: appLocalizations.buttonForm("adjust"),
                      color: (isDisabled == "N")
                          ? const Color(0xffa0a3af)
                          : Theme.of(context)
                              .bottomSheetTheme
                              .modalBackgroundColor!,
                      size: 14,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(159.5, 34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: isEdit
                          ? Theme.of(context)
                              .bottomSheetTheme
                              .modalBackgroundColor
                          : Theme.of(context)
                              .bottomSheetTheme
                              .modalBarrierColor,
                    ),
                    onPressed: () {
                      isEdit
                          ? responseData.then((accountResult) {
                              _submitted(
                                accountResult.first.phone,
                                accountResult.first.address,
                                accountResult.first.email,
                              );
                            })
                          : null;
                    },
                    child: customTextStyleBody(
                      text: appLocalizations.buttonForm('confirm'),
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _submitted(
    String phone,
    String address,
    String email,
  ) async {
    final custodycd = HydratedBloc.storage.read('custodycd');
    final token = HydratedBloc.storage.read('token');
    RegExp regex = RegExp(r'[a-zA-Z!@#$%^&*();,.<>?]');
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    if (regex.hasMatch(phoneEdit.text) || phoneEdit.text.isEmpty) {
      setState(() {
        checkPhone = true;
      });
    } else {
      setState(() {
        checkPhone = false;
      });
    }
    if (!emailRegex.hasMatch(emailEdit.text) || emailEdit.text.isEmpty) {
      setState(() {
        checkEmail = true;
      });
    } else {
      setState(() {
        checkEmail = false;
      });
    }
    if (addressEdit.text.isEmpty) {
      setState(() {
        checkAddress = true;
      });
    } else {
      checkAddress = false;
    }

    if (phoneEdit.text == phone &&
        addressEdit.text == address &&
        emailEdit.text == email) {
      fToast.showToast(
        child: msgNotification(
          text: "Thông báo: Chưa có sự thay đổi",
          icon: Icons.error,
          color: Colors.red,
        ),
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 2),
      );
    } else if (checkPhone || checkEmail || checkAddress) {
      return null;
    } else {
      try {
        final response = await UpdateCusInfo(
            custodycd, addressEdit.text, phoneEdit.text, emailEdit.text, token);
        if (response.statusCode == 200) {
          setState(() {
            isEdit = false;
          });
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                content: customTextStyleBody(
                  text: response.data['message'],
                  color: Theme.of(context).primaryColor,
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .background),
                    onPressed: () {
                      responseData =
                          Provider.of<GetInfoAccount>(context, listen: false)
                              .getInfoAccount = getInfoCustomerDetail(
                        HydratedBloc.storage.read('token'),
                        HydratedBloc.storage.read('custodycd'),
                        "1",
                      );
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: customTextStyleBody(
                      text: "Đóng",
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                    ),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        if (e is DioError) {
          fToast.showToast(
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 2),
            child: msgNotification(
              color: Colors.red,
              icon: Icons.cancel,
              text: e.response!.data['message'],
            ),
          );
        }
        print('$e');
      }
    }
  }
}

class _buildRowInfo extends StatefulWidget {
  _buildRowInfo({
    super.key,
    required this.title,
    required this.i,
    required this.titleData,
    required this.isEdit,
    required this.phoneEdit,
    required this.addressEdit,
    required this.emailEdit,
    required this.checkPhone,
    required this.checkAddress,
    required this.checkEmail,
    required this.isDisabled,
  });

  final List<String> title;
  final int i;
  final List<String> titleData;
  final bool isEdit;
  final TextEditingController phoneEdit;
  final TextEditingController addressEdit;
  final TextEditingController emailEdit;
  bool checkPhone;
  bool checkAddress;
  bool checkEmail;
  String isDisabled;

  @override
  State<_buildRowInfo> createState() => _buildRowInfoState();
}

class _buildRowInfoState extends State<_buildRowInfo> {
  void _validatePhone(String input) {
    RegExp regex = RegExp(r'[a-zA-Z!@#$%^&*();,.<>?]');
    setState(() {
      widget.checkPhone = regex.hasMatch(input) || input.isEmpty;
    });
  }

  void _validateAddress(String input) {
    setState(() {
      widget.checkAddress = input.isEmpty;
    });
  }

  void _validateEmail(String input) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    setState(() {
      widget.checkEmail = !emailRegex.hasMatch(input) || input.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    if (widget.title[widget.i] == "phone") {
      return (widget.isEdit)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18,
                    child: customTextStyleBody(
                      text:
                          appLocalizations.accountForm(widget.title[widget.i]),
                      size: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    height: widget.checkPhone ? 48 : 28,
                    child: TextField(
                      onChanged: _validatePhone,
                      cursorColor: Theme.of(context).primaryColor,
                      controller: widget.phoneEdit,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xff595e72)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xff595e72)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        errorText: widget.checkPhone ? "Chỉ nhập số" : null,
                        errorStyle: const TextStyle(fontSize: 10),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ((widget.isDisabled == "N")
              ? RowInfo(
                  titleText:
                      appLocalizations.accountForm(widget.title[widget.i]),
                  titleEdited: true,
                  contentText: widget.titleData[widget.i],
                  paddingbottom: 8,
                  contentColor: Colors.orange.shade700,
                )
              : RowInfo(
                  titleText:
                      appLocalizations.accountForm(widget.title[widget.i]),
                  contentText: widget.titleData[widget.i],
                  contentColor: Theme.of(context).primaryColor,
                  paddingbottom: 8,
                ));
    }
    if (widget.title[widget.i] == "address") {
      return (widget.isEdit)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18,
                    child: customTextStyleBody(
                      text:
                          appLocalizations.accountForm(widget.title[widget.i]),
                      size: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    height: widget.checkAddress ? 48 : 28,
                    child: TextField(
                      onChanged: _validateAddress,
                      cursorColor: Theme.of(context).primaryColor,
                      controller: widget.addressEdit,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xff595e72)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xff595e72)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        errorText:
                            widget.checkAddress ? "Không được để trống" : null,
                        errorStyle: const TextStyle(fontSize: 10),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ((widget.isDisabled == "N")
              ? RowInfo(
                  titleText:
                      appLocalizations.accountForm(widget.title[widget.i]),
                  titleEdited: true,
                  contentText: widget.titleData[widget.i],
                  paddingbottom: 8,
                  contentColor: Colors.orange.shade700,
                )
              : RowInfo(
                  titleText:
                      appLocalizations.accountForm(widget.title[widget.i]),
                  contentText: widget.titleData[widget.i],
                  contentColor: Theme.of(context).primaryColor,
                  paddingbottom: 8,
                ));
    }
    if (widget.title[widget.i] == "email") {
      return (widget.isEdit)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18,
                    child: customTextStyleBody(
                      text:
                          appLocalizations.accountForm(widget.title[widget.i]),
                      size: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                    ),
                  ),
                  SizedBox(
                    height: widget.checkEmail ? 48 : 28,
                    child: TextField(
                      onChanged: _validateEmail,
                      cursorColor: Theme.of(context).primaryColor,
                      controller: widget.emailEdit,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xff595e72)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xff595e72)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        errorText: widget.checkEmail
                            ? "Định dạng email không hợp lệ"
                            : null,
                        errorStyle: const TextStyle(fontSize: 10),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ((widget.isDisabled == "N")
              ? RowInfo(
                  titleText:
                      appLocalizations.accountForm(widget.title[widget.i]),
                  titleEdited: true,
                  contentText: widget.titleData[widget.i],
                  paddingbottom: 8,
                  contentColor: Colors.orange.shade700,
                )
              : RowInfo(
                  titleText:
                      appLocalizations.accountForm(widget.title[widget.i]),
                  contentText: widget.titleData[widget.i],
                  contentColor: Theme.of(context).primaryColor,
                  paddingbottom: 8,
                ));
    }
    return RowInfo(
      titleText: appLocalizations.accountForm(widget.title[widget.i]),
      contentText: (widget.titleData[widget.i] == '')
          ? "--"
          : widget.titleData[widget.i],
      contentColor: Theme.of(context).primaryColor,
      paddingbottom: (widget.i == widget.title.length - 1) ? 0 : 8,
    );
  }
}

class RowInfo extends StatelessWidget {
  RowInfo({
    super.key,
    required this.titleText,
    this.titleEdited,
    required this.contentText,
    required this.contentColor,
    required this.paddingbottom,
  });
  String titleText;
  bool? titleEdited;
  String contentText;
  Color contentColor;
  double paddingbottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingbottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 18,
                child: customTextStyleBody(
                  text: titleText,
                  size: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                ),
              ),
              Icon(
                titleEdited != null ? Icons.info_outline : null,
                size: 16,
                color: Theme.of(context).hintColor,
              ),
            ],
          ),
          SizedBox(
            height: 20,
            child: customTextStyleBody(
              text: contentText,
              fontWeight: FontWeight.w400,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }
}
