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
  const AadhaarCard({Key? key}) : super(key: key);

  @override
  State<AadhaarCard> createState() => _AadhaarCardState();
}

class _AadhaarCardState extends State<AadhaarCard> {
  TextEditingController aadhaarController = TextEditingController();
  late File frontImage;
  late File backImage;
  // late Future<List<Summary>> adhaarData;

// Future init() async {
//     final adhaar = await AdhaarController.adhaarDetails(companyId, front, back);
//     setState(() {
//       this.adhaar = docs;
//     });
//     // print(docs);
//     // print('createdby: ${this.createdBY}');
//   }
  String? companyId = getIt<SharedPreferences>().getString('companyId');

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
                      "Aadhaar Details",
                      style: TextStyles.leadingText,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: w1p * 6, right: w1p * 6, top: h1p * 3),
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
            SizedBox(
              height: h1p * 3,
            ),
            Row(
              children: [
                InkWell(
                    //  onTap: () => ({

                    //  }),
                    onTap: () async {
                      FilePickerResult? fileResult = (await FilePicker.platform
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

                      // Map<String, dynamic> frontimg =
                      //     await getIt<KycManager>().selectFile();
                      // this.frontImage = frontimg as File;

                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(
                      //         behavior: SnackBarBehavior.floating,
                      //         content: Text(
                      //           frontimg['msg'],
                      //           style: TextStyle(
                      //               color: frontimg['status'] == true
                      //                   ? Colors.green
                      //                   : Colors.red),
                      //         )));
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
                                        .pickImage(source: ImageSource.camera);
                                    String? path = fileResult != null
                                        ? fileResult.path.isNotEmpty
                                            ? fileResult.path
                                            : ""
                                        : "";
                                    // final selectFront = await ImagePicker()
                                    //     .pickImage(source: ImageSource.camera);
                                    final File selectFront =
                                        File(path as String);
                                    setState(() {
                                      this.frontImage = selectFront;
                                    });

// ScaffoldMessenger.of(context)
                                    //     .showSnackBar(SnackBar(
                                    //         behavior: SnackBarBehavior
                                    //             .floating,
                                    //         content: Text(
                                    //           frontimg['msg'],
                                    //           style: TextStyle(
                                    //               color: frontimg[
                                    //                           'status'] ==
                                    //                       true
                                    //                   ? Colors.green
                                    //                   : Colors.red),
                                    //         )));
                                  },
                                  child: Container(
                                    // height: h1p * 6,
                                    // width: w1p * 12,
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(6),
                                    //   color: Colours.disabledText,
                                    // ),
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
                              ]))
                          // DocumentUploading(
                          //   maxWidth: maxWidth,
                          //   maxHeight: maxHeight,
                          //   text: 'Upload front side',
                          // ),
                          // // InkWell(
                          // //   onTap: () async {
                          // //     await getIt<KycManager>()
                          // //         .storePanCardDetails(aadhaarController.text);
                          // //     Fluttertoast.showToast(msg: "successfully uploaded");
                          // //     Navigator.pop(context);
                          // //   },
                          // // ),
                          // DocumentUploading(
                          //   maxWidth: maxWidth,
                          //   maxHeight: maxHeight,
                          //   text: 'Upload back side',
                          // ),
                          ),
                    )),
                InkWell(
                    onTap: () async {
                      FilePickerResult? fileResult = (await FilePicker.platform
                          .pickFiles(allowMultiple: false));
                      String? path = fileResult != null
                          ? fileResult.files.isNotEmpty
                              ? fileResult.files[0].path
                              : ""
                          : "";
                      final File selectBack = File(path as String);
                      //print(selectBack.readAsBytesSync());
                      setState(() {
                        this.backImage = selectBack;
                      });

                      // if (selectBack != null) {
                      //   // filePath = basename(file!.path);

                      //   Map<String, dynamic> successMessage = {
                      //     'msg':
                      //         ' upload successfully ${fileResult.files[0].path}',
                      //     'status': true
                      //   };
                      // }
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
                                  // final selectFront = await ImagePicker()
                                  //     .pickImage(source: ImageSource.camera);
                                  final File selectBack = File(path as String);
                                  setState(() {
                                    this.backImage = selectBack;
                                  });

                                  // Map<String, dynamic> backimg =
                                  //     await getIt<KycManager>()
                                  //         .getImage();
                                  // this.backImage = backimg as File;

                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(SnackBar(
                                  //         behavior: SnackBarBehavior
                                  //             .floating,
                                  //         content: Text(
                                  //           backimg['msg'],
                                  //           style: TextStyle(
                                  //               color:
                                  //                   backimg['status'] ==
                                  //                           true
                                  //                       ? Colors.green
                                  //                       : Colors.red),
                                  //         )));
                                },
                                child: Container(
                                  // height: h1p * 6,
                                  // width: w1p * 12,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(6),
                                  //   color: Colours.disabledText,
                                  // ),

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

                        // DocumentUploading(
                        //   maxWidth: maxWidth,
                        //   maxHeight: maxHeight,
                        //   text: 'Upload front side',
                        // ),
                        // // InkWell(1
                        // //   onTap: () async {
                        // //     await getIt<KycManager>()
                        // //         .storePanCardDetails(aadhaarController.text);
                        // //     Fluttertoast.showToast(msg: "successfully uploaded");
                        // //     Navigator.pop(context);
                        // //   },
                        // // ),
                        // DocumentUploading(
                        //   maxWidth: maxWidth,
                        //   maxHeight: maxHeight,
                        //   text: 'Upload back side',
                        // ),
                      ),
                    )),
              ],
            ),
            // Row(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(
            //           left: w1p * 6, right: w1p * 6, top: h1p * 3),
            //       // child: Align(
            //       //     alignment: Alignment.topLeft,
            //       //     child:
            TextButton(
              onPressed: () async {
                Map<String, dynamic> aadhaar = await getIt<KycController>()
                    .adhaarDetails(companyId, frontImage, backImage);
                // adhaarData = AdhaarController.adhaarDetails(
                //     companyId, frontImage, backImage);

                // print('this.img......$frontImage');
                // print('this.img .....$backImage');
                String adharmsg = aadhaar.toString();
                String adhaarmsg = adharmsg.substring(4);

                Fluttertoast.showToast(
                    msg: adhaarmsg,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Color.fromARGB(255, 253, 153, 33),
                    textColor: Colors.white,
                    fontSize: 12.0);

                // setState(() {
                //    aadhaar as Future<List<Summary>>;
                // });

                // String url =
                //     'https://dev.xuriti.app/api/kyc/document-verify/aadhaar';
                // final uri = Uri.parse(url);

                // await getIt<KycManager>().storeAadhaarProof(
                //     aadhaarController.text);
                // final response = await http.post(uri,
                // headers: {
                //   'Content-Type':
                //       'application/json; charset=UTF-8',
                // },
                // body: jsonEncode(<String, dynamic>{
                //   'companyId': companyId,
                //   'front':
                //   'back': backImage,
                // }
                // )

                // final summary = Summary.fromJson(
                //     json.decode(response.body));
                // final data =
                //     Data.fromJson(json.decode(response.body));
                // AdhaarController.adhaarDetails(companyId,
                //     this.frontImage, this.backImage);
                // Widget asgd() => getAdhaar(
                //     name: summary.name,
                //     address: summary.address,
                //     uid: summary.gender,
                //     dob: summary.dateOfBirth);
                // if (response.statusCode == 200) {
                // final List adhaarDetails =json
                //                   .decode(response.body);

                // final String name = summary.name;

                // asgd();

                // Text('Captured Status: Captured');
                //     Fluttertoast.showToast(
                //         msg: "successfully uploaded");
                //     Navigator.pop(context);
                //   } else
                //     (Text('Captured status:Not Captured'));

                //   // final List adhaar = aDetails ;
                //   // if
              },
              child: Text(
                'CAPTURED',
                style: TextStyle(color: Colors.black),
              ),
              style: TextButton.styleFrom(side: BorderSide(color: Colors.grey)),
            ),
            InkWell(
                onTap: () async {
                  await getIt<KycManager>().storeAadhaarProof(
                    aadhaarController.text,
                  );
                  // AdhaarController.adhaarDetails(companyId, , back)
                  Fluttertoast.showToast(msg: "successfully uploaded");
                  Navigator.pop(context);
                },
                child: Submitbutton(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  isKyc: true,
                  content: "Save & Continue",
                ))
          ]),
        ),
        //     // Container(
        //     //   child: Column(
        //     //     children: [Text('name:')],
        //     //   ),
        //     // )
        //   ],
        // ),
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20)),
        //   // height: maxHeight,
        //   // width: maxWidth,
        //   child: TextField(
        //     decoration: const InputDecoration(
        //       border: OutlineInputBorder(
        //           borderRadius: BorderRadius.all(
        //         Radius.circular(30),
        //       )),
        //       labelText: 'UPI Number',
        //       // hintText: 'UPI Number',
        //     ),
        //   ),
        // ),
        // Container(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text('Aadhaar Number:'),
        //       Text(
        //         '24524523454534534',
        //         maxLines: 1,
        //       ),
        //       Text('Name:'),
        //       Text(
        //         'name for example',
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //       ),
        //       Text('Gender:'),
        //       Text('Female:'),
        //       Text('DOB:'),
        //       Text('1/04/99:'),
        //       Text('Address:'),
        //       Text(
        //         '405,102 street,aditya shagun mall,bavdhan,pune:',
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //         softWrap: false,
        //       ),
        //       Text('Captured Status:'),
        //       Text(
        //         'Captured:',
        //         maxLines: 1,
        //       ),
        //     ],
        //   ),
        // )
      ));
    });
  }
}
