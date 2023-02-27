import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xuriti/ui/screens/invoices_screens/pending_invoices_screen/all_pending_invoices.dart';
import 'package:xuriti/ui/screens/invoices_screens/pending_invoices_screen/pending_invoice_report.dart';
import 'package:xuriti/ui/widgets/kyc_widgets/submitt_button.dart';

import '../../../logic/view_models/transaction_manager.dart';
import '../../../models/core/invoice_model.dart';
import '../../../models/helper/service_locator.dart';
import '../../routes/router.dart';
import '../../theme/constants.dart';

class PendingInvoiceWidget extends StatelessWidget {
  final double maxWidth;
  final Function? refreshingMethod;
  final double maxHeight;
  final bool isOverdue;
  final String amount;
  final String savedAmount;
  final String invoiceDate;
  final String dueDate;
  Invoice fullDetails;
  int index;
  bool userConsentGiven = false;
  List<Invoice> pendingInvoice = [];
  final String companyName;
  PendingInvoiceWidget(
      {required this.fullDetails,
      required this.maxWidth,
      required this.maxHeight,
      required this.amount,
      required this.savedAmount,
      required this.index,
      required this.invoiceDate,
      required this.dueDate,
      required this.companyName,
      required this.isOverdue,
      required this.refreshingMethod});

