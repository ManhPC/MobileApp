// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nvs_trading/common/utils/toast_utils.dart';
import 'package:nvs_trading/domain/biometrics_type.dart';
import 'package:nvs_trading/presentation/view/provider/getInfoAccount.dart';
import 'package:nvs_trading/data/services/generatetOken.dart';
import 'package:nvs_trading/data/services/getInfoCustomerDetail.dart';
import 'package:nvs_trading/main.dart';
import 'package:nvs_trading/presentation/theme/themeProvider.dart';
import 'package:nvs_trading/presentation/view/authentication/authentication_bloc.dart';
import 'package:nvs_trading/presentation/view/authentication/authentication_event.dart';
import 'package:nvs_trading/presentation/view/bottom_bar/bottom_bar.dart';
import 'package:nvs_trading/presentation/view/forget_password/forget_pass.dart';
import 'package:nvs_trading/presentation/view/login/local_auth/local_auth_services.dart';
import 'package:nvs_trading/presentation/view/login/login_bloc.dart';
import 'package:nvs_trading/presentation/view/new_account/new_account.dart';
import 'package:nvs_trading/presentation/view/search_account/search_account.dart';
import 'package:nvs_trading/presentation/view/web_socket/web_socket_connect.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<String> items = ['vi', 'en'];
  List<String> flags = [
    'assets/images/vietnam.svg',
    'assets/images/england.svg',
  ];
  // String selecteditem = 'VN';

  bool _showpass = true;
  final TextEditingController _usercontroler = TextEditingController();
  final TextEditingController _passcontroler = TextEditingController();
  var usererr = 'Tên đăng nhập không được bỏ trống';
  var passerr = 'Mật khẩu không được bỏ trống';
  bool checkuser = false;
  bool checkpass = false;
  int radioCheckClick = 0;
  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    final isUsernameSave = HydratedBloc.storage.read('custodycd');
    final isPasswordSave = HydratedBloc.storage.read('password');
    if (isUsernameSave != null) {
      _usercontroler.text = isUsernameSave;
    }
    if (isPasswordSave != null &&
        HydratedBloc.storage.read('isSaveLogin') == true) {
      _passcontroler.text = isPasswordSave;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool themeMode = Provider.of<ThemeProvider>(context).isDarkMode;
    var appLocalizations = AppLocalizations.of(context);
    String selecteditem = appLocalizations!.localeName;
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (HydratedBloc.storage.read('isSaveLogin') != null) {
          state.isSaveLogin = HydratedBloc.storage.read('isSaveLogin');
        }
        var radiochecked = HydratedBloc.storage.read('isSaveLogin');
        return Scaffold(
          body: Container(
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(
                  height: 96,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: appLocalizations.loginForm('title'),
                      size: 32,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .toggleTheme();
                              });
                            },
                            child: themeMode
                                ? const Icon(Icons.dark_mode)
                                : const Icon(
                                    Icons.light_mode,
                                    color: Colors.yellow,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 72,
                          height: 20,
                          child: DropdownButton<String>(
                            underline: Container(),
                            isExpanded: true,
                            value: selecteditem,
                            style: const TextStyle(fontSize: 12),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 14,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              if (value == "vi") {
                                MyApp.setLocale(context, const Locale('vi'));
                              } else {
                                MyApp.setLocale(context, const Locale('en'));
                              }
                              setState(() {
                                selecteditem = value!;
                              });
                            },
                            items: items
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: SvgPicture.asset((value == "vi")
                                          ? flags[0]
                                          : flags[1]),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    customTextStyleBody(
                                      text: (value == "vi") ? "VN" : "EN",
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 19,
                ),
                Row(
                  children: [
                    customTextStyleBody(
                      text: appLocalizations.loginForm('account'),
                      size: 14,
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NewAccount()));
                      },
                      child: customTextStyleBody(
                        text: appLocalizations.loginForm('create_account'),
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .background,
                        size: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(bottom: 8, top: 55),
                  child: customTextStyleBody(
                    text: appLocalizations.loginForm('user_name'),
                    size: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  cursorColor: const Color(0xff595e72),
                  style: const TextStyle(fontSize: 16),
                  controller: _usercontroler,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    hintText: appLocalizations.loginForm('user_name'),
                    hintStyle: TextStyle(
                        fontSize: 16, color: Theme.of(context).hintColor),
                    errorText: checkuser ? usererr : null,
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: customTextStyleBody(
                    text: appLocalizations.loginForm('password'),
                    size: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  cursorColor: const Color(0xff595e72),
                  style: const TextStyle(fontSize: 16),
                  controller: _passcontroler,
                  obscureText: _showpass,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    suffixIcon: showpass(),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    hintText: appLocalizations.loginForm('password'),
                    hintStyle: TextStyle(
                        fontSize: 16, color: Theme.of(context).hintColor),
                    labelStyle: const TextStyle(fontSize: 16),
                    errorText: checkpass ? passerr : null,
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (radioCheckClick == 0 && state.isSaveLogin == true) {
                        var loginBloc = BlocProvider.of<LoginBloc>(context);
                        loginBloc.add(
                            IsUsernameChanged(custodycd: _usercontroler.text));
                        loginBloc.add(
                            IsPasswordChanged(password: _passcontroler.text));
                        loginBloc.add(LoginSubmitted());
                      }
                      //print(radioCheckClick);
                      error();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).buttonTheme.colorScheme!.background,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: customTextStyleBody(
                      text: appLocalizations.loginForm('title'),
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                      size: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: radiocheck,
                      child: (radiochecked != null && radiochecked)
                          ? Icon(
                              Icons.radio_button_checked,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .background,
                            )
                          : Icon(
                              Icons.radio_button_off,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .background,
                            ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    customTextStyleBody(
                      text: appLocalizations.loginForm('save_login'),
                      size: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgetPass()));
                        },
                        child: customTextStyleBody(
                          text: appLocalizations.loginForm('forgot_password'),
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .background,
                          size: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SearchAccount()));
                        },
                        child: customTextStyleBody(
                          text: appLocalizations.loginForm('search_stk'),
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .background,
                          size: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ]),
                BiometricsButton(
                  usercontroler: _usercontroler,
                  fToast: fToast,
                  passcontroler: _passcontroler,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget showpass() {
    return IconButton(
        onPressed: () {
          setState(() {
            _showpass = !_showpass;
          });
        },
        icon: _showpass
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility));
  }

  void radiocheck() {
    setState(() {
      radioCheckClick += 1;
      var loginBloc = BlocProvider.of<LoginBloc>(context);
      loginBloc
          .add(IsSaveLoginChanged(isSaveLogin: !loginBloc.state.isSaveLogin));
      loginBloc.add(IsUsernameChanged(custodycd: _usercontroler.text));
      loginBloc.add(IsPasswordChanged(password: _passcontroler.text));
      loginBloc.add(LoginSubmitted());
    });
    print(HydratedBloc.storage.read('custodycd'));
  }

  void error() async {
    if (_usercontroler.text.isEmpty) {
      setState(() {
        checkuser = true;
      });
    } else {
      setState(() {
        checkuser = false;
      });
    }
    if (_passcontroler.text.isEmpty) {
      setState(() {
        checkpass = true;
      });
    } else {
      setState(() {
        checkpass = false;
      });
    }
    if (checkuser || checkpass) {
      return;
    } else {
      if (_usercontroler.text != HydratedBloc.storage.read('custodycd')) {
        HydratedBloc.storage.delete('acctno');
      }
      var loginBloc = BlocProvider.of<LoginBloc>(context);
      final response =
          await GeneratetOken(_usercontroler.text, _passcontroler.text);
      if (response.isNotEmpty) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(
            response.first.token, _usercontroler.text, _passcontroler.text));
        Provider.of<GetInfoAccount>(context, listen: false).getInfoAccount =
            getInfoCustomerDetail(
                response.first.token, _usercontroler.text, "1");
        loginBloc.add(LoginInit());
        print(HydratedBloc.storage.read('isSaveLogin'));
        if (HydratedBloc.storage.read(HydratedBloc.storage.read('custodycd')) ==
            null) {
          HydratedBloc.storage.delete('switch');
        } else {
          HydratedBloc.storage.write('switch', true);
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebSocketConnect(child: BottomBar())));
      } else {
        fToast.showToast(
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 2),
          child: msgNotification(
            color: Colors.red,
            icon: Icons.cancel,
            text: "Tài khoản hoặc mật khẩu không đúng!",
          ),
        );
      }
    }
  }
}

