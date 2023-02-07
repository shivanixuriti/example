import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xuriti/ui/widgets/kyc_widgets/document_uploading.dart';

import '../../../logic/view_models/kyc_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/submitt_button.dart';

class OwnershipProof extends StatefulWidget {
  const OwnershipProof({Key? key}) : super(key: key);

  @override
  State<OwnershipProof> createState() => _OwnershipProofState();
}

class _OwnershipProofState extends State<OwnershipProof> {
  int currentIndex = 0;
  String? doc;
  List<File?>? ownershipImages;

  var _formKey = GlobalKey<FormState>();
  TextEditingController documentController = TextEditingController();

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
                              "Ownership Proof",
                              style: TextStyles.leadingText,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: w1p * 6,
                          right: w1p * 6,
                          // bottom: h1p * 3,
                          top: h1p * 1),
                      child: Text(
                        "Document Type",
                        style: TextStyles.textStyle122,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Radio(
                                  value: "Property Ownership Document",
                                  groupValue: doc,
                                  onChanged: (value) {
                                    setState(() {
                                      doc = value.toString();
                                    });
                                  },
                                ),
                                Text(
                                  "Property Ownership Document",
                                  style: TextStyles.textStyle55,
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                Radio(
                                  value: "Electricity Bill",
                                  groupValue: doc,
                                  onChanged: (value) {
                                    setState(() {
                                      doc = value.toString();
                                    });
                                  },
                                ),
                                Text(
                                  "Electricity Bill",
                                  style: TextStyles.textStyle55,
                                ),
                              ],
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
                                controller: documentController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: w1p * 6, vertical: h1p * .5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fillColor: Colours.paleGrey,
                                  hintText: "Document Number",
                                  hintStyle: TextStyles.textStyle120,
                                ),
                                validator: (value1) {
                                  if (value1 == null || value1.isEmpty) {
                                    return 'Enter Valid Number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: h1p * 3,
                          ),
                          DocumentUploading(
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            onFileSelection: (files) {
                              ownershipImages = files;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await getIt<KycManager>().storeOwnershipProof(
                            documentController.text, doc!,
                            filePath: ownershipImages?.first?.path ?? "");

                        if (_formKey.currentState!.validate()) {
                          Fluttertoast.showToast(msg: "successfully uploaded");
                          Navigator.pop(context);
                        }
                        // Fluttertoast.showToast(msg: "successfully uploaded");
                        // Navigator.pop(context);
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
  }
}
