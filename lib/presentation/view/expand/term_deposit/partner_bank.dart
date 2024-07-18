// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/partner_bank.dart';
import 'package:nvs_trading/data/services/getPartnerBank.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/request_send_money/request_send_money.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/notifications_controller.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PartnerBank extends StatefulWidget {
  const PartnerBank({super.key});

  @override
  State<PartnerBank> createState() => _PartnerBankState();
}

class _PartnerBankState extends State<PartnerBank> {
  int currentPageIndex = 0;
  late String token;
  late List<PartnerBankModel> response = [];

  @override
  void initState() {
    super.initState();
    _fetchPartnerBank();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationsController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationsController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationsController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationsController.onDismissActionReceiveMethod,
    );
  }

  Future<void> _fetchPartnerBank() async {
    token = HydratedBloc.storage.read('token');
    try {
      final List<PartnerBankModel> partnerBanks = await GetPartnerBank(token);
      setState(() {
        response = partnerBanks;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocal.partnerBanks('title')),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 190,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.8),
                // không cách lề
                padEnds: false,
                itemCount: response.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPageIndex = value;
                  });
                },
                itemBuilder: (_, i) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/svg/bank/${response[i].bankId}.svg',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 60,
                            child: customTextStyleBody(
                              text:
                                  '${response[i].bankId}\n${response[i].bankName}',
                              fontWeight: FontWeight.w700,
                              txalign: TextAlign.start,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .background,
                              fixedSize: const Size(102, 32),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => RequestSendMoney(
                                    bankName: response[i].bankId,
                                    kyhan: "",
                                  ),
                                ),
                              );
                            },
                            child: customTextStyleBody(
                              text: appLocal.partnerBanks('deposit'),
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        // height: 52,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTextStyleBody(
                              text: appLocal.partnerBanks('depositpolicy'),
                              size: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                            TextButton(
                              onPressed: () {
                                _downloadFile();
                              },
                              child: FittedBox(
                                fit: BoxFit.none,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.download,
                                      color: Colors.blue,
                                    ),
                                    customTextStyleBody(
                                      text: appLocal.partnerBanks('download'),
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height -
                            190 -
                            52 -
                            16 * 2,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SfPdfViewer.network(
                          "http://192.168.2.55:8080/static/img/download.pdf",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _downloadFile() async {
    String fileName = "Chính sách.pdf";
    final appStorage = await getExternalStorageDirectory();
    final file = File('${appStorage!.path}/$fileName');
    print(file.path);
    const url =
        "http://192.168.2.55:8080/static/img/download.pdf"; // URL của file PDF cần tải xuống
    final Dio dio = Dio();
    try {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: "basic_channel",
          title: "Đang tải xuống",
          body: "Vui lòng đợi...",
        ),
      );
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: const Duration(seconds: 1),
        ),
      );
      await file.writeAsBytes(response.data);
      await Future.delayed(const Duration(seconds: 3));
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: "basic_channel",
          title: "Tải xuống thành công",
          body: "Đường dẫn: ${file.path}",
        ),
      );
    } catch (e) {
      print("Error downloading file: $e");
      // Xử lý khi có lỗi trong quá trình tải xuống
      // Ví dụ: Hiển thị thông báo lỗi
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: "basic_channel",
          title: "Lỗi khi tải xuống",
          body: "Đã xảy ra lỗi khi tải xuống file.",
        ),
      );
    }
  }
}
