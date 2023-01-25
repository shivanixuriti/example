import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xuriti/logic/view_models/password_manager.dart';
import 'package:xuriti/models/core/seller_info_model.dart';
import 'package:xuriti/models/core/seller_list_model.dart';
import 'package:xuriti/ui/screens/paynow_screens/payment_url.dart';

import '../../../logic/view_models/company_details_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';

class TotalPayment extends StatefulWidget {
  const TotalPayment({Key? key}) : super(key: key);

  @override
  State<TotalPayment> createState() => _TotalPaymentState();
}

class _TotalPaymentState extends State<TotalPayment> {
  TextEditingController paidAmountController = TextEditingController();

  // String? _chosenSellerId;
  var items = [''];

  @override
  void dispose() {
    getIt<CompanyDetailsManager>().resetSellerInfo();

    super.dispose();
  }

  @override
  // void didChangeDependencies() {
  //
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // _chosenSellerId  = Provider.of<CompanyDetailsManager>(context).chosenSellerId;

    String? companyId = getIt<SharedPreferences>().getString('companyId');
    String settleAmountMsg;
    // = Provider.of<PasswordManager>(context).settleAmountMsg;

    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      double w1p = maxWidth * 0.01;
      return SafeArea(
          child: FutureBuilder(
              future: getIt<CompanyDetailsManager>().getSellerList(companyId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<MSeller> sellers = snapshot.data as List<MSeller>;

                    return Scaffold(
                        backgroundColor: Colours.black,
                        appBar: AppBar(
                            elevation: 0,
                            automaticallyImplyLeading: false,
                            toolbarHeight: h10p * .9,
                            flexibleSpace: AppbarWidget()),
                        body: ProgressHUD(child: Builder(builder: (context) {
                          final progress = ProgressHUD.of(context);
                          return Container(
                              width: maxWidth,
                              decoration: const BoxDecoration(
                                  color: Colours.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              child: ListView(children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w1p * 3, vertical: h1p * 3),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/arrowLeft.svg"),
                                        SizedBox(
                                          width: w10p * .3,
                                        ),
                                        const Text(
                                          "Pay Now",
                                          style: TextStyles.textStyle127,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w1p * 5, vertical: h1p * 1),
                                  child: Text("Seller",
                                      style: TextStyles.textStyle122),
                                ),
                                Consumer<CompanyDetailsManager>(
                                    builder: (context, params, child) {
                                  settleAmountMsg = params.settleAmountMsg;
                                  String outstandingAmount = "0";
                                  String interest = "0";
                                  String discount = "0";
                                  String paidInterest = "0";
                                  String paidDiscount = "0";
                                  String payable = "0";

                                  if (params.sellerInfo != null) {
                                    if (params.sellerInfo!.totalOutstanding !=
                                        null) {
                                      outstandingAmount = double.parse(params
                                              .sellerInfo!.totalOutstanding!)
                                          .toStringAsFixed(2);
                                    }
                                    if (params.sellerInfo!.totalInterest !=
                                        null) {
                                      interest = double.parse(
                                              params.sellerInfo!.totalInterest!)
                                          .toStringAsFixed(2);
                                    }
                                    if (params.sellerInfo!.totalDiscount !=
                                        null) {
                                      discount = double.parse(
                                              params.sellerInfo!.totalDiscount!)
                                          .toStringAsFixed(2);

                                      // discount = tempDiscount.round();
                                    }

                                    if (params.sellerInfo!.totalDiscount !=
                                            null &&
                                        (params.sellerInfo!.totalOutstanding !=
                                            null) &&
                                        (params.sellerInfo!.totalInterest !=
                                            null)) {
                                      payable = (double.parse(params.sellerInfo!
                                                  .totalOutstanding!) -
                                              double.parse(params
                                                  .sellerInfo!.totalDiscount!) +
                                              (double.parse(params
                                                  .sellerInfo!.totalInterest!)))
                                          .toStringAsFixed(2);
                                    }
                                  }
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w1p * 5,
                                            vertical: h1p * 2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colours.black015,
                                                  width: .5),
                                              boxShadow: [
                                                BoxShadow(
                                                    color:
                                                        const Color(0x66000000),
                                                    offset: Offset(0, 1),
                                                    blurRadius: 1,
                                                    spreadRadius: 0)
                                              ],
                                              color: Colours.paleGrey,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: params.chosenSellerId,
                                              // isExpanded: true,
                                              iconSize: 36,
                                              icon: Padding(
                                                padding: EdgeInsets.only(
                                                    right: w1p * 3),
                                                child: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colours.black,
                                                ),
                                              ),
                                              items:
                                                  sellers.map((MSeller seller) {
                                                return DropdownMenuItem(
                                                  value: seller.seller!.sId,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: w1p * 6),
                                                    child: Text(
                                                      seller.seller!
                                                              .companyName ??
                                                          ' ',
                                                      style: TextStyles
                                                          .textStyle122,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) async {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Fetching data please wait");
                                                // setState(() {
                                                //   _chosenSellerId = sellerId;
                                                // });
                                                progress!.show();
                                                Map<String,
                                                    dynamic>? data = await getIt<
                                                        CompanyDetailsManager>()
                                                    .getSellerInfo(
                                                        companyId, val);
                                                progress.dismiss();
                                                if (data != null &&
                                                    data['msg'] != null) {
                                                  Fluttertoast.showToast(
                                                      msg: data['msg']);
                                                }
                                              },
                                              hint: Container(
                                                width: 150, //and here
                                                child: Text(
                                                  "Please Select Seller",
                                                  style:
                                                      TextStyles.textStyle128,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: w1p * 5,
                                              vertical: h1p * 2),
                                          child: Container(
                                              height: h10p * 1,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colours.offWhite),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Outstanding Amount",
                                                    style:
                                                        TextStyles.textStyle129,
                                                  ),
                                                  Text(
                                                    "₹${outstandingAmount.toString()}",
                                                    style:
                                                        TextStyles.textStyleUp,
                                                  )
                                                ],
                                              ))),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w1p * 5,
                                          ),
                                          child: Container(
                                              height: h10p * 4.5,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: const Color(
                                                            0x66000000),
                                                        offset: Offset(0, 1),
                                                        blurRadius: 1,
                                                        spreadRadius: 0)
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colours.white),
                                              child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: w1p * 7.5,
                                                      vertical: h1p * 1),
                                                  child: Column(children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Discount",
                                                          style: TextStyles
                                                              .textStyle129,
                                                        ),
                                                        Text(
                                                          "Interest",
                                                          style: TextStyles
                                                              .textStyle129,
                                                        ),
                                                        Text(
                                                          "Payable Amount",
                                                          style: TextStyles
                                                              .textStyle129,
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "₹$discount",
                                                          style: TextStyles
                                                              .textStyle130,
                                                        ),
                                                        Text(
                                                          "₹${interest.toString()}",
                                                          style: TextStyles
                                                              .textStyle131,
                                                        ),
                                                        Text(
                                                          "₹$payable",
                                                          style: TextStyles
                                                              .textStyle132,
                                                        ),
                                                      ],
                                                    ),
                                                    SwitchListTile(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 0),
                                                      title: Text(
                                                        "Settle Your Amount",
                                                        style: TextStyles
                                                            .companyName,
                                                      ),
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      value: params.isSwitched,
                                                      activeColor:
                                                          Colours.pumpkin,
                                                      inactiveTrackColor:
                                                          Colours.warmGrey,
                                                      onChanged: (_) {
                                                        getIt<CompanyDetailsManager>()
                                                            .toggleSwitch();
                                                        if (params.isSwitched ==
                                                            false) {
                                                          paidAmountController
                                                              .text = "";
                                                        }
                                                        // getIt<CompanyDetailsManager>()
                                                        //     .disablePaynow(true);
                                                      },
                                                    ),
                                                    params.isSwitched == true
                                                        ? Column(children: [
                                                            Container(
                                                              height: h1p * 5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colours
                                                                          .white,
                                                                      offset:
                                                                          Offset(0,
                                                                              1),
                                                                      blurRadius:
                                                                          1,
                                                                      spreadRadius:
                                                                          0)
                                                                ],
                                                                color: Colours
                                                                    .white,
                                                              ),
                                                              child: Focus(
                                                                onFocusChange:
                                                                    (_) async {
                                                                  String
                                                                      settleAmt =
                                                                      paidAmountController
                                                                          .text;
                                                                  if (settleAmt
                                                                          .isNotEmpty &&
                                                                      params.isValidateSettleAmount(
                                                                              settleAmt) ==
                                                                          true) {
                                                                    progress!
                                                                        .show();
                                                                    await getIt<CompanyDetailsManager>().outstandingPayNow(
                                                                        companyId,
                                                                        params
                                                                            .chosenSellerId,
                                                                        paidAmountController
                                                                            .text,
                                                                        isToggled:
                                                                            true);
                                                                    progress
                                                                        .dismiss();
                                                                  } else {
                                                                    params
                                                                        .resetRevisedValues();
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Please enter a valid amount");
                                                                  }
                                                                },
                                                                child:
                                                                    TextFormField(
                                                                        onChanged:
                                                                            (_) {
                                                                          params
                                                                              .validateSettleAmount(paidAmountController.text);
                                                                          //  getIt<PasswordManager>().validateSettleAmount(paidAmountController.text);
                                                                        },
                                                                        controller:
                                                                            paidAmountController,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          contentPadding: EdgeInsets.symmetric(
                                                                              horizontal: w1p * 6,
                                                                              vertical: h1p * .5),
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(6),
                                                                          ),
                                                                          fillColor:
                                                                              Colours.white,
                                                                          hintText:
                                                                              "Enter Amount",
                                                                          hintStyle:
                                                                              TextStyles.textStyle128,
                                                                        )),
                                                              ),
                                                            ),
                                                            settleAmountMsg ==
                                                                    ""
                                                                ? Container()
                                                                : Row(
                                                                    children: [
                                                                      Text(
                                                                          settleAmountMsg,
                                                                          style:
                                                                              const TextStyle(color: Colors.red)),
                                                                    ],
                                                                  ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          w1p *
                                                                              2,
                                                                      vertical:
                                                                          h1p *
                                                                              2),
                                                              child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Discount",
                                                                          style:
                                                                              TextStyles.textStyle129,
                                                                        ),
                                                                        Text(
                                                                          "Interest",
                                                                          style:
                                                                              TextStyles.textStyle129,
                                                                        ),
                                                                        Text(
                                                                          "Payable Amount",
                                                                          style:
                                                                              TextStyles.textStyle129,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "₹${params.revisedDiscount.toString()}",
                                                                          style:
                                                                              TextStyles.textStyle130,
                                                                        ),
                                                                        Text(
                                                                          "₹${params.revisedInterest.toString()}",
                                                                          style:
                                                                              TextStyles.textStyle131,
                                                                        ),
                                                                        Text(
                                                                          "₹${(double.parse(params.payableAmount ?? '0') - double.parse(params.revisedDiscount ?? '0')).toStringAsFixed(2)}",
                                                                          style:
                                                                              TextStyles.textStyle132,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ]),
                                                            )
                                                          ])
                                                        : Container(),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  h1p * 2.5),
                                                      child:
                                                          // params.isDisable==true?
                                                          // Container(
                                                          //   height: h1p * 5,
                                                          //   decoration:
                                                          //   BoxDecoration(
                                                          //     borderRadius:
                                                          //     BorderRadius
                                                          //         .circular(6),
                                                          //     color: Colours
                                                          //         .paleGrey,
                                                          //   ),
                                                          //   child: Center(
                                                          //       child: Text(
                                                          //         "Pay Now",
                                                          //         style: TextStyles
                                                          //             .subHeading,
                                                          //       )),
                                                          // ):
                                                          InkWell(
                                                        onTap: () async {
                                                          if (params.isSwitched ==
                                                                  true &&
                                                              paidAmountController
                                                                  .text
                                                                  .isEmpty) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Please enter the amount');
                                                            return;
                                                          }
                                                          progress!.show();
                                                          Map<String,
                                                              dynamic> temResponse = await getIt<
                                                                  CompanyDetailsManager>()
                                                              .outstandingPayNow(
                                                                  companyId,
                                                                  params
                                                                      .chosenSellerId,
                                                                  paidAmountController
                                                                          .text
                                                                          .isEmpty
                                                                      ? outstandingAmount
                                                                          .toString()
                                                                      : paidAmountController
                                                                          .text);
                                                          progress.dismiss();
                                                          if (temResponse
                                                              .isNotEmpty) {
                                                            progress.show();
                                                            Map<String,
                                                                    dynamic>?
                                                                sendPayment =
                                                                await getIt<
                                                                        CompanyDetailsManager>()
                                                                    .sendPayment(
                                                              buyerId:
                                                                  companyId,
                                                              sellerId: params
                                                                  .chosenSellerId,
                                                              orderAmount: (params
                                                                          .payableAmount
                                                                          .toString() !=
                                                                      '0')
                                                                  ? (double.parse(params.payableAmount ??
                                                                              '0') -
                                                                          double.parse(params.revisedDiscount ??
                                                                              '0'))
                                                                      .toString()
                                                                  : payable
                                                                      .toString(),
                                                              discount: temResponse[
                                                                  'revisedDiscount'],
                                                              settle_amount: paidAmountController
                                                                      .text
                                                                      .isEmpty
                                                                  ? outstandingAmount
                                                                      .toString()
                                                                  : paidAmountController
                                                                      .text,
                                                              outStandingAmount:
                                                                  temResponse[
                                                                          'revisedTotalOutstandingAmount']
                                                                      .toString(),
                                                            );
                                                            progress.dismiss();
                                                            if (sendPayment !=
                                                                null) {
                                                              if (sendPayment[
                                                                      'status'] ==
                                                                  true) {
                                                                // ScaffoldMessenger.of(
                                                                //         context)
                                                                //     .showSnackBar(
                                                                //         SnackBar(
                                                                //             behavior:
                                                                //                 SnackBarBehavior.floating,
                                                                //             content: Text(
                                                                //               sendPayment['message'],
                                                                //               style: TextStyle(color: Colors.green),
                                                                //             )));

                                                                // if (sendPayment[
                                                                //         'payment_link'] !=
                                                                //     null) {
                                                                String url =
                                                                    sendPayment[
                                                                        'message'];
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            PaymentUrl(
                                                                              paymentUrl: url,
                                                                            )));
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                            behavior:
                                                                                SnackBarBehavior.floating,
                                                                            content: Text(
                                                                              "could not launch the url",
                                                                              style: TextStyle(color: Colors.red),
                                                                            )));
                                                              }
                                                            }
                                                          }
                                                          //    else {
                                                          //     ScaffoldMessenger
                                                          //             .of(
                                                          //                 context)
                                                          //         .showSnackBar(
                                                          //             SnackBar(
                                                          //                 behavior: SnackBarBehavior
                                                          //                     .floating,
                                                          //                 content:
                                                          //                     Text(
                                                          //                   sendPayment!['message'],
                                                          //                   style:
                                                          //                       TextStyle(color: Colors.green),
                                                          //                 )));
                                                          //   }
                                                          // } else {
                                                          //   ScaffoldMessenger
                                                          //           .of(context)
                                                          //       .showSnackBar(
                                                          //           SnackBar(
                                                          //               behavior:
                                                          //                   SnackBarBehavior
                                                          //                       .floating,
                                                          //               content:
                                                          //                   Text(
                                                          //                 "Please select the seller",
                                                          //                 style:
                                                          //                     TextStyle(color: Colors.red),
                                                          //               )));
                                                          // }
                                                        },
                                                        //  },
                                                        child: Container(
                                                          height: h1p * 5,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: Colours
                                                                .successPrimary,
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            "PAY NOW",
                                                            style: TextStyles
                                                                .subHeading,
                                                          )),
                                                        ),
                                                      ),
                                                    )
                                                  ])))),
                                    ],
                                  );
                                })
                              ]));
                        })));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }));
    });
  }
}
