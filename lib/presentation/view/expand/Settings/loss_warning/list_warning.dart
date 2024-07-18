import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/services/getList.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListWarning extends StatefulWidget {
  const ListWarning({super.key});

  @override
  State<ListWarning> createState() => _ListWarningState();
}

class _ListWarningState extends State<ListWarning> {
  TextEditingController profitText = TextEditingController();
  TextEditingController lossText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: FutureBuilder(
        future: GetList(
          HydratedBloc.storage.read('custodycd'),
          HydratedBloc.storage.read('token'),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            final responseData = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  for (var i in responseData)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: customTextStyleBody(
                                      text: appLocal.losswarning('account'),
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w400,
                                      txalign: TextAlign.start,
                                    ),
                                  ),
                                  customTextStyleBody(
                                    text: i['acctno'],
                                    size: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 45,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: Color(0xffF04A47),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await removeWarning(i['autoid'],
                                            HydratedBloc.storage.read('token'));
                                        setState(() {});
                                      },
                                      child: FittedBox(
                                        fit: BoxFit.none,
                                        child: customTextStyleBody(
                                          text: appLocal.buttonForm('delete'),
                                          color: const Color(0xffF04A47),
                                          fontWeight: FontWeight.w400,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  SizedBox(
                                    height: 20,
                                    width: 45,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: Color(0xffE7AB21),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                      onPressed: () {
                                        profitText.text = i['profitrate'];
                                        lossText.text = i['lossrate'];
                                        handleUpdateWarning(context, i);
                                      },
                                      child: FittedBox(
                                        fit: BoxFit.none,
                                        child: customTextStyleBody(
                                          text: appLocal.buttonForm('update'),
                                          color: const Color(0xffE7AB21),
                                          fontWeight: FontWeight.w400,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: customTextStyleBody(
                                  text: appLocal.losswarning('applicabletype'),
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                  fontWeight: FontWeight.w400,
                                  txalign: TextAlign.start,
                                ),
                              ),
                              customTextStyleBody(
                                text: i['type'],
                                size: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: customTextStyleBody(
                                  text: appLocal.losswarning('stockcode'),
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color!,
                                  txalign: TextAlign.start,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              customTextStyleBody(
                                text: (i['symbol'] == "") ? "--" : i['symbol'],
                                size: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: customTextStyleBody(
                                      text:
                                          "${appLocal.losswarning('profit')} (%)",
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w400,
                                      txalign: TextAlign.start,
                                    ),
                                  ),
                                  customTextStyleBody(
                                    text: i['profitrate'],
                                    color: const Color(0xff4FD08A),
                                    fontWeight: FontWeight.w700,
                                    txalign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: customTextStyleBody(
                                      text:
                                          "${appLocal.losswarning('loss')} (%)",
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .color!,
                                      fontWeight: FontWeight.w400,
                                      txalign: TextAlign.start,
                                    ),
                                  ),
                                  customTextStyleBody(
                                    text: i['lossrate'],
                                    color: const Color(0xffF04A47),
                                    fontWeight: FontWeight.w700,
                                    txalign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> handleUpdateWarning(BuildContext context, i) {
    var appLocal = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: appLocal.losswarning('account'),
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w700,
                  ),
                  customTextStyleBody(
                    text: i['acctno'],
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: appLocal.losswarning('applicabletype'),
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w700,
                  ),
                  customTextStyleBody(
                    text: i['type'],
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextStyleBody(
                    text: appLocal.losswarning('stockcode'),
                    color: Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w700,
                  ),
                  customTextStyleBody(
                    text: i['symbol'] == "" ? "--" : i['symbol'],
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      customTextStyleBody(
                        text: "${appLocal.losswarning('profit')} (%)",
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 50,
                        height: 20,
                        child: TextField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: profitText,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      customTextStyleBody(
                        text: "${appLocal.losswarning('loss')} (%)",
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 50,
                        height: 20,
                        child: TextField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: lossText,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  fixedSize: const Size(100, 30),
                ),
                onPressed: () async {
                  final res = await updateWarning(
                    i['acctno'],
                    i['autoid'],
                    HydratedBloc.storage.read('custodycd'),
                    int.parse(lossText.text),
                    int.parse(profitText.value.text),
                    HydratedBloc.storage.read('token'),
                  );
                  if (res == 200) {
                    print("Thành công");
                    Navigator.of(context).pop();
                  } else {
                    print("Thất bại");
                  }
                  setState(() {});
                },
                child: customTextStyleBody(
                  text: appLocal.buttonForm('save'),
                  color: Theme.of(context).buttonTheme.colorScheme!.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
