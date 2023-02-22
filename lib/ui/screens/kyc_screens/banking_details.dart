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

class BankingDetails extends StatefulWidget {
  const BankingDetails({Key? key}) : super(key: key);

  @override
  State<BankingDetails> createState() => _BankingDetailsState();
}

class _BankingDetailsState extends State<BankingDetails> {
  var _formKey = GlobalKey<FormState>();

  List<File?>? bankDetailsImages;
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
    Banking Docdetails = Banking.fromJson(details['bankStatement']);
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
                              "Banking Details",
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
                        "Bank Statement (Last 6 Months)",
                        style: TextStyles.textStyle123,
                      ),
                    ),
                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      onFileSelection: (files) {
                        bankDetailsImages = files;
                        setState(() {});
                      },
                    ),
                    ((bankDetailsImages?.length ?? 0) != 0 &&
                            bankDetailsImages?.first != null)
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1),
                                  child: Image.file(
                                    bankDetailsImages!.first!,
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
                    SizedBox(
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
                            print('path for pdf file++++++++++++ ${file.path}');
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
                                  openFile(url: doc, filename: 'banking.pdf');
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
                    InkWell(
                      onTap: () async {
                        context.showLoader();
                        Map<String, dynamic> bankingDetails =
                            await getIt<KycManager>().storeBankDetails(
                                bankStatementImage:
                                    bankDetailsImages?.first?.path ?? "");
                        context.hideLoader();
                        Fluttertoast.showToast(msg: bankingDetails['msg']);
                        if (bankingDetails['error'] == false) {
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
  return Icon(Icons.edit_document);
}
