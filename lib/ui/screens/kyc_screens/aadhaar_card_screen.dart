import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Controller/kycController.dart';
import '../../../Model/AdhaarCapture.dart';
import '../../../logic/view_models/kyc_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/document_uploading.dart';
import '../../widgets/kyc_widgets/submitt_button.dart';
//import 'getAdhaarDetails.dart';
import 'package:http/http.dart' as http;

class AadhaarCard extends StatefulWidget {
  var data;
  dynamic? url;
  // const AadhaarCard(data, {Key? key}, this.da) : super(key: key);
  AadhaarCard(this.data) {
    var response = data['data'];
    url = response.toString();
    print("URL --->$url");
    print('Constructor Data ------> $data');
  }

  @override
  State<AadhaarCard> createState() => _AadhaarCardState(this.data);
}

class _AadhaarCardState extends State<AadhaarCard> {
  TextEditingController aadhaarController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController reCaptchaController = TextEditingController();
  late File frontImage;
  late File backImage;
  bool isCaptured = false;
  var data;
  var url;
  String imageUrl = "";
  var response;
  String? _base64;

  String? companyId = getIt<SharedPreferences>().getString('companyId');

  _AadhaarCardState(data) {
    response = data['data'];
    imageUrl = response != null ? response : "";
    var url = response.toString();
    print("URL1 --->$url");
    print('Constructor Data1 ------> $data');
  }
  int onPressed = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      File imageFile = File(imageUrl.toString());
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
          height: maxHeight,
          decoration: const BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          child: SingleChildScrollView(
            child: Column(children: [
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
                        "Aadhaar Details",
                        style: TextStyles.leadingText,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: h1p * 3,
              ),
              Row(
                children: [
                  InkWell(
                      //  onTap: () => ({

                      //  }),
                      onTap: () async {
                        FilePickerResult? fileResult = (await FilePicker
                            .platform
                            .pickFiles(allowMultiple: false));
                        String? path = fileResult != null
                            ? fileResult.files.isNotEmpty
                                ? fileResult.files[0].path
                                : ""
                            : "";
                        final File selectFront = File(path as String);
                        // print(selectFront.readAsBytesSync());

                        setState(() {
                          this.frontImage = selectFront;
                        });
                        print("front img........$path");
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: w1p * 6, right: w1p * 6, top: h1p * 1),
                        child: Container(
                            height: h1p * 6,
                            width: w10p * 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colours.disabledText,
                            ),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 2, vertical: h1p * 2),
                                child: Row(children: [
                                  InkWell(
                                    onTap: () async {
                                      // File? file = File("");
                                      // String filePath = "";
                                      XFile? fileResult = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      String? path = fileResult != null
                                          ? fileResult.path.isNotEmpty
                                              ? fileResult.path
                                              : ""
                                          : "";

                                      final File selectFront =
                                          File(path as String);
                                      setState(() {
                                        this.frontImage = selectFront;
                                      });
                                    },
                                    child: Container(
                                      child: Center(
                                        child: SvgPicture.asset(
                                            "assets/images/kycImages/camera.svg",
                                            height: h1p * 4),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Upload Front Image',
                                    style: TextStyles.textStyle121,
                                  ),
                                ]))),
                      )),
                  InkWell(
                      onTap: () async {
                        FilePickerResult? fileResult = (await FilePicker
                            .platform
                            .pickFiles(allowMultiple: false));
                        String? path = fileResult != null
                            ? fileResult.files.isNotEmpty
                                ? fileResult.files[0].path
                                : ""
                            : "";
                        final File selectBack = File(path as String);
                        setState(() {
                          this.backImage = selectBack;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: w1p * 2, right: w1p * 5, top: h1p * 1),
                        child: Container(
                          height: h1p * 6,
                          width: w10p * 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colours.disabledText,
                          ),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w1p * 2, vertical: h1p * 2),
                              child: Row(children: [
                                InkWell(
                                  onTap: () async {
                                    XFile? fileResult = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    String? path = fileResult != null
                                        ? fileResult.path.isNotEmpty
                                            ? fileResult.path
                                            : ""
                                        : "";
                                    final File selectBack =
                                        File(path as String);
                                    setState(() {
                                      this.backImage = selectBack;
                                    });
                                  },
                                  child: Container(
                                    child: SvgPicture.asset(
                                      "assets/images/kycImages/camera.svg",
                                      height: h1p * 4,
                                    ),
                                  ),
                                ),
                                // ),
                                Text(
                                  'Upload Back Image',
                                  style: TextStyles.textStyle121,
                                ),
                              ])),
                        ),
                      )),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: w1p * 6, right: w1p * 6, top: h1p * 1),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: TextButton(
                        onPressed: () async {
                          Map<String, dynamic> aadhaar =
                              await getIt<KycManager>().adhaarDetails(
                                  companyId, frontImage, backImage);
                          if (aadhaar['error'] == false) {
                            ///
                            isCaptured = true;
                          }
                          setState(() {
                            this.onPressed == 1;
                          });
                          String adharmsg = aadhaar.toString();
                          String adhaarmsg = adharmsg.substring(4);

                          Fluttertoast.showToast(
                              msg: adhaarmsg,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor:
                                  Color.fromARGB(255, 253, 153, 33),
                              textColor: Colors.white,
                              fontSize: 12.0);
                        },
                        child: Text(
                          'CAPTURED',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 253, 153, 33),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 150, 146, 146),
                              ),
                            ))),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: maxWidth * 0.1,
                  ),
                  onPressed == 1
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: w1p * 0.03, right: w1p * 1, top: h1p * 1),
                          child: adhaarDetails(),
                        )
                      : const SizedBox()
                ],
              ),

              Padding(
                padding: EdgeInsets.only(
                    left: w1p * 6, right: w1p * 6, top: h1p * 3),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: maxWidth * 0.45,
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
                        controller: aadhaarController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: w1p * 6, vertical: h1p * .5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: Colours.paleGrey,
                          hintText: "Aadhaar Number",
                          hintStyle: TextStyles.textStyle120,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: maxHeight * 0.03,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: w1p * 6, right: w1p * 6, top: h1p * 1),
                    child: Row(
                      children: [
                        (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image(
                                image: Image.memory(Base64Decoder()
                                        .convert(imageUrl.split(",").last))
                                    .image)
                            : SizedBox(),
                        InkWell(
                            onTap: () async {
                              setState(() {});
                              var data = await getIt<KycManager>().getCaptcha();
                              response = data['data'];
                              imageUrl = response != null ? response : "";
                              setState(() {});
                            },
                            child: Icon(Icons.refresh)),
                      ],
                    ),
                  ),

                  // Image.network('https://picsum.photos/250?image=9'),
                  Padding(
                    padding: EdgeInsets.only(
                        left: w1p * 0.03, right: w1p * 2, top: h1p * 1),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: maxWidth * 0.4,
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
                            controller: reCaptchaController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: w1p * 6, vertical: h1p * .5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colours.paleGrey,
                              hintText: "Enter Captcha*",
                              hintStyle: TextStyles.textStyle120,
                            )),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 7,
                // height: maxHeight * 0.03,
              ),
              //generate otp

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: w1p * 6, right: w1p * 6, top: h1p * 1),
                    child: Container(
                      height: maxHeight * 0.06,
                      child: TextButton(
                        onPressed: () async {
                          if (isCaptured) {
                            Map<String, dynamic> aadharOtp =
                                await getIt<KycManager>().generateAdharOtp(
                                    aadhaarController.text,
                                    reCaptchaController.text);
                            // AdhaarController.adhaarDetails(companyId, , back)
                            Fluttertoast.showToast(msg: aadharOtp['msg']);
                            // Navigator.pop(context);
                          } else {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //     behavior: SnackBarBehavior.floating,
                            //     content: Text(
                            //       "Please upload both front and back images and click on capture",
                            //       style: const TextStyle(color: Colors.green),
                            //     )));
                            Fluttertoast.showToast(
                                msg:
                                    "Please upload both front and back images and click on capture");
                          }
                        },
                        child: Text(
                          'Generate OTP',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 253, 153, 33),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 150, 146, 146),
                              ),
                            ))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: w1p * 0.03, right: w1p * 2, top: h1p * 1),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: maxWidth * 0.45,
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
                                  horizontal: w1p * 6, vertical: h1p * .01),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colours.paleGrey,
                              hintText: "Enter OTP",
                              hintStyle: TextStyles.textStyle120,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: maxHeight * 0.03,
              ),
              InkWell(
                  onTap: () async {
                    Map<String, dynamic> verifyAadharOtp =
                        await getIt<KycManager>().verifyAdharOtp(
                      otpController.text,
                    );

                    // AdhaarController.adhaarDetails(companyId, , back)
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //             behavior: SnackBarBehavior.floating,
                    //             content: Text(
                    //               verifyAadharOtp['msg'],
                    //               style: const TextStyle(color: Colors.green),
                    //             )));
                    Fluttertoast.showToast(msg: verifyAadharOtp['msg']);
                    if (verifyAadharOtp['error'] == false) {
                      Navigator.pop(context);
                    }
                  },
                  child: Submitbutton(
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    isKyc: true,
                    content: "Verify OTP",
                  )),
              Text('Verification Status:')
            ]),
          ),
        ),
      ));
    });
  }

  Widget adhaarDetails() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ABC',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
            ),
            Text(
              'Address: 102,kothrud,Pune',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
            ),
            Text(
              'DOB: 19/08/1991',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
            ),
            Text(
              'Gender: Male',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
            ),
          ],
        ),
      );
}
