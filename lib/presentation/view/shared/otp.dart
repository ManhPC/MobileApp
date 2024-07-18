// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/generalOTPinfo.dart';
import 'package:nvs_trading/data/services/bankTransfer.dart';
import 'package:nvs_trading/data/services/changePassTran.dart';
import 'package:nvs_trading/data/services/changePassword.dart';
import 'package:nvs_trading/data/services/generalOTP.dart';
import 'package:nvs_trading/data/services/generalOTPnoAuth.dart';
import 'package:nvs_trading/data/services/getOTPCode.dart';
import 'package:nvs_trading/data/services/updatePassword.dart';
import 'package:nvs_trading/presentation/view/expand/smart_otp/thietlapmaPin/registerOTP.dart';
import 'package:nvs_trading/presentation/view/login/login.dart';
import 'package:nvs_trading/presentation/view/search_account/result_account.dart';
import 'package:nvs_trading/presentation/view/shared/smartOTPSuccess.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:nvs_trading/presentation/view/new_account/pay_nice_number.dart';

class OTP extends StatefulWidget {
  OTP({
    super.key,
    required this.options,
    this.idCode,
    this.phone,
    this.custodycd,
    this.oldPass,
    this.newPass,
    this.confirmPass,
    this.responseData,
    this.type,
    this.acctno,
    this.bankAccTno,
    this.bankId,
    this.feeType,
    this.moneyTranfer,
    this.note,
  });
  //tra cuu
  String? idCode;
  String? phone;
  String? custodycd;
  //doi mk
  String? oldPass;
  String? newPass;
  String? confirmPass;
  //money out bank
  String? acctno;
  String? bankAccTno;
  String? bankId;
  String? feeType;
  String? moneyTranfer;
  String? note;

  //chung
  String? type;
  String options = "";
  List<OTPInfo>? responseData;

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  late int seconds;
  late Timer timer;
  late String phoneLastThree;

  String enteredOTP = "";

