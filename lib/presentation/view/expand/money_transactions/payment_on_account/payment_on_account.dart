import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/payment_on_account/payment_by_linkAcc.dart';
import 'package:nvs_trading/presentation/view/expand/money_transactions/payment_on_account/payment_by_qr.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class PaymentOnAccount extends StatefulWidget {
  const PaymentOnAccount({super.key});

  @override
  State<PaymentOnAccount> createState() => _PaymentOnAccountState();
}

class _PaymentOnAccountState extends State<PaymentOnAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Nộp tiền vào tài khoản"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: ListView(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentByQr()),
                  );
                },
                leading: Image.asset("assets/icons/qr-scan 1.png"),
                title: customTextStyleBody(
                  text: "Nộp tiền bằng QR code",
                  txalign: TextAlign.start,
                  size: 14,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentByLinkAcc()),
                  );
                },
                leading: Image.asset("assets/icons/bank 2.png"),
                title: customTextStyleBody(
                  text: "Nộp tiền bằng tài khoản liên kết",
                  txalign: TextAlign.start,
                  size: 14,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
