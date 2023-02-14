import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xuriti/logic/view_models/transaction_manager.dart';
import 'package:xuriti/ui/routes/router.dart';

import '../../../models/helper/service_locator.dart';
import '../../theme/constants.dart';

class ReportsOptionScreen extends StatelessWidget {
  const ReportsOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colours.black,
          automaticallyImplyLeading: false,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 12.0),
                child: Image.asset(
                  "assets/images/xuriti1.png",
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SvgPicture.asset("assets/images/arrowLeft.svg"),
                    ),
                  ),
                  Text(
                    "Reports",
                    style: TextStyles.leadingText,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, transactionalLedger);
                  },
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colours.tangerine),
                      child: Center(
                        child: Text(
                          "Transactional Statement",
                          style: TextStyles.textStyle85,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, transactionalLedger);
                  },
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colours.tangerine),
                      child: Center(
                        child: Text(
                          "Transactional Ledger",
                          style: TextStyles.textStyle85,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        )));
  }
}
