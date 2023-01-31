import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/logic/view_models/auth_manager.dart';
import 'package:xuriti/logic/view_models/transaction_manager.dart';
import 'package:xuriti/models/core/get_company_list_model.dart';
import 'package:xuriti/models/helper/service_locator.dart';
import 'package:xuriti/ui/routes/router.dart';
import 'package:xuriti/ui/screens/kyc_screens/kyc_verification_screen.dart';
import 'package:xuriti/ui/screens/starting_screens/landing_Screen.dart';
import 'package:xuriti/logic/view_models/transaction_manager.dart';
import 'package:xuriti/models/core/get_company_list_model.dart';
import 'package:xuriti/models/helper/service_locator.dart';

import '../../routes/router.dart';
import '../../theme/constants.dart';

class CompanyList extends StatefulWidget {
  const CompanyList({Key? key}) : super(key: key);

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  @override
  Widget build(BuildContext context) {
    List<GetCompany>? company =
        Provider.of<TransactionManager>(context).companyList;

    onWillPop() async {
      DateTime _lastExitTime = DateTime.now();

      if (DateTime.now().difference(_lastExitTime) >= Duration(seconds: 3)) {
        //showing message to user
        final snack = SnackBar(
          content: Text("Press the back button again to exist the app"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
        _lastExitTime = DateTime.now();
        return false; // disable back press
      } else {
        return true; //  exit the app
      }
    }

    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      double w1p = maxWidth * 0.01;

      return WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colours.black,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colours.black,
            automaticallyImplyLeading: false,
            toolbarHeight: h1p * 8,
            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: h1p * 2, horizontal: w1p * 3),
                  child: Image.asset(
                    "assets/images/xuriti1.png",
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            width: maxWidth,
            decoration: const BoxDecoration(
                color: Colours.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                )),
            child: CustomScrollView(slivers: [
              SliverList(
                  delegate: SliverChildListDelegate(
                [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: h1p * 5,
                            bottom: h1p * 5,
                            left: w10p * 3.5,
                            right: w1p * 20),
                        child: Text(
                          "Companies",
                          style: TextStyles.textStyle56,
                        ),
                      ),
                      SizedBox(
                        width: w1p * 1,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, businessRegister);
                          },
                          child: Icon(Icons.add))
                    ],
                  )
                ],
              )),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return InkWell(
                      onTap: () async {
                        String? companyId = company[index].companyDetails!.sId;
                        String? companyName =
                            company[index].companyDetails!.companyName;
                        String? companyStatus =
                            company[index].companyDetails!.status;

                        String? gstIn = company[index].companyDetails!.gstin;
                        await getIt<SharedPreferences>()
                            .setString('companyId', companyId!);
                        await getIt<SharedPreferences>()
                            .setString('gstIn', gstIn!);

                        await getIt<SharedPreferences>()
                            .setInt('companyIndex', index);
                        if (companyStatus == "Approved") {
                          Navigator.pushNamedAndRemoveUntil(context, landing,
                              (Route<dynamic> route) => false);
                        } else {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                // Container(
                                //   decoration: const BoxDecoration(
                                //       color: Colours.white,
                                //       borderRadius: BorderRadius.only(
                                //         topLeft: Radius.circular(26),
                                //         topRight: Radius.circular(26),
                                //       )),
                                //   child:
                                AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              title: const Text(
                                'KYC',
                                style: TextStyles.textStyle56,
                              ),
                              content: Text(
                                // 'You are not allowed to perform any operation, $companyName status is $companyStatus. Please proceed to KYC Verification.',
                                '$companyName status is on $companyStatus. Would you like to proceed for KYC verification process?',
                                style: TextStyles.textStyle117,
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      autofocus: true,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    KycVerification()));
                                      },
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      // onPressed: () =>
                                      //     Navigator.pop(context, 'Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: Icon(
                                        Icons.close,
                                        color: Colours.paleRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // ),
                          );
                          // ScaffoldMessenger.of(context)
                          //         .showSnackBar(
                          //          SnackBar(
                          //           duration: Duration(seconds: 2),
                          //             behavior:
                          //             SnackBarBehavior
                          //                 .floating,
                          //             content: Text(
                          //               'You are not allowed to perform any operation, $companyName status is $companyStatus. Please contact to Xuriti team.',
                          //               style: TextStyle(
                          //                   color: Colors
                          //                       .red),
                          //             )));
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: w1p * 5,
                          right: w1p * 5,
                          bottom: h1p * 3,
                        ),
                        child: Container(
                          height: h10p * 1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colours.tangerine),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  company[index].companyDetails == null
                                      ? ""
                                      : company[index]
                                              .companyDetails!
                                              .companyName ??
                                          "",
                                  style: TextStyles.textStyle85,
                                ),
                                // Text("Asian Paints",style: TextStyles.textStyle85,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "GST No :",
                                      style: TextStyles.textStyle71,
                                    ),
                                    Text(
                                      company[index].companyDetails!.gstin ??
                                          '',
                                      style: TextStyles.textStyle71,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                },
                childCount: company.length,
              ))
            ]),
          ),
        )),
      );
    });
  }
}
