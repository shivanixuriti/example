import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/logic/view_models/transaction_manager.dart';
import 'package:xuriti/models/helper/service_locator.dart';
import 'package:xuriti/ui/widgets/appbar/app_bar_widget.dart';

import '../../../models/core/invoice_model.dart';
import '../../../models/core/transactional_model.dart';
import '../../theme/constants.dart';

class TransactionalLedger extends StatefulWidget {
  late Transaction transaction;

  @override
  State<TransactionalLedger> createState() => _TransactionalLedgerState();
}

class _TransactionalLedgerState extends State<TransactionalLedger> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;

      return Scaffold(
          backgroundColor: Colours.white,
          appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: h10p * .9,
              flexibleSpace: AppbarWidget()),
          body: Column(
            children: [
              Container(
                child: Center(child: Text("Download Invoices")),
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colours.mediumGreen,
                ),
              )
            ],
          ));
    });
  }
}
