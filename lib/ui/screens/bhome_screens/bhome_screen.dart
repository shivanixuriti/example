import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/models/core/credit_limit_model.dart';
import 'package:xuriti/ui/screens/bhome_screens/upcoming_screens/home_upcoming.dart';

import '../../../logic/view_models/auth_manager.dart';
import '../../../logic/view_models/company_details_manager.dart';
import '../../../logic/view_models/reward_manager.dart';
import '../../../logic/view_models/transaction_manager.dart';
import '../../../models/core/get_company_list_model.dart';
import '../../../models/core/invoice_model.dart';
import '../../../models/core/reward_model.dart';
import '../../../models/helper/service_locator.dart';
import '../../routes/router.dart';
import '../../theme/constants.dart';
import '../../widgets/backlogo.dart';
import '../../widgets/bhome_widgets/bhomeHeading_widget.dart';
import '../../widgets/bhome_widgets/guide_widget.dart';

class BhomeScreen extends StatefulWidget {
  const BhomeScreen({Key? key}) : super(key: key);

  @override
  State<BhomeScreen> createState() => _BhomeScreenState();
}

class _BhomeScreenState extends State<BhomeScreen> {
  @override
  void dispose() {
    getIt<TransactionManager>().invoiceDispose();
    super.dispose();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    RewardModel? rewardData = getIt<RewardManager>().rewards;
    GetCompany company = GetCompany();
    String? id = getIt<SharedPreferences>().getString('companyId');

    String? token = getIt<SharedPreferences>().getString('token');
    int? indexOfCompany = getIt<SharedPreferences>().getInt('companyIndex');
    if (indexOfCompany != null) {
      company =
          Provider.of<TransactionManager>(context).companyList[indexOfCompany];
    }

    List invoice = Provider.of<TransactionManager>(context).confirmedInvoices;

    double outStandingAmt = getIt<TransactionManager>().totalAmt;

    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      return Scaffold(
          backgroundColor: Colours.black,
          body: ProgressHUD(
              // indicatorWidget: Backlogo(
              //   width: w10p * 2.5,
              //   height: h10p * 2,
              // ),
              child: Builder(builder: (context) {
                final progress = ProgressHUD.of(context);
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
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
                                              "Total Credit Limit",
                                              style: TextStyles.textStyle21,
                                            ),
                                            SizedBox(
                                              height: h1p * 0.1,
                                            ),
                                            Text(
                                              "₹ ${params.selectedCreditLimit.toString()}",
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
                  ]),
                  Expanded(
                    child: Container(
                      width: maxWidth,
                      height: maxHeight,
                      decoration: const BoxDecoration(
                          color: Colours.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: invoice.isEmpty
                            ? Column(
                                children: [
                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(
                                  //       horizontal: w10p * .6, vertical: h1p * 3),
                                  //   child: Container(
                                  //       width: maxWidth,
                                  //       decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(16),
                                  //           color: Colours.offWhite),
                                  //       child: Padding(
                                  //         padding: EdgeInsets.symmetric(
                                  //             vertical: h1p * 3, horizontal: w10p * .5),
                                  //         child: Row(children: [
                                  //           SvgPicture.asset("assets/images/logo1.svg"),
                                  //           SizedBox(
                                  //             width: w10p * 0.5,
                                  //           ),
                                  //           Column(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.start,
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: [
                                  //               Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.only(top: 10),
                                  //                 child: Column(
                                  //                   children: [
                                  //                     Row(
                                  //                       children: const [
                                  //                         Text(
                                  //                           "Wohoo",
                                  //                           style:
                                  //                               TextStyles.textStyle20,
                                  //                         ),
                                  //                         Text(
                                  //                           "!! Your Profile & Business has",
                                  //                           style:
                                  //                               TextStyles.textStyle34,
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //               Row(
                                  //                 children: const [
                                  //                   Text(
                                  //                     "successfully been registered",
                                  //                     style: TextStyles.textStyle34,
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ]),
                                  //       )),
                                  // ),
                                  SizedBox(
                                    height: h1p * 8,
                                  ),
                                  Center(
                                    child: Image.asset(
                                        "assets/images/onboard-image-2.png"),
                                  ),
                                ],
                              )
                            : CustomScrollView(
                                slivers: [
                                  // SliverPadding(
                                  //     padding:
                                  //         EdgeInsets.symmetric(vertical: h1p * 2.5),
                                  //     sliver: SliverToBoxAdapter(
                                  //         child: Padding(
                                  //       padding: EdgeInsets.symmetric(
                                  //           horizontal: 24, vertical: h1p * 1.8),
                                  //       child: Container(
                                  //           width: maxWidth,
                                  //           decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.circular(16),
                                  //               color: Colours.white),
                                  //           child: Row(children: [
                                  //             Padding(
                                  //               padding: const EdgeInsets.symmetric(
                                  //                   horizontal: 0),
                                  //               child: SvgPicture.asset(
                                  //                   "assets/images/logo1.svg"),
                                  //             ),
                                  //             SizedBox(
                                  //               width: w10p * 0.5,
                                  //             ),
                                  //             Column(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.start,
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.start,
                                  //               children: [
                                  //                 Padding(
                                  //                   padding:
                                  //                       const EdgeInsets.only(top: 10),
                                  //                   child: Column(
                                  //                     children: [
                                  //                       Row(
                                  //                         children: const [
                                  //                           Text(
                                  //                             "Wohoo",
                                  //                             style: TextStyles
                                  //                                 .textStyle20,
                                  //                           ),
                                  //                           Text(
                                  //                             "!! You have saved ",
                                  //                             style: TextStyles
                                  //                                 .textStyle34,
                                  //                           ),
                                  //                           Text(
                                  //                             "₹ 12,345 ",
                                  //                             style: TextStyles
                                  //                                 .textStyle35,
                                  //                           ),
                                  //                           Text(
                                  //                             "so far..",
                                  //                             style: TextStyles
                                  //                                 .textStyle34,
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Row(
                                  //                   children: const [
                                  //                     Text(
                                  //                       "Pay more invoices early & save more>>",
                                  //                       style: TextStyles.textStyle34,
                                  //                     )
                                  //                   ],
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ])),
                                  //     ))),
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w10p * 0.6,
                                        vertical: h1p * 4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Outstanding Amount",
                                                style: TextStyles.textStyle99,
                                              ),
                                              Text(
                                                "₹ ${outStandingAmt.toStringAsFixed(2)}",
                                                style: TextStyles.textStyleUp,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: h1p * 5.5,
                                            width: w10p * 2,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colours.successPrimary,
                                            ),
                                            child: Center(
                                              child: InkWell(
                                                onTap: () async {
                                                  progress!.show();

                                                  await getIt<
                                                          CompanyDetailsManager>()
                                                      .getSellerList(id);
                                                  progress.dismiss();
                                                  Navigator.pushNamed(
                                                      context, totalPayment);
                                                },
                                                child: Text(
                                                  "PAY NOW",
                                                  style: TextStyles.textStyle46,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w10p * .4),
                                        child: SubHeadingWidget(
                                          maxHeight: maxHeight,
                                          maxWidth: maxWidth,
                                          heading1: "Upcoming Payments",
                                        )),
                                  ),
                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                    ((context, index) {
                                      return HomeUpcoming(
                                        companyName: invoice[index]
                                                .seller!
                                                .companyName ??
                                            "",
                                        amount:
                                            invoice[index].outstandingAmount ??
                                                "",
                                        invoiceDate:
                                            invoice[index].invoiceDate ?? "",
                                        invoiceNumber:
                                            invoice[index].invoiceNumber ?? "",
                                        dueDate:
                                            invoice[index].invoiceDueDate ?? "",
                                        fullDetails: invoice[index],
                                      );
                                    }),
                                    childCount: invoice.length,
                                  )),
                                  SliverPadding(
                                    padding: EdgeInsets.symmetric(vertical: 18),
                                    sliver: SliverToBoxAdapter(
                                        child: GuideWidget(
                                      maxWidth: maxWidth,
                                      maxHeight: maxHeight,
                                    )),
                                  ),
                                  SliverToBoxAdapter(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: w10p * .4,
                                              vertical: 18),
                                          child: SubHeadingWidget(
                                            maxHeight: maxHeight,
                                            maxWidth: maxWidth,
                                            heading1: "Rewards",
                                          ))),

                                  SliverToBoxAdapter(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        height: 140,
                                        width: maxWidth,
                                        child: Swiper(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Rewards currentReward = rewardData!
                                                .data!.rewards![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9.0,
                                                      vertical: 8),
                                              child: Stack(children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  width: w10p * 9,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: AssetImage(currentReward
                                                                      .status ==
                                                                  "CLAIMED"
                                                              ? "assets/images/completed-reward.png"
                                                              : currentReward
                                                                          .status ==
                                                                      "UNCLAIMED"
                                                                  ? "assets/images/home_images/bgimage1.png"
                                                                  : currentReward
                                                                              .status ==
                                                                          "LOCKED"
                                                                      ? "assets/images/home_images/bgimage2.png"
                                                                      : "assets/images/home_images/bgimage2.png")),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28),
                                                      color: Colours.white,
                                                      // border: Border.all(color: Colours.black,width: 0.5),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            spreadRadius: 0.1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            )),
                                                        // BoxShadow(color: Colors.grey,spreadRadius: 0.5,blurRadius: 1,
                                                        //     offset: Offset(1,1,))
                                                      ]),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 18),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                    "Xuriti Rewards",
                                                                    style: TextStyles
                                                                        .textStyle104),
                                                                Text(
                                                                    "Level ${currentReward.level}",
                                                                    style: currentReward.status ==
                                                                            "CLAIMED"
                                                                        ? TextStyles
                                                                            .textStyle46
                                                                        : TextStyles
                                                                            .textStyle38),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text("15",
                                                                    style: currentReward.status ==
                                                                            "CLAIMED"
                                                                        ? TextStyles
                                                                            .textStyle105
                                                                        : TextStyles
                                                                            .textStyle39),
                                                                Text("/15",
                                                                    style: currentReward.status ==
                                                                            "CLAIMED"
                                                                        ? TextStyles
                                                                            .textStyle106
                                                                        : TextStyles
                                                                            .textStyle38),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        currentReward.status ==
                                                                "CLAIMED"
                                                            ? Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        18.0),
                                                                child:
                                                                    LinearPercentIndicator(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                0), //leaner progress bar
                                                                        animation:
                                                                            true,
                                                                        animationDuration:
                                                                            1000,
                                                                        lineHeight:
                                                                            15,
                                                                        percent:
                                                                            100 /
                                                                                100,
                                                                        progressColor:
                                                                            Colours
                                                                                .pumpkin,
                                                                        backgroundColor: Colors
                                                                            .grey
                                                                            .withOpacity(0.3)),
                                                              )
                                                            : currentReward
                                                                        .status ==
                                                                    "UNCLAIMED"
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            18.0),
                                                                    child: LinearPercentIndicator(
                                                                        padding: EdgeInsets.all(0), //leaner progress bar
                                                                        animation: true,
                                                                        animationDuration: 1000,
                                                                        lineHeight: 15,
                                                                        percent: 50 / 100,
                                                                        progressColor: Colours.pumpkin,
                                                                        backgroundColor: Colors.grey.withOpacity(0.3)),
                                                                  )
                                                                : currentReward
                                                                            .status ==
                                                                        "LOCKED"
                                                                    ? Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 18.0),
                                                                        child: LinearPercentIndicator(
                                                                            padding: EdgeInsets.all(0), //leaner progress bar
                                                                            animation: true,
                                                                            animationDuration: 1000,
                                                                            lineHeight: 15,
                                                                            percent: 0 / 100,
                                                                            progressColor: Colours.pumpkin,
                                                                            backgroundColor: Colors.grey.withOpacity(0.3)),
                                                                      )
                                                                    : Container(),
                                                        Text(
                                                            currentReward
                                                                        .status ==
                                                                    "CLAIMED"
                                                                ? "Level Completed"
                                                                : currentReward.status ==
                                                                        "UNCLAIMED"
                                                                    ? "Complete 9 transactions to next reward"
                                                                    : currentReward.status ==
                                                                            "LOCKED"
                                                                        ? "Locked 🔒"
                                                                        : "",
                                                            style: currentReward
                                                                        .status ==
                                                                    "CLAIMED"
                                                                ? TextStyles
                                                                    .textStyle107
                                                                : TextStyles
                                                                    .textStyle40)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                currentReward.status ==
                                                        "CLAIMED"
                                                    ? Positioned(
                                                        top: h10p * 0.7,
                                                        left: w10p * 2.5,
                                                        child: Container(
                                                          height: h10p * 0.4,
                                                          width: w10p * 2.5,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color:
                                                                Colours.pumpkin,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "View Rewards",
                                                              style: TextStyles
                                                                  .textStyle47,
                                                            ),
                                                          ),
                                                        ))
                                                    : Container(),
                                                currentReward.status ==
                                                        "CLAIMED"
                                                    ? Positioned(
                                                        top: h10p * 0.75,
                                                        right: w10p * 0.67,
                                                        child: SvgPicture.asset(
                                                            "assets/images/leading-star.svg"),
                                                      )
                                                    : currentReward.status ==
                                                            "UNCLAIMED"
                                                        ? Positioned(
                                                            top: h10p * 0.85,
                                                            right: w10p * 3.4,
                                                            child: SvgPicture.asset(
                                                                "assets/images/leading-star.svg"),
                                                          )
                                                        : currentReward
                                                                    .status ==
                                                                "LOCKED"
                                                            ? Positioned(
                                                                top:
                                                                    h10p * 0.85,
                                                                right:
                                                                    w10p * 3.5,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/images/reward-lockedImage.svg"),
                                                              )
                                                            : Container(),
                                              ]),
                                            );
                                          },
                                          itemCount: 3,
                                          // rewards.data!.rewards!.length,
                                          loop: false,
                                          viewportFraction: 0.8,
                                          scale: 0.99,
                                          onIndexChanged: (value) {
                                            setState(() {
                                              currentIndex = value;
                                            });
                                          },
                                        )),
                                  )
                                ],
                              ),
                      ),
                    ),
                  )
                ]);
              })));
    });
  }
}
