// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailRights extends StatefulWidget {
  DetailRights({
    super.key,
    required this.symbol,
    required this.catype,
    required this.rate,
    required this.actiondate,
    required this.status,
    required this.status_text,
    required this.reportdate,
    required this.reportqtty,
  });

  String symbol;
  String catype;
  String rate;
  String actiondate;
  String status;
  String status_text;
  String reportdate;
  String reportqtty;

  @override
  State<DetailRights> createState() => _DetailRightsState();
}

class _DetailRightsState extends State<DetailRights> {
  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocal.lookUpPermission('rightDetail')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextStyleBody(
                text: widget.symbol,
                size: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 20,
                      child: customTextStyleBody(
                        text: appLocal.lookUpPermission('TOR'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      width: 161,
                      child: customTextStyleBody(
                        text: widget.catype,
                        fontWeight: FontWeight.w700,
                        txalign: TextAlign.start,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    height: 20,
                    child: customTextStyleBody(
                      text: appLocal.lookUpPermission('ER'),
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                      txalign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 18,
                    width: 161,
                    child: customTextStyleBody(
                      text: widget.rate,
                      fontWeight: FontWeight.w700,
                      txalign: TextAlign.start,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 20,
                      child: customTextStyleBody(
                        text: appLocal.lookUpPermission('EED'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      width: 161,
                      child: customTextStyleBody(
                        text: DateFormat('dd/MM/yyyy').format(
                          DateFormat('M/d/yyyy h:mm:ss a').parse(
                            widget.actiondate,
                          ),
                        ),
                        fontWeight: FontWeight.w700,
                        txalign: TextAlign.start,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    height: 20,
                    child: customTextStyleBody(
                      text: appLocal.lookUpPermission('status'),
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                      txalign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 18,
                    width: 161,
                    child: customTextStyleBody(
                      text: widget.status_text,
                      fontWeight: FontWeight.w700,
                      txalign: TextAlign.start,
                      color: widget.status == "C"
                          ? const Color(0xff4fd08a)
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 20,
                      child: customTextStyleBody(
                        text: appLocal.lookUpPermission('QORD'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      width: 161,
                      child: customTextStyleBody(
                        text: widget.reportqtty,
                        fontWeight: FontWeight.w700,
                        txalign: TextAlign.start,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 20,
                      child: customTextStyleBody(
                        text:
                            "${appLocal.lookUpPermission('closeDate')} (ĐKCC)",
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                        txalign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      width: 161,
                      child: customTextStyleBody(
                        text: DateFormat('dd/MM/yyyy').format(
                          DateFormat('M/d/yyyy h:mm:ss a').parse(
                            widget.reportdate,
                          ),
                        ),
                        fontWeight: FontWeight.w700,
                        txalign: TextAlign.start,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
