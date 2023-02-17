import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/KycDetails.dart';
import '../../../logic/view_models/kyc_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../../models/services/dio_service.dart';
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
  List panfiles = [];
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    dynamic companyId = getIt<SharedPreferences>().getString('companyId');

    //final docs = DioClient().KycDetails(companyId);
    dynamic responseData = await getIt<DioClient>().KycDetails(companyId);
    final details = responseData['data'];
    Pan pandetails = Pan.fromJson(details['pan']);
    setState(() {
      List<String> panfiles = pandetails.files;
      this.panfiles = panfiles;
    });
    print('panfiles...))))))))))))${panfiles[0].toString()}');
    print('the response data of kyc"""""""""$responseData');
    // setState(() {
    //   this.details = details;
    // });
    // List<String> panFiles = details[0].files;
    // print(
    //     'kyc details from kyc verification 1st screen ............${pandetails[0].files}');
  }

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
                    Padding(
                      padding: EdgeInsets.only(
                        left: w1p * 6,
                        right: w1p * 6,
                        // top: h1p * 1.5,
                        // bottom: h1p * 3
                      ),
                      child: SizedBox(
                        width: maxWidth,
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: panfiles.length,
                          itemBuilder: (context, index) {
                            final doc = panfiles[index];

                            return GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: SizedBox(
                                            width: 220,
                                            height: 60,
                                            child: Image.network(
                                              '$doc',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: imageDialog(doc));
                          },
                        ),
                        //_checkController();
                      ),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      onFileSelection: (files) {
                        panDetailsImages = files;
                        setState(() {});
                      },
                    ),
                    ((panDetailsImages?.length ?? 0) != 0 &&
                            panDetailsImages?.first != null)
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1),
                                  child: Image.file(
                                    panDetailsImages!.first!,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width *
                                        0.38,
                                    height: 200,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    //   ],
                    // ),
                    // ((panDetailsImages?.length ?? 0) != 0 &&
                    //         panDetailsImages?.first != null)
                    //     ? Expanded(
                    //         child: Column(children: [
                    //           SizedBox(
                    //             height: 50,
                    //           ),
                    //           Center(
                    //             child: SizedBox(
                    //               width:
                    //                   MediaQuery.of(context).size.width * 0.38,
                    //               height: 200,
                    //               child: Center(
                    //                 child: ClipRRect(
                    //                   borderRadius: BorderRadius.circular(1),
                    //                   child: Image.file(
                    //                     panDetailsImages!.first!,
                    //                     fit: BoxFit.cover,
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.38,
                    //                     height: 200,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ]),
                    //       )
                    //     : SizedBox(),
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

Widget imageDialog(path) {
  return Icon(Icons.edit_document);
}