  List<TextEditingController?> otpcontroller =
      List.generate(6, (index) => TextEditingController());

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    if (widget.responseData != null && widget.responseData!.isNotEmpty) {
      seconds = int.parse(widget.responseData!.first.otpTime);
      phoneLastThree = widget.responseData!.first.phoneLastThree;
    }
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (Timer timer) {
      if (!mounted) {
        timer.cancel();
      } else {
        if (seconds > 0) {
          setState(() {
            seconds--;
          });
        } else {
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Hủy bỏ timer trước khi dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customTextStyleAppbar(text: "Xác nhận mã"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 14,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: customTextStyleBody(
                text: "Nhập mã OTP",
                size: 28,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            customTextStyleBody(
              text: "Vui lòng nhập mã.",
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
            customTextStyleBody(
              color: Theme.of(context).textTheme.titleSmall!.color!,
              text:
                  "Mã OTP đã được gửi về số điện thoại \n *******$phoneLastThree của bạn.",
              txalign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: OtpTextField(
                cursorColor: Theme.of(context).primaryColor,
                textStyle: const TextStyle(fontSize: 30),
                numberOfFields: 6,
                handleControllers: (controllers) {
                  otpcontroller = controllers;
                },
                // showFieldAsBox: true,
                focusedBorderColor: const Color(0xFFEE7420),
                onSubmit: (String verificationCode) {
                  setState(() {
                    enteredOTP = verificationCode;
                  });
                },
              ),
            ),
            customTextStyleBody(
              text: "Bạn chưa nhận được mã OTP?",
              size: 13,
              color: Theme.of(context).primaryColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: (seconds != 0)
                      ? null
                      : () async {
                          switch (widget.type) {
                            case "FORGOTUSERNAME":
                              widget.responseData = await generalOTPnoAuth(
                                  widget.type!,
                                  widget.idCode!,
                                  widget.phone!,
                                  " ");
                            case "FORGOTPASS":
                              widget.responseData = await generalOTPnoAuth(
                                  widget.type!, widget.custodycd!, "", "");
                            case "CHANGEPASS":
                              widget.responseData = await generalOTPAuth(
                                widget.type!,
                                widget.oldPass!,
                                widget.newPass!,
                                widget.confirmPass!,
                                HydratedBloc.storage.read('token'),
                              );
                            case "CHANGEPASSTRAN":
                              widget.responseData = await generalOTPAuth(
                                widget.type!,
                                widget.oldPass!,
                                widget.newPass!,
                                widget.confirmPass!,
                                HydratedBloc.storage.read('token'),
                              );
                            case "TRANSFERMONEY":
                              widget.responseData = await generalOTPAuth(
                                widget.type!,
                                "",
                                "",
                                "",
                                HydratedBloc.storage.read('token'),
                              );
                            default:
                              Null;
                          }
                          setState(
                            () {
                              seconds =
                                  int.parse(widget.responseData!.first.otpTime);
                              startTimer();
                            },
                          );
                        },
                  child: customTextStyleBody(
                    text: "Gửi lại OTP",
                    color: (seconds != 0)
                        ? Theme.of(context).hintColor
                        : const Color(0xFFEE7420),
                  ),
                ),
                Text(
                  '(${seconds}s)',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.primary,
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
            switch (widget.options) {
              case "pay_nice_number":
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const PayNiceNumber()),
                );
                break;
              case "change_pass_login":
                String otpId = "";
                if (widget.responseData!.isNotEmpty) {
                  otpId = widget.responseData!.first.otpId;
                }
                String trueOTP = await getOTPCode(otpId);

                if (enteredOTP == trueOTP && seconds > 0) {
                  final response = await ChangePassword(
                    otpId,
                    trueOTP,
                    widget.oldPass!,
                    widget.newPass!,
                    widget.confirmPass!,
                    HydratedBloc.storage.read('token'),
                  );
                  if (response == 200) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          contentPadding:
                              const EdgeInsets.only(top: 40, bottom: 32),
                          actionsPadding: const EdgeInsets.only(bottom: 40),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customTextStyleBody(
                                text: "Đổi mật khẩu thành công",
                                size: 18,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              customTextStyleBody(
                                text:
                                    "Vui lòng trở lại màn hình đăng nhập để tiếp tục!",
                                size: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          actions: [
                            const SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(180, 36),
                                  backgroundColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                    (route) => false,
                                  );
                                },
                                child: customTextStyleBody(
                                  text: "Đóng",
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Icon(
                          Icons.cancel,
                          size: 50,
                          color: Colors.red,
                        ),
                        content: customTextStyleBody(
                          text: seconds == 0
                              ? "Thời hạn mã OTP đã hết.\n Vui lòng ấn Gửi lại mã!"
                              : "Sai mã OTP",
                          color: Colors.red,
                          size: 20,
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  for (var controller in otpcontroller) {
                                    controller!.clear();
                                  }
                                  setState(() {
                                    enteredOTP = "";
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: customTextStyleBody(text: "Nhập lại"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
                break;
              case "change_pass_trans":
                String otpId = "";
                if (widget.responseData!.isNotEmpty) {
                  otpId = widget.responseData!.first.otpId;
                }
                String trueOTP = await getOTPCode(otpId);

                if (enteredOTP == trueOTP && seconds > 0) {
                  final response = await ChangePasswordTran(
                    otpId,
                    trueOTP,
                    widget.oldPass!,
                    widget.newPass!,
                    widget.confirmPass!,
                    HydratedBloc.storage.read('token'),
                  );
                  if (response == 200) {
                    // fToast.showToast(
                    //   child: msgNotification(
                    //     color: Colors.green,
                    //     icon: Icons.check_circle,
                    //     text: "Đổi mật khẩu giao dịch thành công",
                    //   ),
                    //   gravity: ToastGravity.TOP,
                    //   toastDuration: const Duration(seconds: 2),
                    // );
                    // await Future.delayed(const Duration(seconds: 2));
                    // for (var i = 0; i < 2; i++) {
                    //   Navigator.of(context).pop();
                    // }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          contentPadding:
                              const EdgeInsets.only(top: 40, bottom: 32),
                          actionsPadding: const EdgeInsets.only(bottom: 40),
                          content: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                customTextStyleBody(
                                  text: "Đổi mật khẩu giao dịch thành công",
                                  size: 18,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                customTextStyleBody(
                                  text:
                                      "Bạn đã đổi mật khẩu giao dịch thành công!\n Vui lòng thoát ra và sử dụng mật khẩu mới!",
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            const SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(180, 36),
                                  backgroundColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: customTextStyleBody(
                                  text: "Đóng",
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Icon(
                          Icons.cancel,
                          size: 50,
                          color: Colors.red,
                        ),
                        content: customTextStyleBody(
                          text: seconds == 0
                              ? "Thời hạn mã OTP đã hết.\n Vui lòng ấn Gửi lại mã!"
                              : "Sai mã OTP",
                          color: Colors.red,
                          size: 20,
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  for (var controller in otpcontroller) {
                                    controller!.clear();
                                  }
                                  setState(() {
                                    enteredOTP = "";
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: customTextStyleBody(text: "Nhập lại"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
                break;
              case "thietlapmaPin":
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OTPSuccess(
                      textSuccess: "Thiết lập mã PIN\nthành công",
                    ),
                  ),
                );
              case "thaydoimaPin":
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OTPSuccess(
                      textSuccess: "Đổi mã PIN thành công",
                    ),
                  ),
                );
              case "quenmaPin":
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegisterOTP(typeOTP: 'forget')));
              case "tracuuSTK":
                String otpId = "";
                if (widget.responseData!.isNotEmpty) {
                  otpId = widget.responseData!.first.otpId;
                }
                String trueOTP = await getOTPCode(otpId);
                if (enteredOTP == trueOTP && seconds > 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ResultAccount(
                          idCode: widget.idCode!,
                          otpId: otpId,
                          otpCode: trueOTP,
                          phone: widget.phone!)));
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Icon(
                          Icons.cancel,
                          size: 50,
                          color: Colors.red,
                        ),
                        content: customTextStyleBody(
                          text: seconds == 0
                              ? "Thời hạn mã OTP đã hết.\n Vui lòng ấn Gửi lại mã!"
                              : "Sai mã OTP",
                          color: Colors.red,
                          size: 20,
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .background,
                                ),
                                onPressed: () {
                                  for (var controller in otpcontroller) {
                                    controller!.clear();
                                  }
                                  setState(() {
                                    enteredOTP = "";
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: customTextStyleBody(
                                  text: "Nhập lại",
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
              case "quenPass":
                String otpId = "";
                if (widget.responseData!.isNotEmpty) {
                  otpId = widget.responseData!.first.otpId;
                }
                String trueOTP = await getOTPCode(otpId);
                if (enteredOTP == trueOTP && seconds > 0) {
                  final response = await updatePassword(
                      widget.custodycd!, widget.newPass!, trueOTP, otpId);
                  if (response == 200) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: customTextStyleBody(
                            text: "Cập nhật thông tin thành công!",
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customTextStyleBody(
                                text: "Bạn đã đổi mật khẩu thành công",
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .background,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                                child: customTextStyleBody(
                                  text: "Đăng nhập",
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Icon(
                          Icons.cancel,
                          size: 50,
                          color: Colors.red,
                        ),
                        content: customTextStyleBody(
                          text: seconds == 0
                              ? "Thời hạn mã OTP đã hết.\n Vui lòng ấn Gửi lại mã!"
                              : "Sai mã OTP",
                          color: Colors.red,
                          size: 20,
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .background,
                                ),
                                onPressed: () {
                                  for (var controller in otpcontroller) {
                                    controller!.clear();
                                  }
                                  setState(() {
                                    enteredOTP = "";
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: customTextStyleBody(
                                  text: "Nhập lại",
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
              case 'moneyoutbank':
                String otpId = "";
                if (widget.responseData!.isNotEmpty) {
                  otpId = widget.responseData!.first.otpId;
                }
                String trueOTP = await getOTPCode(otpId);
                if (enteredOTP == trueOTP && seconds > 0) {
                  final res = await bankTransfer(
                    widget.acctno!,
                    widget.bankAccTno!,
                    widget.bankId!,
                    widget.feeType!,
                    widget.moneyTranfer!,
                    widget.note!,
                    trueOTP,
                    otpId,
                  );
                  if (res.statusCode == 200) {
                    fToast.showToast(
                      gravity: ToastGravity.TOP,
                      toastDuration: const Duration(seconds: 2),
                      child: msgNotification(
                        color: Colors.green,
                        icon: Icons.check_circle,
                        text: "Thành công! ${res.data['message']}",
                      ),
                    );
                    for (var i = 0; i < 3; i++) {
                      Navigator.of(context).pop();
                    }
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Icon(
                          Icons.cancel,
                          size: 50,
                          color: Colors.red,
                        ),
                        content: customTextStyleBody(
                          text: seconds == 0
                              ? "Thời hạn mã OTP đã hết.\n Vui lòng ấn Gửi lại mã!"
                              : "Sai mã OTP",
                          color: Colors.red,
                          size: 20,
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  for (var controller in otpcontroller) {
                                    controller!.clear();
                                  }
                                  setState(() {
                                    enteredOTP = "";
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: customTextStyleBody(text: "Nhập lại"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }

                break;
              default:
                Null;
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
}
