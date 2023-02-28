import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/ui/screens/kyc_screens/store_images.dart';
import 'package:xuriti/ui/widgets/kyc_widgets/previouslyUploadedDocuments.dart';
import 'package:xuriti/util/loaderWidget.dart';

import '../../../Model/KycDetails.dart';
import '../../../logic/view_models/kyc_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../../models/services/dio_service.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/document_uploading.dart';
import '../../widgets/kyc_widgets/submitt_button.dart';

class FirmDetails extends StatefulWidget {
  const FirmDetails({Key? key}) : super(key: key);

  @override
  State<FirmDetails> createState() => _FirmDetailsState();
}

class _FirmDetailsState extends State<FirmDetails> {
  var _formKey = GlobalKey<FormState>();
  final ScrollController savedDocController = ScrollController();

  List<File?>? firmDetails;
  List imgfiles = [];
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
    Partnership Docdetails = Partnership.fromJson(details['partnership']);
    setState(() {
      List<String> imgfiles = Docdetails.files;
      this.imgfiles = imgfiles;
    });
    print('business files...))))))))))))${imgfiles[0].toString()}');
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
                              "Firm/Partnership Details",
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
                          top: h1p * 1.5,
                          bottom: h1p * 3),
                      child: Text(
                        "Partnership Deed/MOA and AOA, List of share holders and directors (including their PAN) as applicable",
                        style: TextStyles.textStyle123,
                      ),
                    ),
                    PreviouslyUploadedDocuments(
                      constraints: constraints,
                      imgfiles: imgfiles,
                      maxHeight: maxHeight,
                      maxWidth: maxWidth,
                    ),
                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      shouldPickFile: firmDetails?.isEmpty ?? true,
                      onFileSelection: (files) {
                        firmDetails = files;
                        setState(() {});
                      },
                    ),
                    ((firmDetails?.length ?? 0) != 0 &&
                            firmDetails?.first != null)
                        ? Padding(
                            padding: EdgeInsets.only(top: w1p * 3),
                            child: Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.38,
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(1),
                                        child: Image.file(
                                          firmDetails!.first!,
                                          fit: BoxFit.fill,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.38,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  firmDetails!.first!.path.split('/').last,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  // style: const TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    // getImagesWidget(context: context, storeImages: firmDetails),
                    InkWell(
                      onTap: () async {
                        context.showLoader();
                        Map<String, dynamic> storeFirmDetails =
                            await getIt<KycManager>().storeFirmDetails(
                                filePath: firmDetails?.first?.path ?? "");
                        context.hideLoader();
                        Fluttertoast.showToast(msg: storeFirmDetails['msg']);
                        if (storeFirmDetails['error'] == false) {
                          Navigator.pop(context);
                        }
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

Widget imageDialog(path) {
  return Icon(
    Icons.edit_document,
    size: 45,
  );
}
