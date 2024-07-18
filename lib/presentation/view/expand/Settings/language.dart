import 'package:flutter/material.dart';
import 'package:nvs_trading/main.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context);
    String selectedItem = appLocalizations!.localeName;
    return Scaffold(
      appBar: appBar(text: appLocalizations.language),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '\u{1F1EC}\u{1F1E7}',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      customTextStyleBody(
                        text: "English",
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.check,
                    color: (selectedItem == 'en')
                        ? const Color(0xFF4FD08A)
                        : Colors.transparent,
                    size: 20,
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  MyApp.setLocale(context, const Locale('en'));
                });
              },
            ),
            const SizedBox(
              height: 24,
            ),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '\u{1F1FB}\u{1F1F3}',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      customTextStyleBody(
                        text: "Tiếng việt",
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.check,
                    color: (selectedItem == 'vi')
                        ? const Color(0xFF4FD08A)
                        : Colors.transparent,
                    size: 20,
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  MyApp.setLocale(context, const Locale('vi'));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
