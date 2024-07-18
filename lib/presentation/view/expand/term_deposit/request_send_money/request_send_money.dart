// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/get_account_detail.dart';
import 'package:nvs_trading/data/model/info_bank_interest_rate.dart';
import 'package:nvs_trading/data/model/partner_bank.dart';
import 'package:nvs_trading/data/services/getAccountDetail.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getBankSaving.dart';
import 'package:nvs_trading/data/services/getBusDate.dart';
import 'package:nvs_trading/data/services/getPartnerBank.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/request_send_money/confirm_request.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestSendMoney extends StatefulWidget {
  RequestSendMoney({
    super.key,
    required this.bankName,
    required this.kyhan,
  });

  String bankName;
  var kyhan;

  @override
  State<RequestSendMoney> createState() => _RequestSendMoneyState();
}

class _RequestSendMoneyState extends State<RequestSendMoney> {
  TextEditingController moneySend = TextEditingController();
  var _nganhang;

  var _kyhan;
  String nameKyhan = "";
  var _httaituc;
  String namehttt = "";

  List<GetAccountDetailModel> responseCustomer = [];
  String busDate = "";
  List<PartnerBankModel> responseBank = [];
  List<BankInterestRateInfo> responseKyhan = [];
  List<dynamic> responseTaiTuc = [];
  String token = HydratedBloc.storage.read('token');

  double rate = 0;
  double pre_rate = 0;
  String acctno = HydratedBloc.storage.read('acctno');
  int indexCustomer = 0;

  String _errorMoneySend = "";

  bool checkMoney = true;
  bool checkIsEditMoney = false;
  @override
  void initState() {
    super.initState();
    fetchBusDate();
    fetchDataCustomer();
    fetchDataBank();
    fetchTaiTuc();
    if (widget.bankName != "") {
      _nganhang = widget.bankName;
      fetchKyhan(_nganhang);
    }

    moneySend.addListener(updateValue);
  }