class BiometricsButton extends StatelessWidget {
  const BiometricsButton({
    super.key,
    required TextEditingController usercontroler,
    required this.fToast,
    required TextEditingController passcontroler,
  })  : _usercontroler = usercontroler,
        _passcontroler = passcontroler;

  final TextEditingController _usercontroler;
  final FToast fToast;
  final TextEditingController _passcontroler;

  @override
  Widget build(BuildContext context) {
    // BiometricsType checkBiometric() {
    //   BiometricsType checkBiometric = BiometricsType.noSupport;
    //   Platform.isIOS
    //       ? checkBiometric = BiometricsType.faceId
    //       : checkBiometric = BiometricsType.touchId;

    //   LocalAuth.getAvailableBiometrics()
    //       .then((value) => checkBiometric = value);

    //   return checkBiometric;
    // }

    Future<BiometricsType> checkBiometric() async {
      BiometricsType checkBiometric = BiometricsType.noSupport;
      if (Platform.isIOS) {
        checkBiometric = BiometricsType.faceId;
      } else {
        checkBiometric = BiometricsType.touchId;
      }

      try {
        final availableBiometrics = await LocalAuth.getAvailableBiometrics();
        checkBiometric = availableBiometrics;
      } catch (e) {
        print(e);
      }
      return checkBiometric;
    }

    ToastUtils toastLogin(BiometricsType checkBiometric) {
      switch (checkBiometric) {
        case BiometricsType.faceId:
          return ToastUtils().showError("Thất bại");
        case BiometricsType.touchId:
          return ToastUtils().showError("Thất bại");
        case BiometricsType.noSupport:
          return ToastUtils().showError("");
        case BiometricsType.noActivated:
          return ToastUtils().showError("");
      }
    }

    void showToast(BuildContext context, String message) {
      final localFToast = FToast();
      localFToast.init(context);
      localFToast.showToast(
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 2),
        child: msgNotification(
          color: Colors.red,
          icon: Icons.error,
          text: message,
        ),
      );
    }

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return FutureBuilder<BiometricsType>(
            future: checkBiometric(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return GestureDetector(
                onTap: (_usercontroler.text.isEmpty)
                    ? null
                    : () async {
                        if (HydratedBloc.storage.read(_usercontroler.text) ==
                            null) {
                          showToast(context,
                              "Tài khoản chưa đăng ký bảo mật sinh trắc học!");
                        } else {
                          bool auth = await LocalAuth.authentication();
                          if (auth) {
                            final response = await GeneratetOken(
                              _usercontroler.text,
                              _passcontroler.text,
                            );
                            if (response.isNotEmpty) {
                              BlocProvider.of<AuthenticationBloc>(context).add(
                                  LoggedIn(
                                      response.first.token,
                                      _usercontroler.text,
                                      _passcontroler.text));
                              Provider.of<GetInfoAccount>(context,
                                          listen: false)
                                      .getInfoAccount =
                                  getInfoCustomerDetail(response.first.token,
                                      _usercontroler.text, "1");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WebSocketConnect(child: BottomBar()),
                                ),
                              );
                            } else {
                              showToast(context,
                                  "[-2]: Thông tin đầu vào không hợp lệ !");
                            }
                          } else {
                            print(auth);
                          }
                        }
                      },
                child: Icon(
                  snapshot.data == BiometricsType.faceId
                      ? Icons.face
                      : Icons.touch_app,
                  size: 50,
                ),
              );
            });
      },
    );
  }
}
