import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/money_saving_model.dart';
import 'package:nvs_trading/data/model/partner_bank.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getBusDate.dart';
import 'package:nvs_trading/data/services/getPartnerBank.dart';
import 'package:nvs_trading/data/services/moneySaving.dart';
import 'package:nvs_trading/presentation/view/expand/term_deposit/list_send_money/send_money_detail.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListSendMoney extends StatefulWidget {
  const ListSendMoney({super.key});

  @override
  State<ListSendMoney> createState() => _ListSendMoneyState();
}

class _ListSendMoneyState extends State<ListSendMoney> {
  String acctno = HydratedBloc.storage.read('acctno');
  var _selectedBank;
  var _selectedStatus;
  final MultiSelectController<String> selectStatus = MultiSelectController();
  List<ValueItem<String>> selectedOptionsStatus = [];
  List<ValueItem<String>> listOptionsStatus = [];

  String token = HydratedBloc.storage.read('token');
  String busDate = "";
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();

  List<PartnerBankModel> responseBank = [];
  List<dynamic> responseStatus = [];

  List<MoneySavingModel> responseMoneySaving = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBusDate();
    fetchDataBank();
    fetchStatus();
  }

  void fetchBusDate() async {
    try {
      final response = await GetBusDate(HydratedBloc.storage.read('token'));
      if (response.statusCode == 200) {
        setState(() {
          busDate = response.data['dateserver'];
        });
        _startDate.text =
            DateFormat('dd/MM/yyyy').format(DateTime.parse(busDate));
        _endDate.text =
            DateFormat('dd/MM/yyyy').format(DateTime.parse(busDate));
        print(busDate);
      }
      fetchMoneySaving();
    } catch (e) {
      print(e);
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

  void fetchStatus() async {
    try {
      final response = await GetAllCode("API", "MNSSTATUS", token);
      if (response.isNotEmpty) {
        setState(() {
          responseStatus = response;
        });
        for (var i in responseStatus) {
          listOptionsStatus.add(
            ValueItem(
              label: i['vN_CDCONTENT'],
              value: i['cdval'],
            ),
          );
        }
        print(listOptionsStatus);
      } else {
        print("Lỗi call status");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void fetchMoneySaving() async {
    try {
      final response = await getMoneySaving(
          HydratedBloc.storage.read('custodycd'),
          acctno,
          _startDate.text,
          _endDate.text,
          (_selectedBank != null) ? _selectedBank : "ALL",
          (_selectedStatus != null) ? _selectedStatus : "ALL",
          '1',
          '10');
      setState(() {
        responseMoneySaving = response;
      });
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;

    return listOptionsStatus.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : Scaffold(
            appBar: appBar(text: appLocal.listSendMoney('title')),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    padding: const EdgeInsets.all(8),
                    height: 36,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_search.svg",
                          width: 20,
                          height: 20,
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              value: _selectedBank,
                              hint: customTextStyleBody(
                                text: appLocal.listSendMoney('bank'),
                                size: 14,
                                color: Theme.of(context).hintColor,
                              ),
                              iconStyleData: const IconStyleData(
                                iconSize: 20,
                                icon: Icon(Icons.keyboard_arrow_down),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBank = value!;
                                });
                                fetchMoneySaving();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16, left: 16),
                        width: 161.5,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        padding: const EdgeInsets.only(left: 8, bottom: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _startDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  hintText: "DD/MM/YYYY",
                                  border: InputBorder.none,
                                  suffixIcon:
                                      Image.asset("assets/icons/Vector.png"),
                                ),
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateFormat('dd/MM/yyyy')
                                        .parse(_startDate.text),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary:
                                                Colors.green, // Màu sắc chính
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _startDate.text = DateFormat('dd/MM/yyyy')
                                          .format(picked);
                                    });
                                    fetchMoneySaving();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16, right: 16),
                        width: 161.5,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        padding: const EdgeInsets.only(left: 8, bottom: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _endDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  hintText: "DD/MM/YYYY",
                                  border: InputBorder.none,
                                  suffixIcon:
                                      Image.asset("assets/icons/Vector.png"),
                                ),
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateFormat('dd/MM/yyyy')
                                        .parse(_endDate.text),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary:
                                                Colors.green, // Màu sắc chính
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _endDate.text = DateFormat('dd/MM/yyyy')
                                          .format(picked);
                                    });
                                    fetchMoneySaving();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 162,
                          height: 36,
                          child: MultiSelectDropDown(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4, left: 6),
                            controller: selectStatus,
                            hint: "Trạng thái",
                            hintColor: Theme.of(context).hintColor,
                            hintPadding: const EdgeInsets.only(left: 4),
                            inputDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onOptionSelected: (options) {
                              selectedOptionsStatus = options;
                              setState(() {
                                _selectedStatus = selectedOptionsStatus
                                    .map((e) => e.value)
                                    .join(',');
                              });
                              fetchMoneySaving();
                            },
                            options: listOptionsStatus,
                            maxItems: 4,
                            chipConfig: ChipConfig(
                              wrapType: WrapType.scroll,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              labelStyle: const TextStyle(fontSize: 10),
                              deleteIconColor: Theme.of(context).hintColor,
                              radius: 8,
                              padding: const EdgeInsets.only(
                                left: 4,
                                right: 2,
                                bottom: 12,
                              ),
                            ),
                            dropdownBackgroundColor:
                                Theme.of(context).colorScheme.primary,
                            optionTextStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Theme.of(context).hintColor,
                            ),
                            onOptionRemoved: (index, option) {},
                            optionBuilder: (context, valueItem, isSelected) {
                              return ListTile(
                                title: customTextStyleBody(
                                  text: valueItem.label,
                                  size: 14,
                                  color: Theme.of(context).primaryColor,
                                  txalign: TextAlign.start,
                                ),
                                leading: isSelected
                                    ? Icon(
                                        Icons.check_box,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      )
                                    : const Icon(
                                        Icons.check_box_outline_blank,
                                      ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 36,
                          width: 161,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedBank = null;
                                _selectedStatus = null;
                                _startDate.text = DateFormat('dd/MM/yyyy')
                                    .format(DateTime.parse(busDate));
                                _endDate.text = DateFormat('dd/MM/yyyy')
                                    .format(DateTime.parse(busDate));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: customTextStyleBody(
                              text: appLocal.buttonForm('clearFilter'),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  for (var i in responseMoneySaving)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SendMoneyDetail(
                              pSavingId: i.savingId,
                              bankCode: i.bankSavingCode,
                              bankname: i.bankName,
                              afacctno: acctno,
                              moneySend: i.balance,
                              rate_val: i.rate_val,
                              rate: i.rate,
                              period_Name: i.period_Name,
                              frDate: i.frDate,
                              toDate: i.toDate,
                              hinhThucDaoHan_Name: i.hinhThucDaoHan_Name,
                              numReNew: i.numReNew,
                              status: i.status,
                              status_Name: (appLocal.localeName == 'vi')
                                  ? i.status_Name
                                  : i.status_Name_En,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            bottom: 8, left: 16, right: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/svg/bank/${i.bankSavingCode}.svg'),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTextStyleBody(
                                      text: appLocal
                                          .listSendMoney('depositamount'),
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      size: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    customTextStyleBody(
                                      text:
                                          "${Utils().formatNumber(int.parse(i.balance))} VND",
                                      color: Theme.of(context).primaryColor,
                                      size: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    customTextStyleBody(
                                      text: DateFormat('dd/MM/yyyy')
                                          .format(DateTime.parse(i.toDate)),
                                      color: Theme.of(context).primaryColor,
                                      size: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: customTextStyleBody(
                                        text: "${i.rate} %/năm",
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                SizedBox(
                                  width: 60,
                                  child: customTextStyleBody(
                                    text: (appLocal.localeName == 'vi')
                                        ? i.status_Name
                                        : i.status_Name_En,
                                    color: (i.status == "A")
                                        ? Colors.green
                                        : (i.status == "P")
                                            ? Colors.orange
                                            : (i.status == "C")
                                                ? Theme.of(context).primaryColor
                                                : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
  }
}