  @override
  Widget build(BuildContext context) {
    TextEditingController acceptController = TextEditingController();
    TextEditingController rejectController = TextEditingController();

    String? invoiceId = fullDetails.sId;
    String invAmt = double.parse(amount).toStringAsFixed(2);

    DateTime id = DateTime.parse(invoiceDate);
    DateTime dd = DateTime.parse(dueDate);
    DateTime currentDate = DateTime.now();
    Duration dif = dd.difference(currentDate);
    int daysLeft = dif.inDays;
    String idueDate = DateFormat("dd-MMM-yyyy").format(dd);
    String invDate = DateFormat("dd-MMM-yyyy").format(id);

    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    return ProgressHUD(child: Builder(builder: (context) {
      final progress = ProgressHUD.of(context);
      return ExpandableNotifier(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w10p * .5, vertical: 10),
          child: Expandable(
              collapsed: ExpandableButton(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colours.offWhite,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isOverdue
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: h1p * 1),
                                      child: Container(
                                        // height: h1p * 4.5,
                                        // width: w10p * 1.7,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colours.failPrimary,
                                        ),
                                        child: const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              "Overdue",
                                              style: TextStyles.overdue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),

                              Row(
                                children: [
                                  Text(
                                    "${fullDetails.invoiceNumber}",
                                    style: TextStyles.textStyle6,
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/home_images/arrow-circle-right.svg"),
                                ],
                              ),

                              Text(
                                companyName,
                                style: TextStyles.companyName,
                              ),
                              // isOverdue?
                              // const Text(
                              //   "interest charged",
                              //   style: TextStyles.textStyle102,
                              // ):
                              // // const Text(
                              // //  "You Save",
                              // //   style: TextStyles.textStyle102,
                              // // ),
                              // Text(
                              //   "₹ $savedAmount",
                              //  style: isOverdue?
                              //  TextStyles.textStyle61 :
                              //   TextStyles.textStyle100,
                              // )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              isOverdue
                                  ? Text(
                                      "$daysLeft days Overdue",
                                      style: TextStyles.textStyle57,
                                    )
                                  : Text(
                                      "$daysLeft days left",
                                      style: TextStyles.textStyle57,
                                    ),
                              Text(
                                "₹ $invAmt",
                                style: TextStyles.textStyle58,
                              ),
                            ],
                          )
                        ]),
                  ),
                ),
              ),
              expanded: Column(
                children: [
                  ExpandableButton(
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colours.offWhite,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isOverdue
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: h1p * 1),
                                          child: Container(
                                            // height: h1p * 4.4,
                                            // width: w10p * 1.7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colours.failPrimary,
                                            ),
                                            child: const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(3.5),
                                                child: Text(
                                                  "Overdue",
                                                  style: TextStyles.overdue,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Row(
                                    children: [
                                      Text(
                                        "${fullDetails.invoiceNumber}",
                                        style: TextStyles.textStyle6,
                                      ),
                                      SvgPicture.asset(
                                          "assets/images/home_images/rightArrow.svg"),
                                    ],
                                  ),

                                  Text(
                                    companyName,
                                    style: TextStyles.companyName,
                                  ),
                                  // isOverdue? const Text(
                                  //   "Interest charged",
                                  //   style: TextStyles.textStyle102,
                                  // ):
                                  // Text(
                                  //   "You Save",
                                  //   style: TextStyles.textStyle102,
                                  // ),
                                  // Text(
                                  //   "₹ $savedAmount",
                                  //   style:isOverdue?
                                  //   TextStyles.textStyle61:
                                  //   TextStyles.textStyle100,
                                  // )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  isOverdue
                                      ? Text(
                                          "$daysLeft days Overdue",
                                          style: TextStyles.textStyle57,
                                        )
                                      : Text(
                                          "$daysLeft days left",
                                          style: TextStyles.textStyle57,
                                        ),
                                  Text(
                                    "₹ $invAmt",
                                    style: TextStyles.textStyle58,
                                  ),
                                ],
                              )
                            ]),
                      ),
                    ),
                  ),
                  Card(
                    elevation: .5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              const Text(
                                "Invoice Date",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                invDate,
                                style: TextStyles.textStyle63,
                              ),
                              // Text(
                              //   companyName,
                              //   style: TextStyles.companyName,
                              // ),
                            ],
                          ),
                          SvgPicture.asset("assets/images/arrow.svg"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              const Text(
                                "Due Date",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                idueDate,
                                style: TextStyles.textStyle63,
                              ),
                              // Text(
                              //  companyName,
                              //   style: TextStyles.companyName,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text(
                                    "Invoice Amount",
                                    style: TextStyles.textStyle62,
                                  ),
                                  Text(
                                    "₹ $invAmt",
                                    style: TextStyles.textStyle65,
                                  )
                                  //    Text("Asian Paints",style: TextStyles.textStyle34,),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  isOverdue
                                      ? const Text(
                                          "Payabe Amount",
                                          style: TextStyles.textStyle62,
                                        )
                                      : const Text(
                                          "Pay Now",
                                          style: TextStyles.textStyle62,
                                        ),
                                  Text(
                                    "₹ $invAmt",
                                    style: TextStyles.textStyle66,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: h1p * 1.5,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         isOverdue?
                          //         const Text(
                          //           "Interest",
                          //           style: TextStyles.textStyle62,
                          //         ):
                          //         const Text(
                          //           "You Save",
                          //           style: TextStyles.textStyle62,
                          //         ),
                          //         Text(
                          //           "₹ $savedAmount",
                          //           style:isOverdue?
                          //           TextStyles.textStyle73:
                          //           TextStyles.textStyle77,
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: GestureDetector(
                                onTap: () {
                                  progress!.show();
                                  getIt<TransactionManager>()
                                      .changeSelectedInvoice(fullDetails);
                                  progress.dismiss();
                                  Navigator.pushNamed(context, savemoreDetails);
                                },
                                child: Image.asset(
                                    "assets/images/viewetails.png")),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      // vertical: h10p * 5,
                                                      ),
                                              child: AlertDialog(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                title: Row(
                                                  children: const [
                                                    Center(
                                                      child: Text("Comment"),
                                                    ),
                                                  ],
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          rejectController,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Leave a comment *"),
                                                      onChanged: (_) {
                                                        acceptController
                                                                .text.isEmpty
                                                            ? Row(
                                                                children: const [
                                                                  Text(
                                                                    "Please write a reason",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container();
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: h1p * 5,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (rejectController
                                                            .text.isNotEmpty) {
                                                          userConsentGiven =
                                                              false;
                                                          String timeStamp =
                                                              DateTime.now()
                                                                  .toString();
                                                          progress!.show();
                                                          print(acceptController
                                                              .text);
                                                          String message = await getIt<
                                                                  TransactionManager>()
                                                              .changeInvoiceStatus(
                                                                  invoiceId,
                                                                  "Rejected",
                                                                  index,
                                                                  fullDetails,
                                                                  timeStamp,
                                                                  userConsentGiven,
                                                                  acceptController
                                                                      .text,
                                                                  "NA");
                                                          progress.dismiss();

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating,
                                                                      content:
                                                                          Text(
                                                                        message,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )));
                                                          Navigator.pop(
                                                              context);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Please write a reason",
                                                              textColor:
                                                                  Colors.red);
                                                        }
                                                      },
                                                      child: Container(
                                                        height: h1p * 8,
                                                        width: w10p * 7.5,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: Colours
                                                                .pumpkin),
                                                        child: const Center(
                                                            child: Text(
                                                          "Save",
                                                          style: TextStyles
                                                              .subHeading,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Container(
                                    height: h1p * 9,
                                    decoration: BoxDecoration(
                                        color: Colours.failPrimary,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Center(
                                      child: Text(
                                        "Reject",
                                        style: TextStyles.textStyle46,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      // vertical: h10p * 4,
                                                      ),
                                              child: AlertDialog(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                title: const Center(
                                                  child: Text("Consent"),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        "I agree and  approve Xuriti and ${fullDetails.nbfcName} is authorised to disburse funds to the Seller $companyName for invoice -${fullDetails.invoiceNumber} on my behalf."),
                                                    TextField(
                                                      controller:
                                                          acceptController,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Leave a comment *"),
                                                      onChanged: (_) {
                                                        print(acceptController
                                                            .text);
                                                        acceptController
                                                                .text.isEmpty
                                                            ? Row(
                                                                children: const [
                                                                  Text(
                                                                    "Please write a reason",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container();
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: h1p * 4,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        userConsentGiven = true;
                                                        String timeStamp =
                                                            DateTime.now()
                                                                .toString();
                                                        if (acceptController
                                                            .text.isNotEmpty) {
                                                          progress!.show();

                                                          String? message = await getIt<
                                                                  TransactionManager>()
                                                              .changeInvoiceStatus(
                                                                  invoiceId,
                                                                  "Confirmed",
                                                                  index,
                                                                  fullDetails,
                                                                  timeStamp,
                                                                  userConsentGiven,
                                                                  acceptController
                                                                      .text,
                                                                  "I agree and approve Xuriti and ${fullDetails.nbfcName} is authorised to disburse funds to the Seller $companyName for invoice -${fullDetails.invoiceNumber} on my behalf.");
                                                          progress.dismiss();
                                                          if (refreshingMethod !=
                                                              null) {
                                                            refreshingMethod!();
                                                          }

                                                          print(
                                                              '${message} ====================>');
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating,
                                                                      content:
                                                                          Text(
                                                                        message!,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.green),
                                                                      )));
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Please write a reason",
                                                              textColor:
                                                                  Colors.red);
                                                        }

                                                        Navigator.pop(context);
                                                        // Navigator.of(context);

                                                        // Navigator.of(context)
                                                        //     .pushNamed(
                                                        //         '/pInvoices');
                                                      },
                                                      child: Container(
                                                        height: h1p * 8,
                                                        width: w10p * 7.5,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: Colours
                                                                .pumpkin),
                                                        child: const Center(
                                                            child: Text(
                                                          "Accept",
                                                          style: TextStyles
                                                              .subHeading,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Container(
                                    height: h1p * 9,
                                    decoration: BoxDecoration(
                                        color: Colours.successPrimary,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Center(
                                      child: Text(
                                        "Accept",
                                        style: TextStyles.textStyle46,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    }));
  }
}
