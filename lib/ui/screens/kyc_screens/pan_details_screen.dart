import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../logic/view_models/kyc_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/document_uploading.dart';
import '../../widgets/kyc_widgets/submitt_button.dart';

class PanDetails extends StatefulWidget {
  const PanDetails({Key? key}) : super(key: key);

  @override
  State<PanDetails> createState() => _PanDetailsState();
}

class _PanDetailsState extends State<PanDetails> {
  TextEditingController panController = TextEditingController();

  List<File?>? panDetailsImages;

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
                              "PAN Details",
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
                            controller: panController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: w1p * 6, vertical: h1p * .5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colours.paleGrey,
                              hintText: "PAN Number",
                              hintStyle: TextStyles.textStyle120,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: h1p * 3,
                    ),
                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      onFileSelection: (files) {
                        panDetailsImages = files;
                        setState(() {});
                      },
                    ),
                    InkWell(
                        onTap: () async {
                          Map<String, dynamic> panDetails =
                              await getIt<KycManager>().storePanCardDetails(
                                  panController.text,
                                  filePath:
                                      panDetailsImages?.first?.path ?? "");
                          Fluttertoast.showToast(msg: panDetails['msg']);
                          //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //       behavior: SnackBarBehavior.floating,
                          //       content: Text(
                          //         panDetails['msg'],
                          //         style: const TextStyle(color: Colors.green),
                          //       )));
                          if (panDetails['error'] == false) {
                            Navigator.pop(context);
                          }
                        },
                        child: Submitbutton(
                          maxWidth: maxWidth,
                          maxHeight: maxHeight,
                          isKyc: true,
                          content: "Save & Continue",
                        ))
                  ]))));
    });
  }
}
