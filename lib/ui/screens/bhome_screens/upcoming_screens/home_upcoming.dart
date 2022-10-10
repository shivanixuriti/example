import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';
import 'package:xuriti/models/core/invoice_model.dart';

import '../../../../logic/view_models/transaction_manager.dart';
import '../../../../models/helper/service_locator.dart';
import '../../../routes/router.dart';
import '../../../theme/constants.dart';

class HomeUpcoming extends StatefulWidget {
  String companyName;
  Invoice fullDetails;
  String amount;
  String invoiceDate;
  String dueDate;
  String invoiceNumber;
  HomeUpcoming({required this.invoiceNumber,
    required this.fullDetails,required this.companyName,required this.amount,required this.invoiceDate,required this.dueDate}) ;

  @override
  State<HomeUpcoming> createState() => _HomeUpcomingState();
}

class _HomeUpcomingState extends State<HomeUpcoming> {
  @override
  Widget build(BuildContext context) {
    DateTime dd = DateTime.parse(widget.dueDate);
    DateTime id = DateTime.parse(widget.invoiceDate);

    DateTime currentDate = DateTime.now();
    Duration dif = dd.difference(currentDate);
    int daysLeft = dif.inDays;

    String dueDate = DateFormat("dd-MMM-yyyy").format(dd);
    String invDate = DateFormat("dd-MMM-yyyy").format(id);

    // String invId = widget.invoiceNumber.substring(widget.invoiceNumber.length-4,widget.invoiceNumber.length);
        // "# ${fullDetails.sId!.substring(fullDetails.sId!.length-4,fullDetails.sId!.length)} ",
    String amount = double.parse(widget.amount).toStringAsFixed(2);


    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      return
        ExpandableNotifier(
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
                              Row(
                                children: [
                                   AutoSizeText(
                                     widget.invoiceNumber,

                                    style: TextStyles.textStyle6,
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/home_images/arrow-circle-right.svg"),
                                ],
                              ),
                               Text(
                                widget.companyName,
                                style: TextStyles.companyName,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:  [
                              Text(
                                " ${daysLeft.toString()} days left" ,
                                style: TextStyles.textStyle57,
                              ),
                              Text(
                                "₹ $amount",
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
                                  Row(
                                    children: [
                                       Text(
                                         widget.invoiceNumber,

                                        style: TextStyles.textStyle6,
                                      ),
                                      SvgPicture.asset(
                                          "assets/images/home_images/rightArrow.svg"),
                                    ],
                                  ),
                                   Text(
                                    widget.companyName,
                                    style: TextStyles.companyName,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children:  [
                                  Text(

                                   " ${daysLeft.toString()} days left" ,
                                    style: TextStyles.textStyle57,
                                  ),
                                  Text(
                                    "₹ $amount",

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
                            children:  [
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
                              //   widget.companyName,
                              //   style: TextStyles.companyName,
                              // ),
                            ],
                          ),
                          SvgPicture.asset("assets/images/arrow.svg"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:  [
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Due Date",
                                style: TextStyles.textStyle62,
                              ),
                              Text(
                                dueDate,
                                style: TextStyles.textStyle63,
                              ),
                              // Text(
                              //   widget.companyName,
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
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Invoice Amount",
                                    style: TextStyles.textStyle62,
                                  ),
                                  Text(
                                    "₹ $amount",
                                    style: TextStyles.textStyle65,
                                  )
                                  //    Text("Asian Paints",style: TextStyles.textStyle34,),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children:  [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Pay Now",
                                    style: TextStyles.textStyle62,
                                  ),
                                  Text(
                                    "₹ $amount",
                                    style: TextStyles.textStyle66,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: GestureDetector(
                                onTap: () {
                                  getIt<TransactionManager>().changeSelectedInvoice(widget.fullDetails);
                                  Navigator.pushNamed(context, upcomingDetails);
                                },
                                child: Image.asset(
                                    "assets/images/viewetails.png")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }
}

