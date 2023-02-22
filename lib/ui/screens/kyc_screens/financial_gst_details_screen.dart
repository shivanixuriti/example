import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/logic/view_models/kyc_manager.dart';
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
                          itemCount: financefiles.length,
                          itemBuilder: (context, index) {
                            final doc = financefiles[index];

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
                              final file = File('${appStorage.path}/$name');
                              try {
                                final response = await Dio().get(url,
                                    options: Options(
                                        responseType: ResponseType.bytes,
                                        followRedirects: false,
                                        receiveTimeout: 0));
                                final raf = file.openSync(mode: FileMode.write);
                                raf.writeFromSync(response.data);
                                await raf.close();
                                return file;
                              } catch (e) {
                                return null;
                              }
                            }

                            Future openFile(
                                {required String url, String? filename}) async {
                              final file = await downloadFile(url, filename!);
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
                                    openFile(url: doc, filename: 'finance.pdf');
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
                      ),
                    ),

                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      flag: true,
                      onFileSelection: (filesObject) {
                        financialImages = filesObject;
                        setState(() {});
                      },
                      //type: "Financial Details"
                    ),
                    ((financialImages?.length ?? 0) != 0 &&
                            financialImages?.first != null)
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1),
                                  child: Image.file(
                                    financialImages!.first!,
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w1p * 6, vertical: h1p * 3),
                      child: Text(
                        "GST Details",
                        style: TextStyles.textStyle54,
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
                          itemCount: GSTfiles.length,
                          itemBuilder: (context, index) {
                            final doc = GSTfiles[index];

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
                              final file = File('${appStorage.path}/$name');
                              try {
                                final response = await Dio().get(url,
                                    options: Options(
                                        responseType: ResponseType.bytes,
                                        followRedirects: false,
                                        receiveTimeout: 0));
                                final raf = file.openSync(mode: FileMode.write);
                                raf.writeFromSync(response.data);
                                await raf.close();
                                return file;
                              } catch (e) {
                                return null;
                              }
                            }

                            Future openFile(
                                {required String url, String? filename}) async {
                              final file = await downloadFile(url, filename!);
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
                                    openFile(url: doc, filename: 'finance.pdf');
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
                      ),
                    ),

                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      flag: true,
                      onFileSelection: (files) {
                        gstImages = files;
                        setState(() {});
                      },
                    ),
                    ((gstImages?.length ?? 0) != 0 && gstImages?.first != null)
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1),
                                  child: Image.file(
                                    financialImages!.first!,
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
