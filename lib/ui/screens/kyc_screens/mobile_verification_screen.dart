import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../logic/view_models/kyc_manager.dart';
import '../../../models/core/mobile_verification_model.dart';
import '../../../models/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/document_uploading.dart';
import '../../widgets/kyc_widgets/submitt_button.dart';

class MobileVerification extends StatefulWidget {
  const MobileVerification({Key? key}) : super(key: key);

  @override
  State<MobileVerification> createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification> {
  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      double w1p = maxWidth * 0.01;
      return SafeArea(
          child: Scaffold(
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
                              "Mobile Verification",
                              style: TextStyles.leadingText,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: w1p * 6, right: w1p * 6, top: h1p * 3),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color(0x26000000),
                                offset: Offset(0, 1),
                                blurRadius: 1,
                                spreadRadius: 0)
                          ],
                          color: Colours.paleGrey,
                        ),
                        child: TextFormField(
                            controller: numberController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: w1p * 6, vertical: h1p * .5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colours.paleGrey,
                              hintText: "Mobile Number",
                              hintStyle: TextStyles.textStyle120,
                            )),
                      ),
                    ),
                    // SizedBox(
                    //   height: h1p * 3,
                    // ),
                    InkWell(
                      onTap: () async {
                        print("mobile----${numberController.text}");
                        Map<String, dynamic> kyc = await getIt<KycManager>()
                            .generateOTP(numberController.text);

                        //    progress.dismiss();
                        //    print("doc---- $kyc");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              kyc['msg'],
                              style: TextStyle(
                                  color: kyc['status'] == true
                                      ? Colors.green
                                      : Colors.green),
                            )));
                        // Navigator.pop(context);
                      },
                      child: Submitbutton(
                        maxWidth: maxWidth,
                        maxHeight: maxHeight,
                        content: "Generate OTP",
                        isKyc: true,
                      ),
                    ),

                    // SizedBox(
                    //   height: h1p * 3,
                    // ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: w1p * 6, right: w1p * 6, top: h1p * 3),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color(0x26000000),
                                offset: Offset(0, 1),
                                blurRadius: 1,
                                spreadRadius: 0)
                          ],
                          color: Colours.paleGrey,
                        ),
                        child: TextFormField(
                            controller: otpController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: w1p * 6, vertical: h1p * .5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colours.paleGrey,
                              hintText: "OTP",
                              hintStyle: TextStyles.textStyle120,
                            )),
                      ),
                    ),
                    // SizedBox(
                    //   height: h1p * 3,
                    // ),
                    InkWell(
                      onTap: () async {
                        await getIt<KycManager>().verifyOTP(otpController.text);
                        Fluttertoast.showToast(msg: "OTP Verified..");
                      },
                      child: Submitbutton(
                        maxWidth: maxWidth,
                        maxHeight: maxHeight,
                        isKyc: true,
                        content: "Verify OTP",
                      ),
                    ),
                  ]))));
    });
  }
}
