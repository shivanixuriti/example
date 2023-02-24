import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/util/loaderWidget.dart';

import '../../../Model/KycDetails.dart';
import '../../../logic/view_models/kyc_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../../models/services/dio_service.dart';
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
  List imgfiles = [];
  var docType;
  final ScrollController savedDocController = ScrollController();

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
    Vintage Docdetails = Vintage.fromJson(details['vintage']);
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
                          )
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
                            value: "Business Vintage Proof",
                            groupValue: firm,
                            onChanged: (value) {
                              setState(() {
                                firm = value.toString();
                              });
                            },
                          ),
                          Text(
                            "Business Vintage Proof",
                            style: TextStyles.textStyle55,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: w1p * 6,
                          right: w1p * 6,
                          bottom: w1p * 6,
                          top: w1p * 3
                          // top: h1p * 1.5,
                          // bottom: h1p * 3
                          ),
                      child: imgfiles.isEmpty
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Uploaded Documents',
                                    style: TextStyles.leadingText,
                                  ),
                                  SizedBox(
                                    height: w1p,
                                  ),
                                  SizedBox(
                                    width: maxWidth,
                                    height: 65,
                                    child: Scrollbar(
                                      controller: savedDocController,
                                      thumbVisibility: true,
                                      child: ListView.separated(
                                        controller: savedDocController,
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          width: 8,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: imgfiles.length,
                                        itemBuilder: (context, index) {
                                          final doc = imgfiles[index];
                                          print(
                                              'the whole filepath  >>>>>>>>$doc');

                                          List doc1 = doc.split("?");
                                          List doc2 = doc1[0].split(".");
                                          List fpath = doc2;
                                          print('doc1.>>>>>>>>$doc1');
                                          String displayName =
                                              doc1[0].split("/").last;
                                          print('fpath.>>>>>>>>$fpath');
                                          final fp = doc2.last;
                                          String filepath = fp.toString();
                                          print(
                                              'filepath from vintage proof>>>>>>>>$filepath');

                                          Future<File?> downloadFile(
                                              String url, String name) async {
                                            final appStorage =
                                                await getApplicationDocumentsDirectory();
                                            final file = File(
                                                '${appStorage.path}/$name');
                                            try {
                                              final response = await Dio().get(
                                                  url,
                                                  options: Options(
                                                      responseType:
                                                          ResponseType.bytes,
                                                      followRedirects: false,
                                                      receiveTimeout: 0));
                                              final raf = file.openSync(
                                                  mode: FileMode.write);
                                              raf.writeFromSync(response.data);
                                              await raf.close();
                                              return file;
                                            } catch (e) {
                                              return null;
                                            }
                                          }

                                          Future openFile(
                                              {required String url,
                                              String? filename}) async {
                                            final file = await downloadFile(
                                                url, filename!);
                                            if (file == null) return;
                                            print(
                                                'path for pdf file++++++++++++ ${file.path}');
                                            OpenFile.open(file.path);
                                          }

                                          // filepath != 'pdf'
                                          //     ?
                                          if (filepath != 'pdf') {
                                            print('object++++====');
                                            return GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          child: SizedBox(
                                                            width: maxWidth * 5,
                                                            height:
                                                                maxHeight * 0.6,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text(
                                                                  displayName,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      maxHeight *
                                                                          0.5,
                                                                  child: Image
                                                                      .network(
                                                                    '$doc',
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: w1p * 1,
                                                    // right: w1p * 6
                                                  ),
                                                  child: SizedBox(
                                                    width: 70,
                                                    child: Column(
                                                      children: [
                                                        imageDialog(doc),
                                                        Text(
                                                          displayName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          } else {
                                            return GestureDetector(
                                                onTap: () {
                                                  openFile(
                                                      url: doc,
                                                      filename: 'vintage.pdf');
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: w1p * 1,
                                                    // right: w1p * 6
                                                  ),
                                                  child: SizedBox(
                                                    width: 70,
                                                    child: Column(
                                                      children: [
                                                        imageDialog(doc),
                                                        Text(
                                                          displayName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          }
                                        },
                                      ),
                                    ),
                                    //_checkController();
                                  ),
                                ],
                              ),
                            ),
                    ),
                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      shouldPickFile: vintageImages?.isEmpty ?? true,
                      onFileSelection: (files) {
                        vintageImages = files;
                        setState(() {});
                      },
                    ),
                    ((vintageImages?.length ?? 0) != 0 &&
                            vintageImages?.first != null)
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
                                          vintageImages!.first!,
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
                                  vintageImages!.first!.path.split('/').last,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  // style: const TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    InkWell(
                      onTap: () async {
                        context.showLoader();
                        Map<String, dynamic> storeVintageProof =
                            await getIt<KycManager>().storeVintageProof(
                                filePath: vintageImages?.first?.path ?? "");
                        context.hideLoader();
                        Fluttertoast.showToast(msg: storeVintageProof['msg']);
                        if (storeVintageProof['error'] == false) {
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
    ;
  }
}

Widget imageDialog(path) {
  return Icon(
    Icons.edit_document,
    size: 45,
  );
}
