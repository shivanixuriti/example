import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/logic/view_models/kyc_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:xuriti/ui/widgets/kyc_widgets/previouslyUploadedDocuments.dart';
import 'package:xuriti/util/loaderWidget.dart';
import '../../../Model/KycDetails.dart';
import '../../../models/helper/service_locator.dart';
import '../../../models/services/dio_service.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/document_uploading.dart';
import '../../widgets/kyc_widgets/submitt_button.dart';

class StoreImages extends StatefulWidget {
  const StoreImages({Key? key}) : super(key: key);

  @override
  State<StoreImages> createState() => _StoreImagesState();
}

class _StoreImagesState extends State<StoreImages> {
  List<File?>? storeImages;
  final ImagePicker imgpicker = ImagePicker();
  List<File?>? imagefiles;
  // openImages() async {
  //   try {
  //     var pickedfiles = await imgpicker.pickMultiImage();
  //     //you can use ImageCourse.camera for Camera capture
  //     if (pickedfiles != null) {
  //       imagefiles = pickedfiles;
  //       setState(() {});
  //     } else {
  //       print("No image is selected.");
  //     }
  //   } catch (e) {
  //     print("error while picking file.");
  //   }
  // }

  //var _formKey = GlobalKey<FormState>();
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
    StoreImage Docdetails = StoreImage.fromJson(details['storeImages']);
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
                              "Store Images",
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
                        "NOTE: Please upload three images of the shop\n\n"
                        "1 - Store front photo along with store name from outside of the premises.\n\n"
                        "2 - Selfie of the registered owner along with inside area of the shop.\n\n"
                        "3 - Photo of current stock/inventory of inside the shop.\n\n",
                        style: TextStyles.textStyle123,
                      ),
                    ),
                    PreviouslyUploadedDocuments(
                      constraints: constraints,
                      imgfiles: imgfiles,
                      maxHeight: maxHeight,
                      maxWidth: maxWidth,
                      docHeadingName: 'store',
                    ),
                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      flag: true,
                      shouldPickFile: storeImages?.isEmpty ?? true,
                      onFileSelection: (filesObjects) {
                        if ((storeImages?.length ?? 0) == 0 &&
                            (filesObjects?.length ?? 0) <= 3) {
                          storeImages = filesObjects;
                        } else if (((storeImages?.length ?? 0) +
                                (filesObjects?.length ?? 0)) <=
                            3) {
                          storeImages?.addAll(filesObjects!);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Selection limit for 3 images are accepted");
                        }

                        // if ((storeImages?.length ?? 0) == 0 && ) {
                        //   storeImages = filesObjects;
                        // } else
                        // if (((storeImages?.length ?? 0) +
                        //         (filesObjects?.length ?? 0)) <=
                        //     3) {
                        //   storeImages?.addAll(filesObjects!);
                        // } else {
                        //   Fluttertoast.showToast(
                        //       msg: "Selection limit for 3 images are accepted");
                        // }

                        setState(() {});
                      },
                    ),

                    ///List separator
                    getImagesWidget(context: context, storeImages: storeImages),
                    InkWell(
                      onTap: () async {
                        context.showLoader();
                        Map<String, dynamic> storeImagesMap =
                            await getIt<KycManager>().storeImages(
                                filePath: storeImages
                                        ?.map((e) => e?.path ?? "")
                                        .toList() ??
                                    []);
                        context.hideLoader();
                        Fluttertoast.showToast(msg: storeImagesMap['msg']);
                        if (storeImagesMap['error'] == false) {
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

SizedBox getImagesWidget(
    {required BuildContext context, List<File?>? storeImages}) {
  return SizedBox(
    height: 220,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        shrinkWrap: true,
        itemCount: storeImages?.length ?? 0,
        itemBuilder: (contxt, index) {
          if (storeImages?[index]?.path.split('.').last != 'pdf') {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.38,
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: Image.file(
                          storeImages![index]!,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width * 0.38,
                          height: 190,
                        ),
                      ),
                    ),
                    Text(
                      storeImages[index]?.path.split('/').last ?? '',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      // style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox(
              width: 160,
              // height: 80,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: GestureDetector(
                          onTap: () {
                            OpenFile.open(storeImages![index]!
                                .path);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 1,
                              // right: w1p * 6
                            ),
                            child: Icon(Icons.picture_as_pdf, size: 80),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      storeImages?[index]?.path.split('/').last ?? '',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      // style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
  );
}

Widget imageDialog(path) {
  return Icon(Icons.edit_document);
}
