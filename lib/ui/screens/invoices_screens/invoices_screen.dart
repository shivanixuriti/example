import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:xuriti/logic/view_models/transaction_manager.dart';
import 'package:xuriti/models/core/get_company_list_model.dart';
import 'package:xuriti/models/helper/service_locator.dart';
import 'package:xuriti/ui/routes/router.dart';
import 'package:xuriti/ui/screens/invoices_screens/payment_history/payments_history_screen.dart';
import 'package:xuriti/ui/screens/invoices_screens/pending_invoices_screen/pending_invoices_screen.dart';

import '../../../logic/view_models/auth_manager.dart';
import '../../../models/core/credit_limit_model.dart';
import '../../theme/constants.dart';
import 'all_sellers_screens/all_sellers_screen.dart';
import 'pending_invoices_screen/paid_invoices_screen.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({Key? key, required this.refreshingFunction})
      : super(key: key);

  final Function refreshingFunction;

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    GetCompany company = GetCompany();
    int? indexOfCompany = getIt<SharedPreferences>().getInt('companyIndex');
    if (indexOfCompany != null) {
      company =
          Provider.of<TransactionManager>(context).companyList[indexOfCompany];
    }

    List<Widget> screens = [
      PInvoices(refreshingFunction: widget.refreshingFunction),
      PaidInvoices(),
      PHistory(),
      AllSellers(),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      return Scaffold(
          backgroundColor: Colours.black,
          body: Column(
            children: [
              Container(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: w10p * 1,
                                    height: h10p * 0.6,
                                    child: Image.asset(
                                        "assets/images/rewardLevel2.png"),
                                  ),
                                  const Text(
                                    "Level 2",
                                    style: TextStyle(color: Colours.white),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, rewards);
                              },
                            ),
                            Consumer<TransactionManager>(
                                builder: (context, params, child) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Opacity(
                                    opacity: 0.6000000238418579,
                                    child: Container(
                                      // width: w10p * 3.1,
                                      height: h10p * 0.9,
                                      decoration: const BoxDecoration(
                                        color: Colours.almostBlack,
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: h1p * 1,
                                          ),
                                          const Text(
                                            "Total Credit Limit / Credit Available",
                                            style: TextStyles.textStyle21,
                                          ),
                                          SizedBox(
                                            height: h1p * 0.2,
                                          ),
                                          Text(
                                            "₹ ${params.selectedCreditLimit} lacs/₹ ${params.availableCredit} lacs",
                                            style: TextStyles.textStyle22,
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            })
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, homeCompanyList);
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colours.black,
                            child: Image.asset(
                                "assets/images/kycImages/avatar.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        bottom: h1p * 3,
                        left: w10p * .5,
                      ),
                      child: Container(
                        height: h1p * 10.005,
                        width: maxWidth,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 0;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: w10p * .4),
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w10p * .6,
                                        vertical: h10p * .2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: currentIndex == 0
                                            ? Colours.tangerine
                                            : Colours.almostBlack),
                                    child: Row(children: [
                                      SvgPicture.asset(
                                          "assets/images/icon.svg"),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Pending",
                                              style: TextStyles.textStyle47,
                                            ),
                                            Text(
                                              "Invoices",
                                              style: TextStyles.textStyle47,
                                            )
                                          ],
                                        ),
                                      ),
                                    ])),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 1;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: w10p * .4),
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w10p * .6,
                                        vertical: h10p * .2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: currentIndex == 1
                                            ? Colours.tangerine
                                            : Colours.almostBlack),
                                    child: Row(children: [
                                      SvgPicture.asset(
                                          "assets/images/Icon2.svg"),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Paid",
                                              style: TextStyles.textStyle47,
                                            ),
                                            Text(
                                              "Invoices",
                                              style: TextStyles.textStyle47,
                                            )
                                          ],
                                        ),
                                      ),
                                    ])),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 2;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: w10p * .4),
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w10p * .6,
                                        vertical: h10p * .2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: currentIndex == 2
                                            ? Colours.tangerine
                                            : Colours.almostBlack),
                                    child: Row(children: [
                                      SvgPicture.asset(
                                          "assets/images/Icon2.svg"),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Payment",
                                              style: TextStyles.textStyle47,
                                            ),
                                            Text(
                                              "History",
                                              style: TextStyles.textStyle47,
                                            )
                                          ],
                                        ),
                                      ),
                                    ])),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 3;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: w10p * .4),
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w10p * .6,
                                        vertical: h10p * .2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: currentIndex == 3
                                            ? Colours.tangerine
                                            : Colours.almostBlack),
                                    child: Row(children: [
                                      SvgPicture.asset(
                                          "assets/images/icon3.svg"),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "All",
                                              style: TextStyles.textStyle47,
                                            ),
                                            Text(
                                              "Sellers",
                                              style: TextStyles.textStyle47,
                                            )
                                          ],
                                        ),
                                      ),
                                    ])),
                              ),
                            ),
                          ],
                        ),
                      )),
                ]),
              ),
              Expanded(
                child: Container(
                  width: maxWidth,
                  height: maxHeight,
                  // height: h10p*3,
                  decoration: const BoxDecoration(
                      color: Colours.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      )),
                  child: screens[currentIndex],
                ),
              ),
            ],
          ));
    });
  }
}
