import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/ui/screens/kyc_screens/store_images.dart';
import 'package:xuriti/util/loaderWidget.dart';

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
  var panNo;
  bool isPanNoCorrect = true;
  final panNumberRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

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
    var panNo = pandetails.number;
    setState(() {
      List<String> panfiles = pandetails.files;
      this.panfiles = panfiles;
      this.panNo = panNo;
    });
    panController.text = '${panNo}';
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
                            onChanged: (value) {
                              // documentNoController.clear();
                              value = panController.text;
                              setState(() {
                                isPanNoCorrect =
                                    panNumberRegex.hasMatch(panController.text);
                              });
                            },
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
                    Padding(
                      padding: EdgeInsets.only(
                        left: w1p * 6,
                        right: w1p * 6,
                      ),
                      child: isPanNoCorrect
                          ? Container()
                          : Text('Please enter valid PAN No',
                              style: TextStyle(color: Colors.redAccent)),
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
                        child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            width: 30,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: panfiles.length,
                          itemBuilder: (context, index) {
                            final doc = panfiles[index];

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
                                              width: maxWidth * 1,
                                              height: maxHeight * 0.5,
                                              child: Image.network(
                                                // ignore: unnecessary_string_interpolations
                                                '$doc',
                                                fit: BoxFit.fill,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colours.tangerine,
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
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
                                    openFile(url: doc, filename: 'pancard.pdf');
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

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    DocumentUploading(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      shouldPickFile: panDetailsImages?.isEmpty ?? true,
                      onFileSelection: (files) {
                        panDetailsImages = files;
                        setState(() {});
                      },
                    ),
                    // getImagesWidget(
                    //     context: context, storeImages: panDetailsImages),
                    ((panDetailsImages?.length ?? 0) != 0 &&
                            panDetailsImages?.first != null)
                        ? Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(1),
                                        child: Image.file(
                                          panDetailsImages!.first!,
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
                                  panDetailsImages!.first!.path.split('/').last,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  // style: const TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
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
                          context.showLoader();
                          Map<String, dynamic> panDetails =
                              await getIt<KycManager>().storePanCardDetails(
                                  panController.text,
                                  filePath:
                                      panDetailsImages?.first?.path ?? "");
                          context.hideLoader();
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



// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:xuriti/ui/screens/kyc_screens/store_images.dart';
// import 'package:xuriti/util/loaderWidget.dart';

// import '../../../Model/KycDetails.dart';
// import '../../../logic/view_models/kyc_manager.dart';
// import '../../../models/helper/service_locator.dart';
// import '../../../models/services/dio_service.dart';
// import '../../theme/constants.dart';
// import '../../widgets/appbar/app_bar_widget.dart';
// import '../../widgets/kyc_widgets/document_uploading.dart';
// import '../../widgets/kyc_widgets/submitt_button.dart';

// class PanDetails extends StatefulWidget {
//   const PanDetails({Key? key}) : super(key: key);

//   @override
//   State<PanDetails> createState() => _PanDetailsState();
// }

// class _PanDetailsState extends State<PanDetails> {
//   TextEditingController panController = TextEditingController();

//   List<File?>? panDetailsImages;
//   List panfiles = [];
//   var panNo;
//   bool isPanNoCorrect = true;
//   final panNumberRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

//   @override
//   void initState() {
//     init();
//     super.initState();
//   }

//   Future init() async {
//     dynamic companyId = getIt<SharedPreferences>().getString('companyId');

//     //final docs = DioClient().KycDetails(companyId);
//     dynamic responseData = await getIt<DioClient>().KycDetails(companyId);
//     final details = responseData['data'];
//     Pan pandetails = Pan.fromJson(details['pan']);
//     var panNo = pandetails.number;
//     setState(() {
//       List<String> panfiles = pandetails.files;
//       this.panfiles = panfiles;
//       this.panNo = panNo;
//     });
//     panController.text = '${panNo}';
//     print('panfiles...))))))))))))${panfiles[0].toString()}');
//     print('the response data of kyc"""""""""$responseData');
//     // setState(() {
//     //   this.details = details;
//     // });
//     // List<String> panFiles = details[0].files;
//     // print(
//     //     'kyc details from kyc verification 1st screen ............${pandetails[0].files}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       double maxHeight = constraints.maxHeight;
//       double maxWidth = constraints.maxWidth;
//       double h1p = maxHeight * 0.01;
//       double h10p = maxHeight * 0.1;
//       double w10p = maxWidth * 0.1;
//       double w1p = maxWidth * 0.01;
//       return SafeArea(
//           child: Scaffold(
//               backgroundColor: Colours.black,
//               appBar: AppBar(
//                   elevation: 0,
//                   automaticallyImplyLeading: false,
//                   toolbarHeight: h10p * .9,
//                   flexibleSpace: AppbarWidget()),
//               body: Container(
//                   width: maxWidth,
//                   decoration: const BoxDecoration(
//                       color: Colours.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       )),
//                   child: ListView(children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: w1p * 3, vertical: h1p * 3),
//                         child: Row(
//                           children: [
//                             SvgPicture.asset("assets/images/arrowLeft.svg"),
//                             SizedBox(
//                               width: w10p * .3,
//                             ),
//                             const Text(
//                               "PAN Details",
//                               style: TextStyles.leadingText,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: w1p * 6, right: w1p * 6, top: h1p * 3),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Color(0x26000000),
//                                 offset: Offset(0, 1),
//                                 blurRadius: 1,
//                                 spreadRadius: 0)
//                           ],
//                           color: Colours.paleGrey,
//                         ),
//                         child: TextFormField(
//                             controller: panController,
//                             onChanged: (value) {
//                               // documentNoController.clear();
//                               value = panController.text;
//                               setState(() {
//                                 isPanNoCorrect =
//                                     panNumberRegex.hasMatch(panController.text);
//                               });
//                             },
//                             decoration: InputDecoration(
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: w1p * 6, vertical: h1p * .5),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               fillColor: Colours.paleGrey,
//                               hintText: "PAN Number",
//                               hintStyle: TextStyles.textStyle120,
//                             )),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: w1p * 6,
//                         right: w1p * 6,
//                       ),
//                       child: isPanNoCorrect
//                           ? Container()
//                           : Text('Please enter valid PAN No',
//                               style: TextStyle(color: Colors.redAccent)),
//                     ),
//                     SizedBox(
//                       height: h1p * 3,
//                     ),

//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: w1p * 6,
//                         right: w1p * 6,
//                         // top: h1p * 1.5,
//                         // bottom: h1p * 3
//                       ),
//                       child: SizedBox(
//                         width: maxWidth,
//                         height: 50,
//                         child: ListView.separated(
//                           separatorBuilder: (context, index) => SizedBox(
//                             width: 30,
//                           ),
//                           scrollDirection: Axis.horizontal,
//                           itemCount: panfiles.length,
//                           itemBuilder: (context, index) {
//                             final doc = panfiles[index];

//                             print('the whole filepath  >>>>>>>>$doc');

//                             List doc1 = doc.split("?");
//                             List doc2 = doc1[0].split(".");
//                             List fpath = doc2;
//                             print('doc1.>>>>>>>>$doc1');

//                             print('fpath.>>>>>>>>$fpath');
//                             final fp = doc2.last;
//                             String filepath = fp.toString();
//                             print('filepath.>>>>>>>>$filepath');

//                             Future<File?> downloadFile(
//                                 String url, String name) async {
//                               final appStorage =
//                                   await getApplicationDocumentsDirectory();
//                               final file = File('${appStorage.path}/$name');
//                               try {
//                                 final response = await Dio().get(url,
//                                     options: Options(
//                                         responseType: ResponseType.bytes,
//                                         followRedirects: false,
//                                         receiveTimeout: 0));
//                                 final raf = file.openSync(mode: FileMode.write);
//                                 raf.writeFromSync(response.data);
//                                 await raf.close();
//                                 return file;
//                               } catch (e) {
//                                 return null;
//                               }
//                             }

//                             Future openFile(
//                                 {required String url, String? filename}) async {
//                               final file = await downloadFile(url, filename!);
//                               if (file == null) return;
//                               print(
//                                   'path for pdf file++++++++++++ ${file.path}');
//                               OpenFile.open(file.path);
//                             }

//                             // filepath != 'pdf'
//                             //     ?
//                             if (filepath != 'pdf') {
//                               print('object++++====');
//                               return GestureDetector(
//                                   onTap: () {
//                                     showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           return Dialog(
//                                             child: SizedBox(
//                                               width: maxWidth * 1,
//                                               height: maxHeight * 0.5,
//                                               child: Image.network(
//                                                 // ignore: unnecessary_string_interpolations
//                                                 '$doc',
//                                                 fit: BoxFit.fill,
//                                                 loadingBuilder: (context, child,
//                                                     loadingProgress) {
//                                                   if (loadingProgress == null)
//                                                     return child;
//                                                   return Center(
//                                                     child:
//                                                         CircularProgressIndicator(
//                                                       color: Colours.tangerine,
//                                                       value: loadingProgress
//                                                                   .expectedTotalBytes !=
//                                                               null
//                                                           ? loadingProgress
//                                                                   .cumulativeBytesLoaded /
//                                                               loadingProgress
//                                                                   .expectedTotalBytes!
//                                                           : null,
//                                                     ),
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           );
//                                         });
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                         left: w1p * 6, right: w1p * 6),
//                                     child: imageDialog(doc),
//                                   ));
//                             } else {
//                               return GestureDetector(
//                                   onTap: () {
//                                     openFile(url: doc, filename: 'pancard.pdf');
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                       left: w1p * 6,
//                                       // right: w1p * 6,
//                                     ),
//                                     child: imageDialog(doc),
//                                   ));
//                             }
//                           },
//                         ),
//                         //_checkController();
//                       ),
//                     ),

//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.start,
//                     //   children: [
//                     DocumentUploading(
//                       maxWidth: maxWidth,
//                       maxHeight: maxHeight,
//                       shouldPickFile: panDetailsImages?.isEmpty ?? true,
//                       onFileSelection: (files) {
//                         panDetailsImages = files;
//                         setState(() {});
//                       },
//                     ),
//                     // getImagesWidget(
//                     //     context: context, storeImages: panDetailsImages),
//                     ((panDetailsImages?.length ?? 0) != 0 &&
//                             panDetailsImages?.first != null)
//                         ? Expanded(
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 30,
//                                 ),
//                                 SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.32,
//                                   height: 200,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(5),
//                                     child: Center(
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(1),
//                                         child: Image.file(
//                                           panDetailsImages!.first!,
//                                           fit: BoxFit.fill,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.38,
//                                           height: 200,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   panDetailsImages!.first!.path.split('/').last,
//                                   textAlign: TextAlign.center,
//                                   overflow: TextOverflow.ellipsis,
//                                   // style: const TextStyle(fontWeight: FontWeight.bold),
//                                 )
//                               ],
//                             ),
//                           )
//                         : SizedBox(),

//                     //   ],
//                     // ),
//                     // ((panDetailsImages?.length ?? 0) != 0 &&
//                     //         panDetailsImages?.first != null)
//                     //     ? Expanded(
//                     //         child: Column(children: [
//                     //           SizedBox(
//                     //             height: 50,
//                     //           ),
//                     //           Center(
//                     //             child: SizedBox(
//                     //               width:
//                     //                   MediaQuery.of(context).size.width * 0.38,
//                     //               height: 200,
//                     //               child: Center(
//                     //                 child: ClipRRect(
//                     //                   borderRadius: BorderRadius.circular(1),
//                     //                   child: Image.file(
//                     //                     panDetailsImages!.first!,
//                     //                     fit: BoxFit.cover,
//                     //                     width:
//                     //                         MediaQuery.of(context).size.width *
//                     //                             0.38,
//                     //                     height: 200,
//                     //                   ),
//                     //                 ),
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         ]),
//                     //       )
//                     //     : SizedBox(),
//                     InkWell(
//                         onTap: () async {
//                           context.showLoader();
//                           Map<String, dynamic> panDetails =
//                               await getIt<KycManager>().storePanCardDetails(
//                                   panController.text,
//                                   filePath:
//                                       panDetailsImages?.first?.path ?? "");
//                           context.hideLoader();
//                           Fluttertoast.showToast(msg: panDetails['msg']);
//                           //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           //       behavior: SnackBarBehavior.floating,
//                           //       content: Text(
//                           //         panDetails['msg'],
//                           //         style: const TextStyle(color: Colors.green),
//                           //       )));
//                           if (panDetails['error'] == false) {
//                             Navigator.pop(context);
//                           }
//                         },
//                         child: Submitbutton(
//                           maxWidth: maxWidth,
//                           maxHeight: maxHeight,
//                           isKyc: true,
//                           content: "Save & Continue",
//                         ))
//                   ]))));
//     });
//   }
// }

// Widget imageDialog(path) {
//   return Icon(Icons.edit_document);
// }
