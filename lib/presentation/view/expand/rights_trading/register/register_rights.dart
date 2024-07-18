import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/get_account_detail.dart';
import 'package:nvs_trading/data/services/getAccountDetail.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class RegisterRight extends StatefulWidget {
  const RegisterRight({super.key});

  @override
  State<RegisterRight> createState() => _RegisterRightState();
}

class _RegisterRightState extends State<RegisterRight> {
  String custodycd = HydratedBloc.storage.read('custodycd');
  String acctno = HydratedBloc.storage.read('acctno');

  //search
  TextEditingController maCK = TextEditingController();
  //
  List<GetAccountDetailModel> listAccount = [];

  @override
  void initState() {
    super.initState();
    fetchAccountDetail();
  }

  void fetchAccountDetail() async {
    try {
      final res = await GetAccountDetail(custodycd);
      if (res.isNotEmpty) {
        setState(() {
          listAccount = res;
        });
      }
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Đăng ký quyền mua"),
      body: (listAccount.isEmpty)
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36,
                    child: SearchBar(
                      controller: maCK,
                      elevation: const MaterialStatePropertyAll(0),
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primary),
                      padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 6, horizontal: 10)),
                      leading: SvgPicture.asset(
                        "assets/icons/ic_search.svg",
                        width: 20,
                        height: 20,
                      ),
                      onChanged: (value) {
                        setState(() {
                          maCK.text = value.toUpperCase();
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          maCK.text = value;
                        });
                        print(maCK.text);
                      },
                      hintText: "Mã chứng khoán",
                      hintStyle: MaterialStatePropertyAll(
                        TextStyle(
                            fontSize: 10, color: Theme.of(context).hintColor),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 162,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            value: acctno,
                            items: [
                              for (var i in listAccount)
                                DropdownMenuItem(
                                  value: i.acctno,
                                  child: customTextStyleBody(
                                    text: i.acctno,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                acctno = value!;
                              });
                            },
                            isExpanded: true,
                            isDense: true,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          fixedSize: const Size(161, 36),
                        ),
                        onPressed: () {
                          print("Con meo");
                        },
                        child: customTextStyleBody(
                          text: "Tìm kiếm",
                          size: 14,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  customTextStyleBody(
                    text: "Số tiền được đăng ký",
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: Utils().formatNumber(listAccount[
                                  listAccount.indexWhere(
                                      (element) => element.acctno == acctno)]
                              .balance),
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: " VND",
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                Theme.of(context).textTheme.titleSmall!.color,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  customTextStyleBody(
                    text: "Danh sách đăng ký quyền mua",
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
    );
  }
}
