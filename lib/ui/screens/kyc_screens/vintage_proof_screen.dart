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

class VintageProof extends StatefulWidget {
  const VintageProof({Key? key}) : super(key: key);

  @override
  State<VintageProof> createState() => _VintageProofState();
}

class _VintageProofState extends State<VintageProof> {
  List<File?>? vintageImages;
  String? firm;
  var _formKey = GlobalKey<FormState>();
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w1p * 3, vertical: h1p * 3),
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                  "assets/images/arrowLeft.svg")),
                          SizedBox(
                            width: w10p * .3,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Vintage Proof",
                              style: TextStyles.leadingText,
                            ),
                          ),
                          SizedBox(
                            width: w10p * 5.5,
                          ),
                          SvgPicture.asset(
                              "assets/images/kycImages/submitted.svg")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: w1p * 6,
                          right: w1p * 6,
                          top: h1p * 1.5,
                          bottom: h1p * 1),
                      child: Text(
                        "If business & residence is rented then any business proof showing existence of business for 3 years ",
                        style: TextStyles.textStyle123,
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Radio(
                            value: "My business & residence is not rented",
                            groupValue: firm,
                            onChanged: (value) {
                              setState(() {
                                firm = value.toString();
                              });
                            },
                          ),
                          Text(
                            "My business & residence is not rented",
                            style: TextStyles.textStyle55,
                          ),
                        ],
                      ),
                    ),
                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      onFileSelection: (files) {
                        vintageImages = files;
                        setState(() {});
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        await getIt<KycManager>().storeVintageProof(
                            filePath: vintageImages?.first?.path ?? "");
                        Fluttertoast.showToast(msg: "successfully uploaded");
                        Navigator.pop(context);
                      },
                      child: Submitbutton(
                        maxWidth: maxWidth,
                        maxHeight: maxHeight,
                        content: "Save & Continue",
                        isKyc: true,
                      ),
                    )
                  ]))));
    });
    ;
  }
}
