import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/services/changeOTPmethod.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getOTPmethod.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryOTP extends StatefulWidget {
  const DeliveryOTP({super.key});

  @override
  State<DeliveryOTP> createState() => _DeliveryOTPState();
}

class _DeliveryOTPState extends State<DeliveryOTP> {
  late List<dynamic> responseOTP;
  var isDeliverySelected;
  String phuongthuc1 = "";
  String phuongthuc2 = "";
  String phuongthuc3 = "";

  bool _initComplete = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    getOTPmethod().then((_) {
      setState(() {
        _initComplete = true; // Đánh dấu rằng initState đã hoàn thành
      });
    });
  }

  Future<void> getOTPmethod() async {
    responseOTP = await GetOTPMethod(
      HydratedBloc.storage.read('custodycd'),
      HydratedBloc.storage.read('token'),
    );
    if (responseOTP.isNotEmpty) {
      isDeliverySelected = responseOTP.first['otprecv'];
    }
    print(isDeliverySelected);
    print(responseOTP);
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocal.deliveryOTP),
      body: !_initComplete
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : FutureBuilder(
              future: GetAllCode(
                  "API", "OTPRECV", HydratedBloc.storage.read('token')),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  final responseData = snapshot.data ?? [];
                  for (var i in responseData) {
                    switch (i['cdval']) {
                      case 'SMS':
                        phuongthuc1 = i['vN_CDCONTENT'];
                      case 'SMART':
                        phuongthuc2 = i['vN_CDCONTENT'];
                      case '2FA':
                        phuongthuc3 = i['vN_CDCONTENT'];
                    }
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 16),
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: ListTile(
                            title: customTextStyleBody(
                              text: phuongthuc2,
                              size: 16,
                              fontWeight: FontWeight.w400,
                              txalign: TextAlign.start,
                              color: Theme.of(context).primaryColor,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xff292D38),
                              child: SvgPicture.asset(
                                  "assets/icons/Base-lock-password.svg"),
                            ),
                            trailing: GestureDetector(
                              child: (isDeliverySelected == "1")
                                  ? const Icon(
                                      Icons.radio_button_checked,
                                      color: Color(0xff4FD08A),
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.radio_button_off,
                                      color: Color(0xff595E72),
                                      size: 20,
                                    ),
                              onTap: () {
                                setState(() {
                                  isDeliverySelected = "1";
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: ListTile(
                            title: customTextStyleBody(
                              text: phuongthuc1,
                              size: 16,
                              fontWeight: FontWeight.w400,
                              txalign: TextAlign.start,
                              color: Theme.of(context).primaryColor,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xff292D38),
                              child: SvgPicture.asset(
                                  "assets/icons/cellphone.svg"),
                            ),
                            trailing: GestureDetector(
                              child: (isDeliverySelected == "0")
                                  ? const Icon(
                                      Icons.radio_button_checked,
                                      color: Color(0xff4FD08A),
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.radio_button_off,
                                      color: Color(0xff595E72),
                                      size: 20,
                                    ),
                              onTap: () {
                                setState(() {
                                  isDeliverySelected = "0";
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: ListTile(
                            title: customTextStyleBody(
                              text: phuongthuc3,
                              size: 16,
                              fontWeight: FontWeight.w400,
                              txalign: TextAlign.start,
                              color: Theme.of(context).primaryColor,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xff292D38),
                              child: SvgPicture.asset(
                                  "assets/icons/Other-shield-star.svg"),
                            ),
                            trailing: GestureDetector(
                              child: (isDeliverySelected == "2")
                                  ? const Icon(
                                      Icons.radio_button_checked,
                                      color: Color(0xff4FD08A),
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.radio_button_off,
                                      color: Color(0xff595E72),
                                      size: 20,
                                    ),
                              onTap: () {
                                setState(() {
                                  isDeliverySelected = "2";
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
      bottomSheet: Container(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).buttonTheme.colorScheme!.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            _changeOTPMethod();
          },
          child: customTextStyleBody(
            text: appLocal.buttonForm('confirm'),
            size: 14,
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _changeOTPMethod() async {
    int? res;
    if (isDeliverySelected == "1") {
      res = await ChangeOTPMethod(
        HydratedBloc.storage.read('custodycd'),
        "SMART",
        HydratedBloc.storage.read('token'),
      );
    } else if (isDeliverySelected == "0") {
      res = await ChangeOTPMethod(
        HydratedBloc.storage.read('custodycd'),
        "SMS",
        HydratedBloc.storage.read('token'),
      );
    } else {
      res = await ChangeOTPMethod(
        HydratedBloc.storage.read('custodycd'),
        "2FA",
        HydratedBloc.storage.read('token'),
      );
    }
    if (res == 200) {
      fToast.showToast(
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 2),
        child: msgNotification(
          color: Colors.green,
          icon: Icons.check_circle,
          text: "Đổi phương thức OTP thành công",
        ),
      );
    }
    await getOTPmethod();
  }
}
