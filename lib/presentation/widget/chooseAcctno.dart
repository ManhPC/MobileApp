import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/services/getInfoCustomer.dart';
import 'package:nvs_trading/data/services/setDefaultAcctno.dart';
import 'package:nvs_trading/presentation/view/provider/changeAcctno.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';

class ChooseAcctno extends StatefulWidget {
  const ChooseAcctno({
    super.key,
  });

  @override
  State<ChooseAcctno> createState() => _ChooseAcctnoState();
}

class _ChooseAcctnoState extends State<ChooseAcctno> {
  String acctno = "";
  @override
  void initState() {
    super.initState();
    fetchAcctno();
  }

  Future<void> fetchAcctno() async {
    final response = await GetInfoCustomer(
      HydratedBloc.storage.read('custodycd'),
      HydratedBloc.storage.read('token'),
    );

    for (var element in response) {
      if (element.acctnodefault == "Y") {
        acctno = element.acctno;
      }
    }
    print(acctno);
    HydratedBloc.storage.write('acctno', acctno);
    final provider = Provider.of<ChangeAcctno>(context, listen: false);
    provider.updateAcctno(acctno);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetInfoCustomer(
        HydratedBloc.storage.read('custodycd'),
        HydratedBloc.storage.read('token'),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          final data = snapshot.data ?? [];
          List<String> acctNos = [];
          for (var i in data) {
            acctNos.add(i.acctno);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: DropdownButton(
              dropdownColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
              icon: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              value: acctno,
              underline: Container(),
              items: [
                for (var i = 0; i < acctNos.length; i++)
                  DropdownMenuItem(
                    value: acctNos[i],
                    child: customTextStyleBody(
                      text: acctNos[i],
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
              onChanged: (value) async {
                setState(() {
                  acctno = value!;
                });
                final res = await setDefaultAcctno(
                  acctno,
                  HydratedBloc.storage.read('custodycd'),
                );
                if (res == 0) {
                  await fetchAcctno();
                  setState(() {});
                }
              },
            ),
          );
        }
      },
    );
  }
}
