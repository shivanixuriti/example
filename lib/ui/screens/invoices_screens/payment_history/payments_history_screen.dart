import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/models/core/payment_history_model.dart';
import '../../../../logic/view_models/auth_manager.dart';
import '../../../../logic/view_models/trans_history_manager.dart';
import '../../../../models/core/user_details.dart';
import '../../../../models/helper/service_locator.dart';
import '../../../theme/constants.dart';
import '../../../widgets/download_report_widget.dart';
import 'all_payment_history.dart';

class PHistory extends StatefulWidget {
  const PHistory({Key? key}) : super(key: key);

  @override
  State<PHistory> createState() => _PHistoryState();
}

class _PHistoryState extends State<PHistory> {
  TextEditingController _textController = TextEditingController();

  DateTime dateTime = DateTime.now();

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      _textController.text = DateFormat.yMd().format(dateTime);
    }
  }

  String? doc;
  // @override
  //
  // void dispose() {
  //
  //   getIt<TransHistoryManager>().resetFilterDetails();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    String? token = getIt<SharedPreferences>().getString('token');
    String? companyId = getIt<SharedPreferences>().getString('companyId');
    // List<String> sellerName =
    //     Provider.of<TransHistoryManager>(context).sellerNameList;
    // String? sellerData = Provider.of<TransHistoryManager>(context).sellerData;
    // PaymentHistory? data = Provider.of<TransHistoryManager>(context).paymentDetails;
    //
    // UserDetails? userInfo = Provider.of<AuthManager>(context).uInfo;
    // String? createdDate = userInfo!.user!.createdAt;
    // DateTime td = DateTime.parse(createdDate!);
    // String transDate = DateFormat("yyyy-MM-dd").format(td);

    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;

      return FutureBuilder(
          future:
              getIt<TransHistoryManager>().getPaymentHistory(token, companyId),
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
                PaymentHistory datas = snapshot.data as PaymentHistory;
                return datas.status == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Container(
                            width: maxWidth,
                            height: maxHeight,
                            decoration: const BoxDecoration(
                                color: Colours.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(26),
                                  topRight: Radius.circular(26),
                                )),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: h1p * 4, horizontal: w10p * .5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Payment History",
                                          style: TextStyles.textStyle38),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "Filters     ",
                                      //       style: TextStyles.textStyle38,
                                      //     ),
                                      //     SvgPicture.asset(
                                      //         "assets/images/filterRight.svg"),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w10p * .6, vertical: h1p * 1),
                                  child: Container(
                                      width: maxWidth,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colours.offWhite),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: h1p * 3,
                                            horizontal: w10p * .3),
                                        child: Row(children: [
                                          SvgPicture.asset(
                                              "assets/images/logo1.svg"),
                                          SizedBox(
                                            width: w10p * 0.5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                              Text(
                                                "You have not made any payment yet.",
                                                style: TextStyles.textStyle34,
                                              ),
                                            ],
                                          ),
                                        ]),
                                      )),
                                ),
                                SizedBox(
                                  height: h1p * 8,
                                ),
                                Center(
                                  child: Image.asset(
                                      "assets/images/onboard-image-2.png"),
                                ),
                              ],
                            )))
                    : Consumer<TransHistoryManager>(
                        builder: (context, params, child) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Container(
                                width: maxWidth,
                                height: maxHeight,
                                decoration: const BoxDecoration(
                                    color: Colours.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(26),
                                      topRight: Radius.circular(26),
                                    )),
                                child: CustomScrollView(
                                  slivers: [
                                    // SliverToBoxAdapter(
                                    //   child: DownloadReport(
                                    //     maxHeight: maxHeight,
                                    //     maxWidth: maxWidth,
                                    //   ),
                                    // ),
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: h1p * 4,
                                            horizontal: w10p * .5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Payment History",
                                                style: TextStyles.textStyle38),
                                            InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      25)),
                                                    ),
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return Wrap(
                                                        children: [
                                                          Container(
                                                            width: maxWidth,
                                                            height: h10p * 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(18),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            h1p *
                                                                                1),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // Text(
                                                                    //   "Filter by Invoice date",
                                                                    //   style: TextStyles
                                                                    //       .textStyle38,
                                                                    // ),
                                                                    // Padding(
                                                                    //     padding: EdgeInsets.symmetric(
                                                                    //         horizontal: w10p *
                                                                    //             .3,
                                                                    //         vertical:
                                                                    //             h1p * 4),
                                                                    //     child: Container(
                                                                    //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colours.wolfGrey, width: 1), color: Colours.paleGrey),
                                                                    //         child: TextFormField(
                                                                    //           controller: _textController,
                                                                    //           decoration: InputDecoration(
                                                                    //               icon: Padding(
                                                                    //                 padding: const EdgeInsets.all(8.0),
                                                                    //                 child: Icon(
                                                                    //                   Icons.calendar_today,
                                                                    //                   color: Colours.primary,
                                                                    //                 ),
                                                                    //               ), //icon of text field
                                                                    //               labelText: "Enter Date" //label text of field
                                                                    //               ),
                                                                    //           readOnly: true,
                                                                    //         ))),
                                                                    Text(
                                                                      "Filter by Seller",
                                                                      style: TextStyles
                                                                          .textStyle38,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: w10p *
                                                                              .3,
                                                                          vertical:
                                                                              h1p * 3),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            border: Border.all(color: Colours.wolfGrey, width: 1),
                                                                            color: Colours.paleGrey),
                                                                        child: DropdownButton<
                                                                            String>(
                                                                          underline:
                                                                              SizedBox(),
                                                                          isExpanded:
                                                                              true,
                                                                          value:
                                                                              params.sellerData,
                                                                          // icon: SvgPicture.asset("assets/images/dropdown-icon.svg"),
                                                                          // style: TextS,
                                                                          onChanged:
                                                                              (String? newValue) async {
                                                                            await getIt<TransHistoryManager>().filterBySeller(newValue);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          items: params
                                                                              .sellerNameList
                                                                              .map<DropdownMenuItem<String>>((String value) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: value,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: AutoSizeText(
                                                                                  value,
                                                                                  style: TextStyles.textStyle6,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                          hint:
                                                                              Container(
                                                                            width:
                                                                                150, //and here
                                                                            child:
                                                                                Text(
                                                                              "Please Select Seller",
                                                                              style: TextStyles.textStyle128,
                                                                              textAlign: TextAlign.end,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Filters     ",
                                                    style:
                                                        TextStyles.textStyle38,
                                                  ),
                                                  SvgPicture.asset(
                                                      "assets/images/filterRight.svg"),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                      ((context, index) {
                                        String? companyName = "";
                                        String? invoiceAmount = "";
                                        String? invoiceDate = "";
                                        String? dueDate = "";
                                        String? paymentDate = "";
                                        String? invoiceId = "";
                                        String? sellerId = "";

                                        TrancDetail? fullDetails;
                                        if (params
                                                .paymentDetails!.trancDetail !=
                                            null) {
                                          invoiceAmount = params.paymentDetails!
                                              .trancDetail![index].orderAmount;

                                          companyName = params
                                                  .paymentDetails!
                                                  .trancDetail![index]
                                                  .sellerName!
                                                  .isEmpty
                                              ? ""
                                              : params
                                                  .paymentDetails!
                                                  .trancDetail![index]
                                                  .sellerName;

                                          sellerId = params
                                                  .paymentDetails!
                                                  .trancDetail![index]
                                                  .sellerId!
                                                  .isEmpty
                                              ? ""
                                              : params.paymentDetails!
                                                  .trancDetail![index].sellerId;
                                          getIt<SharedPreferences>()
                                              .setString('sellerId', sellerId!);

                                          invoiceDate = params.paymentDetails!
                                              .trancDetail![index].createdAt;

                                          dueDate = params.paymentDetails!
                                              .trancDetail![index].createdAt;
                                          paymentDate = params.paymentDetails!
                                              .trancDetail![index].createdAt;
                                          invoiceId = params
                                                  .paymentDetails!
                                                  .trancDetail![index]
                                                  .invoiceNumber!
                                                  .isEmpty
                                              ? ""
                                              : params
                                                  .paymentDetails!
                                                  .trancDetail![index]
                                                  .invoiceNumber;
                                          fullDetails = params.paymentDetails!
                                              .trancDetail![index];
                                        }
                                        // Seller? seller =
                                        //     data.trancDetail![index].seller;
                                        return AllPaymentHistory(
                                          maxWidth: maxWidth,
                                          maxHeight: maxHeight,
                                          companyName: companyName ?? '',
                                          invoiceAmount: invoiceAmount ?? '',
                                          invoiceDate: invoiceDate ?? '',
                                          dueDate: dueDate ?? '',
                                          paymentDate: paymentDate ?? '',
                                          fullDetails: fullDetails!,
                                          invoiceId: invoiceId ?? '',
                                          sellerId: sellerId,
                                        );
                                      }),
                                      childCount: params
                                          .paymentDetails!.trancDetail!.length,
                                    )),
                                  ],
                                )));
                      });
              }
              // PaymentHistory data = snapshot.data as PaymentHistory;

            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
              // return Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 15),
              //     child: Container(
              //         width: maxWidth,
              //         height: maxHeight,
              //         decoration: const BoxDecoration(
              //             color: Colours.white,
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(26),
              //               topRight: Radius.circular(26),
              //             )),
              //         child: Column(
              //           children: [
              //             Padding(
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: 18, vertical: h1p * 4),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   const Text("Payment ",
              //                       style: TextStyles.textStyle38),
              //                   // Row(
              //                   //   children: [
              //                   //     Text(
              //                   //       "Filters     ",
              //                   //       style: TextStyles.textStyle38,
              //                   //     ),
              //                   //     SvgPicture.asset(
              //                   //         "assets/images/filterRight.svg"),
              //                   //   ],
              //                   // )
              //                 ],
              //               ),
              //             ),
              //             Padding(
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: w10p * .6, vertical: h1p * 1),
              //               child: Container(
              //                   width: maxWidth,
              //                   decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(16),
              //                       color: Colours.offWhite),
              //                   child: Padding(
              //                     padding: EdgeInsets.symmetric(
              //                         vertical: h1p * 3, horizontal: w10p * .3),
              //                     child: Row(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         children: [
              //                           SvgPicture.asset(
              //                               "assets/images/logo1.svg"),
              //                           SizedBox(
              //                             width: w10p * 0.5,
              //                           ),
              //                           Row(
              //                             children: const [
              //                               Text(
              //                                 "You have not made any payment yet.",
              //                                 style: TextStyles.textStyle34,
              //                               ),
              //                             ],
              //                           ),
              //                         ]),
              //                   )),
              //             ),
              //             SizedBox(
              //               height: h1p * 8,
              //             ),
              //             Center(
              //               child: Image.asset(
              //                   "assets/images/onboard-image-2.png"),
              //             ),
              //           ],
              //         )));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    });
  }
}