  void fetchBusDate() async {
    try {
      final response = await GetBusDate(HydratedBloc.storage.read('token'));
      if (response.statusCode == 200) {
        setState(() {
          busDate = response.data['dateserver'];
        });
        print(busDate);
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchDataCustomer() async {
    try {
      final List<GetAccountDetailModel> response =
          await GetAccountDetail(HydratedBloc.storage.read('custodycd'));
      setState(() {
        responseCustomer = response;
        indexCustomer = responseCustomer.indexWhere((e) => e.acctno == acctno);
      });
      print("acctno: ${responseCustomer.first.acctno}");
    } catch (e) {
      print("Error: $e");
    }
  }

  void fetchDataBank() async {
    try {
      final List<PartnerBankModel> partnerBanks = await GetPartnerBank(token);
      setState(() {
        responseBank = partnerBanks;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void fetchKyhan(dynamic nganhang) async {
    try {
      final List<BankInterestRateInfo> res =
          await GetBankSaving(nganhang, "ALL", token);
      setState(() {
        responseKyhan = res;
      });
      if (widget.kyhan != "") {
        _kyhan = widget.kyhan;
        setState(() {
          nameKyhan =
              responseKyhan[responseKyhan.indexWhere((e) => e.period == _kyhan)]
                  .perIod_Name;
          rate =
              responseKyhan[responseKyhan.indexWhere((e) => e.period == _kyhan)]
                  .rate;
          pre_rate =
              responseKyhan[responseKyhan.indexWhere((e) => e.period == _kyhan)]
                  .pre_Rate;
        });
      }
    } catch (e) {
      print("Mã lỗi: $e");
    }
  }

  void fetchTaiTuc() async {
    try {
      final response = await GetAllCode("API", "MATURITYFORM", token);
      setState(() {
        responseTaiTuc = response;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void updateValue() {
    final text = moneySend.text.replaceAll(RegExp(r','), '');
    if (text.isNotEmpty) {
      checkIsEditMoney = true;
      final value = int.parse(text);
      final formattedValue = Utils().formatNumber(value);
      if (moneySend.text != formattedValue) {
        moneySend.value = moneySend.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      }
      if (value == 0) {
        setState(() {
          _errorMoneySend = "Số tiền gửi phải khác 0";
          checkMoney = true;
        });
      } else if (value > responseCustomer[indexCustomer].balance) {
        setState(() {
          _errorMoneySend = "Phải nhỏ hơn hoặc bằng số dư tiền";
          checkMoney = true;
        });
      } else {
        setState(() {
          _errorMoneySend = "";
          checkMoney = false;
        });
      }
      if (checkMoney == false) {
        if (value > 10000000) {
          setState(() {
            checkMoney = true;
          });
        } else {
          setState(() {
            checkMoney = false;
          });
        }
      }
    } else if (checkIsEditMoney == true && text.isEmpty) {
      setState(() {
        _errorMoneySend = "Số tiền gửi không được để trống";
        checkMoney = true;
      });
    }
  }

  @override
  void dispose() {
    moneySend.removeListener(updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocal.requestSendMoney('title')),
      body: (responseCustomer.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text1(
                      titleText: appLocal.requestSendMoney('account'),
                      contentText: responseCustomer[indexCustomer].acctno,
                    ),
                    Text1(
                      titleText: appLocal.requestSendMoney('custName'),
                      contentText: responseCustomer[indexCustomer].fullname,
                    ),
                    Text1(
                      titleText: appLocal.requestSendMoney('balance'),
                      contentText: Utils()
                          .formatNumber(responseCustomer[indexCustomer].balance)
                          .toString(),
                    ),
                    Text1(
                      titleText: appLocal.requestSendMoney('min'),
                      contentText: "1",
                    ),
                    Text1(
                      titleText: appLocal.requestSendMoney('max'),
                      contentText: Utils()
                          .formatNumber(responseCustomer[indexCustomer].balance)
                          .toString(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 12),
                      child: customTextStyleBody(
                        text: appLocal.requestSendMoney('sendbank'),
                        size: 16,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: "${appLocal.requestSendMoney('bank')} *",
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            height: 36,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                value: _nganhang,
                                onChanged: (value) {
                                  setState(() {
                                    _nganhang = value;
                                    // bankName = responseBank[
                                    //         responseBank.indexWhere(
                                    //             (e) => e.bankId == _nganhang)]
                                    //     .bankName;
                                    _kyhan = null;
                                    rate = 0;
                                    pre_rate = 0;
                                  });
                                  fetchKyhan(_nganhang);
                                },
                                items: [
                                  for (var i in responseBank)
                                    DropdownMenuItem(
                                      value: i.bankId,
                                      child: Text(
                                        "${i.bankId} - ${i.bankName}",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text:
                                "${appLocal.requestSendMoney('depositamount')} *",
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            width: 200,
                            height: (_errorMoneySend != "") ? 56 : 36,
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              cursorColor: Theme.of(context).primaryColor,
                              controller: moneySend,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                errorText: (_errorMoneySend != "")
                                    ? _errorMoneySend
                                    : null,
                                errorStyle: const TextStyle(fontSize: 10),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                isDense: false,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).hintColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).hintColor),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 8, left: 16),
                                hintText:
                                    appLocal.requestSendMoney('depositamount'),
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !checkMoney,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 22,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    moneySend.text =
                                        "${moneySend.value.text}000";
                                  });
                                },
                                child: customTextStyleBody(
                                  text: Utils().formatNumber(int.parse(
                                      "${moneySend.value.text}000"
                                          .replaceAll(',', ''))),
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              height: 22,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    moneySend.text =
                                        "${moneySend.value.text}00000";
                                  });
                                },
                                child: customTextStyleBody(
                                  text: Utils().formatNumber(int.parse(
                                      "${moneySend.value.text}00000"
                                          .replaceAll(',', ''))),
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              height: 22,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    moneySend.text =
                                        "${moneySend.value.text}000000";
                                  });
                                },
                                child: customTextStyleBody(
                                  text: Utils().formatNumber(int.parse(
                                      "${moneySend.value.text}000000"
                                          .replaceAll(',', ''))),
                                  size: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: appLocal.requestSendMoney('daterequest'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8),
                            width: 200,
                            child: customTextStyleBody(
                              text: DateFormat("dd/MM/yyyy")
                                  .format(DateTime.parse(busDate)),
                              color: Theme.of(context).primaryColor,
                              txalign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text:
                                "${appLocal.requestSendMoney('depositterm')} *",
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            height: 36,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: const Text("Lựa chọn"),
                                style: const TextStyle(fontSize: 12),
                                value: _kyhan,
                                onChanged: (value) {
                                  setState(() {
                                    _kyhan = value;
                                    nameKyhan = responseKyhan[
                                            responseKyhan.indexWhere(
                                                (e) => e.period == _kyhan)]
                                        .perIod_Name;
                                    rate = responseKyhan[
                                            responseKyhan.indexWhere(
                                                (e) => e.period == _kyhan)]
                                        .rate;
                                    pre_rate = responseKyhan[
                                            responseKyhan.indexWhere(
                                                (e) => e.period == _kyhan)]
                                        .pre_Rate;
                                  });
                                },
                                items: [
                                  for (var i in responseKyhan)
                                    DropdownMenuItem(
                                      value: i.period,
                                      child: Text(
                                        i.perIod_Name,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text1(
                      titleText: appLocal.requestSendMoney('interestRate'),
                      contentText: "$rate %/1 năm",
                    ),
                    Text1(
                      titleText: appLocal.requestSendMoney('preInterestRate'),
                      contentText: "$pre_rate %/1 năm",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: "${appLocal.requestSendMoney('renewal')} *",
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            height: 36,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                style: const TextStyle(fontSize: 12),
                                value: _httaituc,
                                onChanged: (value) {
                                  setState(() {
                                    _httaituc = value;
                                    namehttt = responseTaiTuc[
                                            responseTaiTuc.indexWhere(
                                                (e) => e['cdval'] == _httaituc)]
                                        ['vN_CDCONTENT'];
                                  });
                                },
                                items: [
                                  for (var i in responseTaiTuc)
                                    DropdownMenuItem(
                                      value: i['cdval'],
                                      child: customTextStyleBody(
                                        text: "${i['vN_CDCONTENT']}",
                                        size: 14,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customTextStyleBody(
                            text: appLocal.requestSendMoney('maturitydate'),
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(context).hintColor,
                              ),
                              color: Theme.of(context).hintColor,
                            ),
                            width: 200,
                            height: 36,
                            child: customTextStyleBody(
                              text: (ngaydaohan() == "")
                                  ? ngaydaohan()
                                  : DateFormat('dd/MM/yyyy')
                                      .format(DateTime.parse(ngaydaohan())),
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                              txalign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: customTextStyleBody(
                              text: appLocal.requestSendMoney('receiveAccount'),
                              color: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .color!,
                              fontWeight: FontWeight.w400,
                              txalign: TextAlign.start,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(context).hintColor,
                              ),
                              color: Theme.of(context).hintColor,
                            ),
                            width: 200,
                            height: 36,
                            child: customTextStyleBody(
                              text: responseCustomer[indexCustomer].acctno,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                              txalign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
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
            backgroundColor:
                Theme.of(context).buttonTheme.colorScheme!.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (_nganhang == null ||
                moneySend.text.isEmpty ||
                _kyhan == null ||
                _httaituc == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Không được để trống các trường bắt buộc nhập(*)",
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ConfirmRequest(
                    acctno: responseCustomer[indexCustomer].acctno,
                    moneySend: moneySend.text,
                    bankChoice: _nganhang,
                    busDate: busDate,
                    kyhan: _kyhan,
                    nameKyhan: nameKyhan,
                    httaituc: _httaituc,
                    nameHttt: namehttt,
                    rate: rate,
                    ngaydaohan: ngaydaohan(),
                  ),
                ),
              );
            }
          },
          child: customTextStyleBody(
            text: appLocal.buttonForm('continue'),
            size: 14,
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String ngaydaohan() {
    if (_kyhan.toString().endsWith('W')) {
      DateTime currentDate = DateTime.parse(busDate);
      int sotuan = int.parse(_kyhan.toString().substring(0, 1));
      DateTime ngaydaohan = currentDate.add(Duration(days: sotuan * 7));
      return ngaydaohan.toString();
    } else if (_kyhan.toString().endsWith('M')) {
      DateTime currentDate = DateTime.parse(busDate);
      int sothang = int.parse(_kyhan.toString().substring(0, 1));
      final newMonth = (currentDate.month + sothang) % 12;
      final newYear = currentDate.year + ((currentDate.month + sothang) ~/ 12);
      final newDay = currentDate.day;
      DateTime ngaydaohan = DateTime(newYear, newMonth, newDay);
      return ngaydaohan.toString();
    }
    return "";
  }
}

class Text1 extends StatelessWidget {
  Text1({
    super.key,
    required this.titleText,
    required this.contentText,
  });
  String titleText;
  String contentText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: titleText,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
          ),
          customTextStyleBody(
            text: contentText,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
