import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../logic/view_models/transaction_manager.dart';
import '../../../../models/core/invoice_model.dart';
import '../../../../models/helper/service_locator.dart';
import '../../../routes/router.dart';
import '../../../theme/constants.dart';
import '../../../widgets/payment_history_widgets/bill_details.dart';
import '../../../widgets/payment_history_widgets/company_details.dart';
import '../../../widgets/profile/profile_widget.dart';

class PaidInvoiceDetails extends StatefulWidget {
  const PaidInvoiceDetails({Key? key}) : super(key: key);

  @override
  State<PaidInvoiceDetails> createState() => _PaidInvoiceDetailsState();
}

class _PaidInvoiceDetailsState extends State<PaidInvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    Invoice? invoice =
        Provider.of<TransactionManager>(context).currentPaidInvoice;
    DateTime id = DateTime.parse(invoice!.invoiceDate ?? '');
    DateTime dd = DateTime.parse(invoice.updatedAt ?? '');
    DateTime currentDate = DateTime.now();
    Duration dif = dd.difference(currentDate);
    int daysLeft = dif.inDays;

    String idueDate = DateFormat("dd-MMM-yyyy").format(dd);
    String invDate = DateFormat("dd-MMM-yyyy").format(id);
    double gstAmt;
    String paidInvAmount =
        double.parse(invoice.outstandingAmount ?? "").toStringAsFixed(2);

    double inv = double.parse(invoice.outstandingAmount ?? "");
    num discount = double.parse(invoice.paidDiscount.toString());
    num interest = double.parse(invoice.paidInterest.toString());
    String gst = invoice.billDetails!.gstSummary!.totalTax ?? "";
    if (gst != "undefined") {
      gstAmt = double.parse(gst);
    } else {
      gstAmt = 0;
    }
    gstAmt = double.parse(invoice.billDetails!.gstSummary!.totalTax ?? "");
    double invAmt = double.parse(invoice.invoiceAmount ?? "");
    double payableAMt = invAmt + gstAmt - inv;
    double paidAmt = invAmt - inv;

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
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context, landing);
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
                    height: h1p * 10,
                    width: w10p * 3,
                    decoration: BoxDecoration(
                      color: Colours.pearlGrey,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
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
                                "${invoice.invoiceNumber!}",
                                style: TextStyles.textStyle56,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Paid Amount",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "₹ ${payableAMt.toStringAsFixed(2)}",
                                style: TextStyles.textStyle56,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //  Text(
                //   "$daysLeft days left",
                //   style: TextStyles.textStyle57,
                //   textAlign: TextAlign.center,
                // ),
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
                                "Uploaded At",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                idueDate,
                                style: TextStyles.textStyle63,
                              ),
                              // Text(
                              //   invoice.seller!.companyName ?? '',
                              //   style: TextStyles.textStyle64,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                "Invoice Amount",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "₹ ${invAmt.toString()}",
                                style: TextStyles.textStyle140,
                              ),
                              // Text(
                              //   invoice.seller!.companyName ?? '',
                              //   style: TextStyles.textStyle64,
                              // ),
                            ],
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     SizedBox(
                          //       height: 4,
                          //     ),
                          //     Text(
                          //       "GST Amount",
                          //       style: TextStyles.textStyle62,
                          //     ),
                          //     Text(
                          //       gstAmt.toString(),
                          //       style: TextStyles.textStyle63,
                          //     ),
                          //     // Text(
                          //     //   invoice.seller!.companyName ?? '',
                          //     //   style: TextStyles.textStyle64,
                          //     // ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
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
                                "GST Amount",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "₹ ${gstAmt.toString()}",
                                style: TextStyles.textStyle140,
                              ),
                              // Text(
                              //   invoice.seller!.companyName ?? '',
                              //   style: TextStyles.textStyle64,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                "Outstanding Amount",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "₹ $paidInvAmount",
                                style: TextStyles.textStyle140,
                              ),
                              // Text(
                              //   invoice.seller!.companyName ?? '',
                              //   style: TextStyles.textStyle64,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                "Discount",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "₹ ${discount.toString()}",
                                style: TextStyles.textStyle143,
                              ),
                              // Text(
                              //   invoice.seller!.companyName ?? '',
                              //   style: TextStyles.textStyle64,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                "Interest",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                "₹ ${interest.toString()}",
                                style: TextStyles.textStyle142,
                              ),
                              // Text(
                              //   invoice.seller!.companyName ?? '',
                              //   style: TextStyles.textStyle64,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                "Invoice Due Date",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                invoice.invoiceDueDate.toString(),
                                style: TextStyles.textStyle140,
                              ),
                              // Text(
                              //   invoice.seller!.companyName ?? '',
                              //   style: TextStyles.textStyle64,
                              // ),
                            ],
                          ),
                        ],
                      ),
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
                // Card(
                //   elevation: .5,
                //   child: Padding(
                //     padding:  EdgeInsets.symmetric(horizontal: w10p * .5,vertical: h1p * 1),
                //     child: Column(
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children:  [
                //                 SizedBox(
                //                   height: 4,
                //                 ),
                //         //         Text(
                //         //           "Invoice Amt",
                //         //           style: TextStyles.textStyle62,
                //         //         ),
                //         //         Text(
                //         //           "₹ ${invoice.invoiceAmount.toString()}",
                //         //           style: TextStyles.textStyle65,
                //         //         )
                //         //       ],
                //         //     ),
                //         //     SizedBox(
                //         //       width: w10p * 4.5,
                //         //     ),
                //         //     Column(
                //         //       crossAxisAlignment: CrossAxisAlignment.end,
                //         //       children:  [
                //         //         SizedBox(
                //         //           height: 4,
                //         //         ),
                //         //         Text(
                //         //           "Pay Now",
                //         //           style: TextStyles.textStyle62,
                //         //         ),
                //         //         Text(
                //         //           "₹ ${invoice.invoiceAmount.toString()}",
                //         //           style: TextStyles.textStyle66,
                //         //         ),
                //         //       ],
                //         //     ),
                //         //   ],
                //         // ),
                //         // SizedBox(
                //         //   height: h1p * 1,
                //         // ),
                //         // Row(
                //         //   crossAxisAlignment: CrossAxisAlignment.start,
                //         //   mainAxisAlignment: MainAxisAlignment.start,
                //         //   children: const [
                //         //     Text(
                //         //       "You Save",
                //         //       style: TextStyles.textStyle62,
                //         //     ),
                //         //   ],
                //         // ),
                //         // Row(
                //         //   crossAxisAlignment: CrossAxisAlignment.start,
                //         //   mainAxisAlignment: MainAxisAlignment.start,
                //         //   children: const [
                //         //     Text(
                //         //       "₹ 545",
                //         //       style: TextStyles.textStyle77,
                //         //     ),
                //         //   ],
                //         // ),
                //         // Padding(
                //         //   padding:
                //         //        EdgeInsets.symmetric(horizontal: w10p * .2,vertical: h1p * 1),
                //         //   child: Container(
                //         //     height: h10p * .6,
                //         //     decoration: BoxDecoration(
                //         //       borderRadius: BorderRadius.circular(6),
                //         //       color: Colours.successPrimary,
                //         //     ),
                //         //     child: const Center(
                //         //       child: Text(
                //         //         "Pay Now",
                //         //         style: TextStyles.textStyle46,
                //         //       ),
                //         //     ),
                //         //   ),
                //         // )
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: h1p * 2,
                // ),
                // BillDetailsWidget(
                //     maxHeight: maxHeight,
                //     maxWidth: maxWidth,
                //     heading: "Bill Details"),
              ],
            ),
          )),
        ]),
      );
    });
  }
}
