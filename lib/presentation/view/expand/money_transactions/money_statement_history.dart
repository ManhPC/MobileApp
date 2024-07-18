import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getBusDate.dart';
import 'package:nvs_trading/data/services/getInfoCustomer.dart';
import 'package:nvs_trading/data/services/getListCashTransfer.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoneyStatement extends StatefulWidget {
  const MoneyStatement({super.key});

  @override
  State<MoneyStatement> createState() => _MoneyStatementState();
}

class _MoneyStatementState extends State<MoneyStatement> {
  String busDate = "";
  String acctno = HydratedBloc.storage.read('acctno');
  String CustodyCD = HydratedBloc.storage.read('custodycd');

  //Duoc chon
  dynamic chooseacctno;
  dynamic Status;
  final MultiSelectController<String> selectStatus = MultiSelectController();

  //ngay bat dau - ket thuc
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();

  //danh sach
  List<String> listAcctno = [];
  List<ValueItem<String>> listStatus = [];
  List<ValueItem<String>> selectedOptionsStatus = [];

  //List data
  List<dynamic> listCashTransfer = [];
  String message = "";

  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    chooseacctno = acctno;
    fetchBusDate();
    fetchCustomerInfo();
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
      }
      fetchListCash();
    } catch (e) {
      print(e);
    }
  }

  void fetchStatus() async {
    try {
      final res = await GetAllCode(
          'API', 'TRANSACTION', HydratedBloc.storage.read('token'));
      if (res.isNotEmpty) {
        for (var i in res) {
          setState(() {
            listStatus
                .add(ValueItem(label: i['vN_CDCONTENT'], value: i['cdval']));
          });
        }
        print(listStatus);
      }
    } catch (e) {
      Future.error(e);
    }
  }

  void fetchCustomerInfo() async {
    final res = await GetInfoCustomer(
      HydratedBloc.storage.read('custodycd'),
      HydratedBloc.storage.read('token'),
    );
    if (res.isNotEmpty) {
      setState(() {
        listAcctno = res.map((i) => i.acctno).toList();
      });
    }
  }

  void fetchListCash() async {
    if (Status.toString().isEmpty || Status == null) {
      Status = 'ALL';
    }
    try {
      final res = await getListCashTransfer(1, 50, Status, CustodyCD,
          chooseacctno, _startDate.text, _endDate.text);

      if (res.statusCode == 200 && res.data['message'] == 'success') {
        setState(() {
          listCashTransfer = res.data['data'];
        });
      } else {
        setState(() {
          message = res.data['message'];
        });
        fToast.showToast(
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 2),
          child: msgNotification(
            color: Colors.red,
            icon: Icons.error,
            text: message,
          ),
        );
      }
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: appBar(text: "Lịch sử chuyển tiền"),
      body: listStatus.isEmpty
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              value: chooseacctno,
                              isExpanded: true,
                              hint: Text(
                                "Tài khoản",
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 12,
                                ),
                              ),
                              iconStyleData: const IconStyleData(
                                iconSize: 20,
                                icon: Icon(Icons.keyboard_arrow_down),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  chooseacctno = value;
                                });
                                fetchListCash();
                              },
                              items: [
                                for (var i in listAcctno)
                                  DropdownMenuItem(
                                    value: i,
                                    child: Text(
                                      i,
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
                                    fetchListCash();
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
                                    fetchListCash();
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
                                Status = selectedOptionsStatus
                                    .map((e) => e.value)
                                    .join(',');
                              });

                              fetchListCash();
                            },
                            options: listStatus,
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
                              fontSize: 10,
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
                                  size: 12,
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
                                _startDate.text = DateFormat('dd/MM/yyyy')
                                    .format(DateTime.parse(busDate));
                                _endDate.text = DateFormat('dd/MM/yyyy')
                                    .format(DateTime.parse(busDate));
                                selectStatus.clearAllSelection();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: customTextStyleBody(
                              text: local.buttonForm('clearFilter'),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                    child: customTextStyleBody(
                      text: "Lịch sử chuyển tiền",
                      color: Theme.of(context).secondaryHeaderColor,
                      size: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  for (var i = 0; i < listCashTransfer.length; i++)
                    Container(
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 12),
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Column(
                        children: [
                          textListCash(
                            title: "Số tài khoản chuyển",
                            content:
                                listCashTransfer[i]['acctno'].toString().isEmpty
                                    ? "-"
                                    : listCashTransfer[i]['acctno'],
                          ),
                          textListCash(
                            title: "Loại tiền chuyển",
                            content: listCashTransfer[i]['tltxcd_name'],
                          ),
                          textListCash(
                            title: 'Thời gian giao dịch',
                            content: DateFormat('dd/MM/yyyy').format(
                                DateFormat('MM/dd/yyyy')
                                    .parse(listCashTransfer[i]['txdate'])),
                          ),
                          textListCash(
                            title: 'Số tài khoản nhận',
                            content: listCashTransfer[i]
                                        ['rev_benifician_account']
                                    .toString()
                                    .isEmpty
                                ? "-"
                                : listCashTransfer[i]['rev_benifician_account'],
                          ),
                          textListCash(
                            title: 'Tên người nhận',
                            content: listCashTransfer[i]['rev_fullname']
                                    .toString()
                                    .isEmpty
                                ? "-"
                                : listCashTransfer[i]['rev_fullname'],
                          ),
                          textListCash(
                            title: 'Ngân hàng',
                            content: listCashTransfer[i]['rev_bankname']
                                    .toString()
                                    .isEmpty
                                ? "-"
                                : listCashTransfer[i]['rev_bankname'],
                          ),
                          textListCash(
                            title: 'Số tiền chuyển',
                            content: listCashTransfer[i]['amt_total']
                                    .toString()
                                    .isEmpty
                                ? "-"
                                : Utils().formatNumber(int.parse(
                                    listCashTransfer[i]['amt_total'])),
                          ),
                          textListCash(
                            title: 'Phí chuyển',
                            content: Utils().formatNumber(
                                int.parse(listCashTransfer[i]['fee'] ?? "0")),
                          ),
                          textListCash(
                            title: 'Trạng thái',
                            content: listCashTransfer[i]['txstatus_vn'],
                          ),
                          textListCash(
                            title: 'Chi tiết',
                            content: listCashTransfer[i]['description'],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class textListCash extends StatelessWidget {
  const textListCash({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: title,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 64) / 2,
            child: customTextStyleBody(
              text: content,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              txalign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
