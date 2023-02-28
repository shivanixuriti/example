import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xuriti/models/core/invoice_model.dart';

import '../../../../logic/view_models/transaction_manager.dart';
import '../../../../models/helper/service_locator.dart';
import '../../../routes/router.dart';
import '../../../theme/constants.dart';
import '../../../widgets/payment_history_widgets/bill_details.dart';
import '../../../widgets/payment_history_widgets/company_details.dart';
import '../../../widgets/profile/profile_widget.dart';

class UpcomingDetails extends StatefulWidget {
  UpcomingDetails({Key? key}) : super(key: key);

  @override
  State<UpcomingDetails> createState() => _UpcomingDetailsState();
}

class _UpcomingDetailsState extends State<UpcomingDetails> {
  @override
  Widget build(BuildContext context) {
    Invoice? invoice = Provider.of<TransactionManager>(context).currentInvoice;
    double gstAmt;

    DateTime id = DateTime.parse(invoice!.invoiceDate ?? '');
    DateTime dd = DateTime.parse(invoice.invoiceDueDate ?? '');

    String idueDate = DateFormat("dd-MMM-yyyy").format(dd);
    String invDate = DateFormat("dd-MMM-yyyy").format(id);

    DateTime currentDate = DateTime.now();
    Duration dif = dd.difference(currentDate);
    int daysLeft = dif.inDays;

    double outstandingAmt = double.parse(invoice.outstandingAmount ?? "");
    double invAmt = double.parse(invoice.invoiceAmount ?? "");
    if (invoice.billDetails?.gstSummary?.totalTax != "undefined") {
      gstAmt =
          double.tryParse(invoice.billDetails?.gstSummary?.totalTax ?? "0")!;
    } else {
      gstAmt = 0;
    }

    double totalInvoiceAmount = invAmt + gstAmt;
    double totalAmtPaid = totalInvoiceAmount - outstandingAmt;
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      return Scaffold(
        backgroundColor: Colours.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: h10p * 1.7,
          flexibleSpace: ProfileWidget(),
        ),
        body: Column(children: [
          SizedBox(
            height: h10p * .3,
          ),
          Expanded(
              child: Container(
            width: maxWidth,
            decoration: const BoxDecoration(
                color: Colours.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                )),
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/arrowLeft.svg"),
                        SizedBox(
                          width: w10p * .3,
                        ),
                        const Text(
                          "Back",
                          style: TextStyles.textStyle41,
                        ),
                      ],
                    ),
                  ),
                ),

                CompanyDetailsWidget(
                  maxHeight: maxHeight,
                  maxWidth: maxWidth,
                  image: "assets/images/company-vector.png",
                  companyName: invoice.seller!.companyName ?? '',
                  companyAddress: invoice.seller!.address ?? '',
                  state: invoice.seller!.state ?? '',
                  gstNo: invoice.seller!.gstin ?? '',
                  creditLimit: invoice.buyer!.creditLimit ?? '',
                  balanceCredit: invoice.buyer!.availCredit ?? '',
                ),
                SizedBox(height: h1p * 2),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    height: h1p * 9.5,
                    width: w10p * 3,
                    decoration: BoxDecoration(
                      color: Colours.pearlGrey,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w10p * .27, vertical: h1p * 1.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Invoice ID",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "${invoice.invoiceNumber}",
                                style: TextStyles.textStyle56,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Outstanding Amount",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "₹ ${outstandingAmt.toStringAsFixed(2)}",
                                style: TextStyles.textStyle56,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  " ${daysLeft.toString()} days left",
                  style: TextStyles.textStyle57,
                  textAlign: TextAlign.center,
                ),
                Card(
                  elevation: .5,
                  child: Container(
                    height: h1p * 10,
                    color: Colours.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w10p * .50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Invoice Date",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                invDate,
                                style: TextStyles.textStyle63,
                              ),
                              // Text(
                              //   invoice.seller!.companyName ?? '',
                              //   style: TextStyles.textStyle64,
                              // ),
                            ],
                          ),
                          SvgPicture.asset("assets/images/arrow.svg"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Due Date",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                idueDate,
                                style: TextStyles.textStyle63,
                              ),
                              // Text(
                              //        invoice.seller!.companyName ?? '',
                              //   style: TextStyles.textStyle64,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w10p * .5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Invoice Amount",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "₹ ${invAmt.toStringAsFixed(2)}",
                                style: TextStyles.textStyle65,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Total Invoice Amt",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "₹ ${totalInvoiceAmount.toStringAsFixed(2)}",
                                style: TextStyles.textStyle66,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding:
                      //        EdgeInsets.symmetric(horizontal: w10p * .1,vertical: h1p * 1),
                      //   child: InkWell(
                      //     onTap: (){
                      //       Navigator.pushNamed(context, paynow);
                      //     },
                      //     child: Container(
                      //       height: h10p * .55,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(6),
                      //         color: Colours.successPrimary,
                      //       ),
                      //       child: const Center(
                      //         child: Text(
                      //           "Pay Now",
                      //           style: TextStyles.textStyle46,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: h1p * 1,
                ),
                Card(
                  elevation: .5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w10p * .5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "GST Amount",
                                  style: TextStyles.textStyle62,
                                ),
                                Text(
                                  "₹ ${gstAmt.toStringAsFixed(2)}",
                                  style: TextStyles.textStyle65,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Amount Paid",
                                  style: TextStyles.textStyle62,
                                ),
                                Text(
                                  "₹ ${totalAmtPaid.toStringAsFixed(2)}",
                                  style: TextStyles.textStyle66,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h1p * 2,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: maxWidth,
                  // width: maxWidth,
                  height: 200,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: GestureDetector(
                        onTap: () async {
                          // progress!.show();
                          if (invoice.invoiceFile!.isNotEmpty) {
                            await getIt<TransactionManager>()
                                .openFile(url: invoice.invoiceFile ?? "");
                            // progress.dismiss();
                            Fluttertoast.showToast(msg: "Opening invoice file");
                          } else {
                            Fluttertoast.showToast(
                                msg: "Invoice file not found");
                          }
                        },
                        child: Image.asset("assets/images/invoiceButton.png")),
                  ),
                ),

                // BillDetailsWidget(
                //     maxHeight: maxHeight,
                //     maxWidth: maxWidth,
                //     heading: "Bill Details"),

                // Padding(
                //   padding: const EdgeInsets.only(left: 15),
                //   child: Row(
                //     children: const [
                //       Text(
                //         "Added rewards_screens",
                //         style: TextStyles.textStyle38,
                //       )
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 1,
                //   child: Padding(
                //     padding: const EdgeInsets.all(15),
                //     child: Container(
                //       height: h10p * 3,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(15),
                //         color: Colours.offWhite,
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.only(top: 50),
                //             child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Image.asset(
                //                       "assets/images/xuritiRewards.png"),
                //                   const Text(
                //                     "Free Credit Period Extention",
                //                     style: TextStyles.textStyle44,
                //                   ),
                //                   const Text(
                //                     "of 7 Days for upto ₹ 75,000/-",
                //                     style: TextStyles.textStyle44,
                //                   ),
                //                   Image.asset("assets/images/claimButton.png")
                //                 ]),
                //           ),
                //           Image.asset("assets/images/claimlogo.png")
                //         ],
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          )),
        ]),
      );
    });
  }
}
