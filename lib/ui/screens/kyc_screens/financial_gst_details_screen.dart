import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/logic/view_models/kyc_manager.dart';
import 'package:xuriti/ui/screens/kyc_screens/store_images.dart';
import 'package:xuriti/ui/widgets/kyc_widgets/previouslyUploadedDocuments.dart';
import 'package:xuriti/util/loaderWidget.dart';

import '../../../Model/KycDetails.dart';
import '../../../models/helper/service_locator.dart';
import '../../../models/services/dio_service.dart';
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
  var _formKey = GlobalKey<FormState>();

  List<File?>? financialImages;
  List<File?>? gstImages;

  bool? flag;

  List financefiles = [];
  List GSTfiles = [];

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
    Financial financedetails = Financial.fromJson(details['financial']);
    Gst GSTdetails = Gst.fromJson(details['gst']);
    setState(() {
      List<String> financefiles = financedetails.files;
      this.financefiles = financefiles;
      List<String> GSTfiles = GSTdetails.files;
      this.GSTfiles = GSTfiles;
    });
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
                          left: w1p * 6, right: w1p * 6, top: h1p * 1.5),
                      child: Text(
                        "Financial Details",
                        style: TextStyles.textStyle54,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: w1p * 6, vertical: h1p * 3),
                    //   child: Text(
                    //     "P & L",
                    //     style: TextStyles.textStyle123,
                    //   ),
                    // ),
                    PreviouslyUploadedDocuments(
                      constraints: constraints,
                      imgfiles: financefiles,
                      maxHeight: maxHeight,
                      maxWidth: maxWidth,
                      docHeadingName: 'finantial',
                    ),
                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      flag: true,
                      shouldPickFile: financialImages?.isEmpty ?? true,
                      onFileSelection: (filesObjects) {
                        if ((financialImages?.length ?? 0) == 0) {
                          financialImages = filesObjects;
                        } else if (((financialImages?.length ?? 0) +
                                (filesObjects?.length ?? 0)) <=
                            3) {
                          financialImages?.addAll(filesObjects!);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Selection limit for 3 images are accepted");
                        }

                        setState(() {});
                      },
                    ),
                    // DocumentUploading(
                    //   maxWidth: maxWidth,
                    //   maxHeight: maxHeight,
                    //   flag: true,
                    //   onFileSelection: (filesObject) {
                    //     financialImages = filesObject;
                    //     setState(() {});
                    //   },
                    //   //type: "Financial Details"
                    // ),
                    ((financialImages?.length ?? 0) != 0 &&
                            financialImages?.first != null)
                        ? Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1),
                                      child: Image.file(
                                        financialImages!.first!,
                                        fit: BoxFit.fill,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        height: 200,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                financialImages!.first!.path.split('/').last,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                // style: const TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : SizedBox(),
                    // getImagesWidget(
                    //     context: context, storeImages: financialImages),
                    // ((financialImages?.length ?? 0) != 0 &&
                    //         financialImages?.first != null)
                    //     ? Column(
                    //         children: [
                    //           SizedBox(
                    //             width: MediaQuery.of(context).size.width * 0.38,
                    //             height: 200,
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(5),
                    //               child: Center(
                    //                 child: ClipRRect(
                    //                   borderRadius: BorderRadius.circular(1),
                    //                   child: Image.file(
                    //                     financialImages!.first!,
                    //                     fit: BoxFit.fill,
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.38,
                    //                     height: 200,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           Text(
                    //             financialImages!.first!.path.split('/').last,
                    //             textAlign: TextAlign.center,
                    //             overflow: TextOverflow.ellipsis,
                    //             // style: const TextStyle(fontWeight: FontWeight.bold),
                    //           )
                    //         ],
                    //       )
                    //     : SizedBox(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w1p * 6, vertical: h1p * 3),
                      child: Text(
                        "GST Details",
                        style: TextStyles.textStyle54,
                      ),
                    ),

                    PreviouslyUploadedDocuments(
                      constraints: constraints,
                      imgfiles: GSTfiles,
                      maxHeight: maxHeight,
                      maxWidth: maxWidth,
                      docHeadingName: 'gst',
                    ),

                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      flag: true,
                      shouldPickFile: gstImages?.isEmpty ?? true,
                      onFileSelection: (files) {
                        gstImages = files;
                        setState(() {});
                      },
                    ),
                    // getImagesWidget(context: context, storeImages: gstImages),
                    ((gstImages?.length ?? 0) != 0 && gstImages?.first != null)
                        ? Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1),
                                      child: Image.file(
                                        gstImages!.first!,
                                        fit: BoxFit.fill,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        height: 200,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                gstImages!.first!.path.split('/').last,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                // style: const TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : SizedBox(),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: w1p * 6, vertical: h1p * 3),
                    //   child: Text(
                    //     "Balance Sheet",
                    //     style: TextStyles.textStyle123,
                    //   ),
                    // ),
                    // DocumentUploading(
                    //   maxWidth: maxWidth,
                    //   maxHeight: maxHeight,
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: w1p * 6, vertical: h1p * 3),
                    //   child: Text(
                    //     "Other Schedules",
                    //     style: TextStyles.textStyle123,
                    //   ),
                    // ),
                    // DocumentUploading(
                    //   maxWidth: maxWidth,
                    //   maxHeight: maxHeight,
                    // ),
                    InkWell(
                      onTap: () async {
                        context.showLoader();
                        //var img1 =
                        Map<String, dynamic> storeGstDetails =
                            await getIt<KycManager>().storeGstDetails(
                          filePath: financialImages
                                  ?.map((e) => e?.path ?? "")
                                  .toList() ??
                              [],
                          filePath1:
                              gstImages?.map((e) => e?.path ?? "").toList() ??
                                  [],
                        );
                        context.hideLoader();
                        // gstImage:
                        //     gstImages?.map((e) => e?.path ?? "").toList() ??
                        //         [],
                        // financialDetailsImage: financialImages
                        //         ?.map((e) => e?.path ?? "")
                        //         .toList() ??
                        //     []

                        Fluttertoast.showToast(msg: storeGstDetails['msg']);
                        if (storeGstDetails['error'] == false) {
                          Navigator.pop(context);
                        }
                      },
                      child: Submitbutton(
                        maxWidth: maxWidth,
                        maxHeight: maxHeight,
                        content: "Save & Continue",
                        isKyc: true,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       left: w1p * 6,
                    //       right: w1p * 7,
                    //       top: h1p * 5,
                    //       bottom: h1p * 2),
                    //   child: Text(
                    //     "GST Details",
                    //     style: TextStyles.textStyle54,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: w1p * 6, vertical: h1p * 2),
                    //   child: Text(
                    //     "GST Return Files",
                    //     style: TextStyles.textStyle123,
                    //   ),
                    // ),
                    // DocumentUploading(
                    //   maxWidth: maxWidth,
                    //   maxHeight: maxHeight,
                    // ),
                    // InkWell(
                    //   onTap: () async {
                    //     await getIt<KycManager>().storeGstDetails();
                    //     Fluttertoast.showToast(msg: "successfully uploaded");
                    //     Navigator.pop(context);
                    //   },
                    //   child: Submitbutton(
                    //     maxWidth: maxWidth,
                    //     maxHeight: maxHeight,
                    //     content: "Save & Continue",
                    //     isKyc: true,
                    //   ),
                    // )
                  ]))));
    });
  }
}

Widget imageDialog(path) {
  return Icon(Icons.edit_document);
}
