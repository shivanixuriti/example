import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xuriti/logic/view_models/kyc_manager.dart';

import '../../../models/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/document_uploading.dart';
import '../../widgets/kyc_widgets/submitt_button.dart';

class FinancialGstDetails extends StatefulWidget {
  const FinancialGstDetails({Key? key}) : super(key: key);

  @override
  State<FinancialGstDetails> createState() => _FinancialGstDetailsState();
}

class _FinancialGstDetailsState extends State<FinancialGstDetails> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints)
    {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      double w1p = maxWidth * 0.01;
      return SafeArea(child: Scaffold(
          backgroundColor: Colours.black,
          appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: h10p * .9,
              flexibleSpace: AppbarWidget()),
          body: Container(
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
                        SvgPicture.asset("assets/images/arrowLeft.svg"),
                        SizedBox(
                          width: w10p * .3,
                        ),
                        const Text(
                          "Financial & GST Details ",
                          style: TextStyles.leadingText,
                        ),
                        const Text(
                          "(Upto 24 Months)",
                          style: TextStyles.textStyle119,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: w1p * 6,
                      right: w1p * 6,

                      top: h1p * 1.5),
                  child: Text(
                    "Financial Details",
                    style: TextStyles.textStyle54,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w1p * 6,


                      vertical: h1p * 3),
                  child: Text(
                    "P & L",
                    style: TextStyles.textStyle123,
                  ),
                ),
                DocumentUploading(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w1p * 6,


                      vertical: h1p * 3),
                  child: Text(
                    "Balance Sheet",
                    style: TextStyles.textStyle123,
                  ),
                ),
                DocumentUploading(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w1p * 6,


                      vertical: h1p * 3),
                  child: Text(
                    "Other Schedules",
                    style: TextStyles.textStyle123,
                  ),
                ),
                DocumentUploading(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                ),

                InkWell(
                  onTap: () async {
                    await getIt<KycManager>().storeFinancialDetails();
                    Fluttertoast.showToast(msg:"successfully uploaded");

                  },
                  child: Submitbutton(
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    content: "Save & Continue",
                    isKyc: true,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      left: w1p * 6,right: w1p * 7,


                      top: h1p * 5,bottom: h1p * 2),
                  child: Text(
                    "GST Details",
                    style: TextStyles.textStyle54,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w1p * 6,
                      vertical: h1p * 2),
                  child: Text(
                    "GST Return Files",
                    style: TextStyles.textStyle123,
                  ),
                ),
                DocumentUploading(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                ),
                InkWell(
                  onTap: () async {
                  await  getIt<KycManager>().storeGstDetails();
                    Fluttertoast.showToast(msg:"successfully uploaded");
                    Navigator.pop(context);
                  },
                  child: Submitbutton(
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    content: "Save & Continue",
                    isKyc: true,
                  ),
                )
              ]))
      ));
    });
  }
}
