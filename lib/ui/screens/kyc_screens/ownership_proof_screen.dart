import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/ui/widgets/kyc_widgets/document_uploading.dart';
import 'package:xuriti/util/loaderWidget.dart';

import '../../../Model/KycDetails.dart';
import '../../../logic/view_models/kyc_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../../models/services/dio_service.dart';
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
    Business Docdetails = Business.fromJson(details['ownership']);
    setState(() {
      List<String> imgfiles = Docdetails.files;
      this.imgfiles = imgfiles;
    });
    print('business files...))))))))))))${imgfiles[0].toString()}');
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
                          Padding(
                            padding: EdgeInsets.only(
                              left: w1p * 6,
                              right: w1p * 6,
                            ),
                            child: SizedBox(
                              width: maxWidth,
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imgfiles.length,
                                itemBuilder: (context, index) {
                                  final doc = imgfiles[index];

                                  return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                child: Container(
                                                  width: 220,
                                                  height: 200,
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
                          Padding(
                            padding: EdgeInsets.only(
                              left: w1p * 6,
                              right: w1p * 6,
                            ),
                            child: SizedBox(
                              width: maxWidth,
                              height: 50,
                              child: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  width: 30,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: imgfiles.length,
                                itemBuilder: (context, index) {
                                  final doc = imgfiles[index];

                                  print('the whole filepath  >>>>>>>>$doc');

                                  List doc1 = doc.split("?");
                                  List doc2 = doc1[0].split(".");
                                  List fpath = doc2;
                                  print('doc1.>>>>>>>>$doc1');

                                  print('fpath.>>>>>>>>$fpath');
                                  final fp = doc2.last;
                                  String filepath = fp.toString();
                                  print('filepath.>>>>>>>>$filepath');

                                  Future<File?> downloadFile(
                                      String url, String name) async {
                                    final appStorage =
                                        await getApplicationDocumentsDirectory();
                                    final file =
                                        File('${appStorage.path}/$name');
                                    try {
                                      final response = await Dio().get(url,
                                          options: Options(
                                              responseType: ResponseType.bytes,
                                              followRedirects: false,
                                              receiveTimeout: 0));
                                      final raf =
                                          file.openSync(mode: FileMode.write);
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
                                    final file =
                                        await downloadFile(url, filename!);
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
                                                    height: maxHeight * 0.5,
                                                    child: Image.network(
                                                      // ignore: unnecessary_string_interpolations
                                                      '$doc',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: w1p * 6, right: w1p * 6),
                                          child: imageDialog(doc),
                                        ));
                                  } else {
                                    return GestureDetector(
                                        onTap: () {
                                          openFile(
                                              url: doc,
                                              filename: 'ownership.pdf');
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: w1p * 6,
                                            // right: w1p * 6,
                                          ),
                                          child: imageDialog(doc),
                                        ));
                                  }
                                },
                              ),
                              //_checkController();
                            ),
                          ),
                          DocumentUploading(
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            onFileSelection: (files) {
                              ownershipImages = files;
                              setState(() {});
                            },
                          ),
                          ((ownershipImages?.length ?? 0) != 0 &&
                                  ownershipImages?.first != null)
                              ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.38,
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(1),
                                        child: Image.file(
                                          ownershipImages!.first!,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.38,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        context.showLoader();
                        Map<String, dynamic> kyc = await getIt<KycManager>()
                            .storeOwnershipProof(documentController.text, doc,
                                filePath: ownershipImages?.first?.path ?? "");
                        context.hideLoader();

                        if (_formKey.currentState!.validate() &&
                            kyc['error'] == false) {
                          Fluttertoast.showToast(msg: "successfully uploaded");
                          Navigator.pop(context);
                        }
                        // Fluttertoast.showToast(msg: "successfully uploaded");
                        Fluttertoast.showToast(msg: kyc['msg']);
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

Widget imageDialog(path) {
  return Icon(Icons.edit_document);
}
