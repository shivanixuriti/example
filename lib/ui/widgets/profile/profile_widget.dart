import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../logic/view_models/auth_manager.dart';
import '../../../logic/view_models/transaction_manager.dart';
import '../../../models/core/credit_limit_model.dart';
import '../../../models/core/get_company_list_model.dart';
import '../../../models/helper/service_locator.dart';
import '../../routes/router.dart';
import '../../theme/constants.dart';

class ProfileWidget extends StatefulWidget {
  GlobalKey<ScaffoldState>? pskey;
  ProfileWidget({Key? key, pskey}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {



    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      return Consumer<TransactionManager>(builder: (context, params, child) {
        return Container(
          height: maxHeight,
          width: maxWidth,
          color: Colours.black,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 39, left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/images/xuriti1.png"),
                    InkWell(
                        onTap: () {
                          widget.pskey!.currentState!.openEndDrawer();
                        },
                        child: SvgPicture.asset("assets/images/menubutton.svg"))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 30),
                            child:
                                Image.asset("assets/images/rewardLevel2.png"),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 29),
                            child: Text(
                              "Level 2",
                              style: TextStyles.textStyle86,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15),
                        child: Opacity(
                            opacity: 0.6000000238418579,
                            child: Container(
                              // width: w10p * 3.7,
                              height: h10p * 3.5,
                              decoration: const BoxDecoration(
                                color: Colours.almostBlack,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: h1p * 3.5,
                                  ),
                                  const Text(
                                    "Total Credit Limit",
                                    style: TextStyles.textStyle71,
                                  ),
                                  SizedBox(
                                    height: h1p * 0.1,
                                  ),
                                  Text(
                                    "₹ ${params.selectedCreditLimit}",
                                    style: TextStyles.textStyle22,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, homeCompanyList);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 15, top: 10),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colours.black,
                        child:
                            Image.asset("assets/images/kycImages/avatar.png"),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      });
    });
  }
}
