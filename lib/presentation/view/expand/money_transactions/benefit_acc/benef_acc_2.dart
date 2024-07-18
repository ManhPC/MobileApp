import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/list_bank.dart';
import 'package:nvs_trading/data/services/getListBank.dart';
import 'package:nvs_trading/data/services/actionWithBankAccount.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BenefAcc2 extends StatefulWidget {
  const BenefAcc2({super.key});

  @override
  State<BenefAcc2> createState() => _BenefAcc2State();
}

class _BenefAcc2State extends State<BenefAcc2> {
  String custodycd = HydratedBloc.storage.read('custodycd');
  var _isSelected;
  TextEditingController stk = TextEditingController();
  bool isStkEdited = false;
  TextEditingController nameSTK = TextEditingController();
  bool isNameStkEdited = false;

  List<ListBank> lB = [];

  // confirm
  bool isConfirm = false;

  late FToast fToast;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    stk.addListener(checkAccount);
    nameSTK.addListener(checkName);
    fetchListBank();
  }

  void checkAccount() {
    setState(() {
      _errorAccount;
    });
  }

  void checkName() {
    setState(() {
      _errorName;
    });
  }

  @override
  void dispose() {
    stk.removeListener(checkAccount);
    nameSTK.removeListener(checkName);
    super.dispose();
  }

  void fetchListBank() async {
    try {
      final response = await getListBank();
      if (response.isNotEmpty) {
        setState(() {
          lB = response;
        });
      }
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: local.beneficAccount('benefAccount')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextStyleBody(
                  text: local.beneficAccount('banks'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: (_isSelected == null && isConfirm)
                              ? Colors.red
                              : Theme.of(context).hintColor,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: 200,
                      height: 32,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          value: _isSelected,
                          hint: customTextStyleBody(
                            text: local.localeName == 'vi'
                                ? "Chọn ngân hàng"
                                : "Choose banks",
                            color: (_isSelected == null && isConfirm)
                                ? const Color.fromARGB(140, 244, 67, 54)
                                : Theme.of(context).hintColor,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isSelected = value!;
                            });
                          },
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                          isExpanded: true,
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 160,
                          ),
                          iconStyleData: IconStyleData(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 16,
                            iconEnabledColor: Theme.of(context).hintColor,
                          ),
                          items: [
                            for (var i in lB)
                              DropdownMenuItem(
                                value: i.bankid,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: customTextStyleBody(
                                    text: "${i.bankid} - ${i.bankname}",
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor,
                                    size: 14,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    (_isSelected == null && isConfirm)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 2, left: 8),
                            child: customTextStyleBody(
                              text: "Không được để trống",
                              size: 10,
                              color: Colors.red,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: local.beneficAccount('account'),
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                  SizedBox(
                    width: 200,
                    height: isStkEdited
                        ? ((_errorAccount != null) ? 52 : 32)
                        : (isConfirm ? 52 : 32),
                    child: TextField(
                      controller: stk,
                      cursorColor: Theme.of(context).primaryColor,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]')),
                      ],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        errorStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                        ),
                        errorText: isStkEdited
                            ? _errorAccount
                            : (isConfirm)
                                ? "Không được để trống"
                                : null,
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextStyleBody(
                  text: local.beneficAccount('AHFN'),
                  color: Theme.of(context).textTheme.titleSmall!.color!,
                ),
                SizedBox(
                  width: 200,
                  height: isNameStkEdited
                      ? ((_errorName != null) ? 52 : 32)
                      : (isConfirm ? 52 : 32),
                  child: TextField(
                    controller: nameSTK,
                    cursorColor: Theme.of(context).primaryColor,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      errorStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                      ),
                      errorText: isNameStkEdited
                          ? _errorName
                          : (isConfirm)
                              ? "Không được để trống"
                              : null,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
            setState(() {
              isConfirm = true;
            });
            final response = await registerBankAccount(
                stk.text, _isSelected, "", custodycd, nameSTK.text);
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
                await Future.delayed(const Duration(seconds: 2));
                Navigator.of(context).pop(true);
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
          },
          child: customTextStyleBody(
            text: local.buttonForm('confirm'),
            size: 14,
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
        ),
      ),
    );
  }

  String? get _errorAccount {
    final text = stk.value.text;
    if (text.isNotEmpty) {
      isStkEdited = true;
    }
    if (text.isEmpty && isStkEdited) {
      return "Không được để trống";
    }
    return null;
  }

  String? get _errorName {
    final text = nameSTK.value.text;
    if (text.isNotEmpty) {
      isNameStkEdited = true;
    }
    if (text.isEmpty && isNameStkEdited) {
      return "Không được để trống";
    }
    return null;
  }
}
