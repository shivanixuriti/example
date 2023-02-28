import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:xuriti/logic/view_models/transaction_manager.dart';
import 'package:xuriti/models/core/invoice_model.dart';

import '../../../theme/constants.dart';
import '../../../widgets/pending_invoices_widget/paid_invoice_widget.dart';

class PaidInvoices extends StatefulWidget {
  const PaidInvoices({Key? key}) : super(key: key);

  @override
  State<PaidInvoices> createState() => _PInvoicesState();
}

class _PInvoicesState extends State<PaidInvoices> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      List<Invoice> paidInvoice =
          Provider.of<TransactionManager>(context).paidInvoices;
      if (paidInvoice.isNotEmpty) {
        paidInvoice.sort((b, a) {
          String newA = a.invoiceDate ?? '';
          String newB = b.invoiceDate ?? '';
          DateTime dtA = DateTime.parse(newA);
          DateTime dtB = DateTime.parse(newB);
          if (newA == '') {
            return 0;
          } else if (newB == '') {
            return 0;
          } else if (newA == '' && newB == '') {
            return 0;
          } else {
            return dtA.compareTo(dtB);
          }
        });
      }
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
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
              child: paidInvoice.isEmpty
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: h1p * 4, horizontal: w10p * .3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("All Paid Invoices",
                                  style: TextStyles.textStyle38),
                              // Row(
                              //   children: [
                              //     Text(
                              //       "Filters     ",
                              //       style: TextStyles.textStyle38,
                              //     ),
                              //     SvgPicture.asset("assets/images/filterRight.svg"),
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
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colours.offWhite),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: h1p * 4, horizontal: w10p * .3),
                                child: Row(children: [
                                  SvgPicture.asset("assets/images/logo1.svg"),
                                  SizedBox(
                                    width: w10p * 0.5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: const [
                                                Text(
                                                  "Please wait while we connect you with ",
                                                  style: TextStyles.textStyle34,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            "your sellers and load your invoices>>",
                                            style: TextStyles.textStyle34,
                                          )
                                        ],
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
                          child:
                              Image.asset("assets/images/onboard-image-3.png"),
                        ),
                      ],
                    )
                  : CustomScrollView(
                      slivers: [
                        // SliverToBoxAdapter(
                        //   child:DownloadReport(maxHeight: maxHeight,maxWidth: maxWidth,),
                        //
                        // ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: h1p * 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("All Paid Invoices",
                                    style: TextStyles.textStyle38),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Filters     ",
                                //       style: TextStyles.textStyle38,
                                //     ),
                                //     SvgPicture.asset("assets/images/filterRight.svg"),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        ),

                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          ((context, index) {
                            Buyer? buyr = paidInvoice[index].seller;
                            return PaidInvoiceWidget(
                              maxWidth: maxWidth,
                              maxHeight: maxHeight,
                              amount: paidInvoice[index]
                                  .outstandingAmount
                                  .toString(),
                              invoiceDate: paidInvoice[index].invoiceDate ?? "",
                              dueDate: paidInvoice[index].updatedAt ?? "",
                              companyName: buyr!.companyName ?? "",
                              savedAmount: "500",
                              gst: paidInvoice[index]
                                      .billDetails
                                      ?.gstSummary
                                      ?.totalTax ??
                                  "",
                              isOverdue: false,
                              invoiceAmount:
                                  paidInvoice[index].invoiceAmount ?? "",
                              fullDetails: paidInvoice[index],
                            );
                          }),
                          childCount: paidInvoice.length,
                        )),
                      ],
                    )));
    });
  }
}
