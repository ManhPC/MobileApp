import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/finger_print/finger_print_bloc.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FingerPrint extends StatefulWidget {
  const FingerPrint({super.key});

  @override
  State<FingerPrint> createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  bool isSwitch = HydratedBloc.storage.read('switch') ?? false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  late FToast fToast;

  //bool isObscure = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username.text = HydratedBloc.storage.read('custodycd');
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    var fingerBloc = BlocProvider.of<FingerPrintBloc>(context);
    return BlocBuilder<FingerPrintBloc, FingerPrintState>(
      builder: (context, state) {
        return Scaffold(
          appBar: appBar(text: appLocal.biometricSecurity('title')),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customTextStyleBody(
                  text: appLocal.biometricSecurity('title'),
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                Switch(
                  value: isSwitch,
                  inactiveThumbColor: Theme.of(context).primaryColor,
                  inactiveTrackColor: Theme.of(context).hintColor,
                  activeColor:
                      Theme.of(context).buttonTheme.colorScheme!.background,
                  activeTrackColor: Theme.of(context).hintColor,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitch = value;
                    });
                    if (isSwitch == true) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (BuildContext context, setState2) {
                              return AlertDialog(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                content: customTextStyleBody(
                                  text: appLocal.biometricSecurity('note'),
                                  size: 18,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                actions: [
                                  Container(
                                    height: 150,
                                    width: 311,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customTextStyleBody(
                                          text: appLocal
                                              .biometricSecurity('account'),
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .color!,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 8, top: 6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          height: 36,
                                          child: TextField(
                                            cursorColor:
                                                Theme.of(context).primaryColor,
                                            controller: username,
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        customTextStyleBody(
                                          text: appLocal
                                              .biometricSecurity('password'),
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .color!,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, bottom: 8),
                                          height: 36,
                                          child: TextField(
                                            cursorColor:
                                                Theme.of(context).primaryColor,
                                            controller: password,
                                            obscureText:
                                                !fingerBloc.state.isObscure,
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState2(() {
                                                    fingerBloc.add(
                                                      IsChangeObscure(
                                                        isObscure: !fingerBloc
                                                            .state.isObscure,
                                                      ),
                                                    );
                                                  });
                                                },
                                                child: Icon(
                                                    fingerBloc.state.isObscure
                                                        ? Icons.visibility
                                                        : Icons.visibility_off),
                                              ),
                                              isDense: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 68,
                                    margin: const EdgeInsets.only(
                                        top: 32, bottom: 40),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(180, 36),
                                              backgroundColor: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .background,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (username.text ==
                                                      HydratedBloc.storage
                                                          .read('custodycd') &&
                                                  password.text ==
                                                      HydratedBloc.storage
                                                          .read('password')) {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  isSwitch = true;
                                                  HydratedBloc.storage.write(
                                                      'switch', isSwitch);
                                                  HydratedBloc.storage.write(
                                                      HydratedBloc.storage
                                                          .read('custodycd'),
                                                      isSwitch);
                                                });
                                                fToast.showToast(
                                                  gravity: ToastGravity.TOP,
                                                  toastDuration: const Duration(
                                                      seconds: 2),
                                                  child: msgNotification(
                                                    color: Colors.green,
                                                    icon: Icons.check_circle,
                                                    text:
                                                        "Thêm bảo mật sinh trắc học thành công",
                                                  ),
                                                );
                                              } else {
                                                fToast.showToast(
                                                  gravity: ToastGravity.TOP,
                                                  toastDuration: const Duration(
                                                      seconds: 2),
                                                  child: msgNotification(
                                                    color: Colors.red,
                                                    icon: Icons.error,
                                                    text:
                                                        "Tài khoản hoặc mật khẩu không đúng!",
                                                  ),
                                                );
                                              }
                                            },
                                            child: customTextStyleBody(
                                              text: appLocal
                                                  .buttonForm('continue'),
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .primary,
                                              size: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isSwitch = false;
                                                HydratedBloc.storage
                                                    .delete('switch');
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: customTextStyleBody(
                                              text:
                                                  appLocal.buttonForm('cancel'),
                                              size: 14,
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .background,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      );
                    } else {
                      setState(() {
                        HydratedBloc.storage.delete('switch');
                        HydratedBloc.storage.delete(
                          HydratedBloc.storage.read('custodycd'),
                        );
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
