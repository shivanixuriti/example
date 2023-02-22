import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Controller/kycController.dart';
import '../../../Model/AdhaarCapture.dart';
import '../../../Model/KycDetails.dart';
import '../../../logic/view_models/kyc_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../../models/services/dio_service.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/document_uploading.dart';
import '../../widgets/kyc_widgets/submitt_button.dart';
//import 'getAdhaarDetails.dart';
import 'package:http/http.dart' as http;

class AadhaarCard extends StatefulWidget {
  var data;
  dynamic? url;
  // final bool? flag;
  // final Function(List<File?>? files) onFileSelection;
  // const AadhaarCard(data, {Key? key}, this.da) : super(key: key);
  AadhaarCard(this.data)
  // this.flag, this.onFileSelection)
  {
    var response = data['data'];
    url = response.toString();
    print("URL --->$url");
    print('Constructor Data ------> $data');
  }

  @override
  State<AadhaarCard> createState() => _AadhaarCardState(this.data);
}

class _AadhaarCardState extends State<AadhaarCard> {
  TextEditingController aadhaarController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController reCaptchaController = TextEditingController();
  File? frontImage;
  File? backImage;
  String img1 = '';
  String img2 = '';

  var data;
  var url;
  String imageUrl = "";
  var response;
  String? _base64;
  String doc3 = '';

  String? companyId = getIt<SharedPreferences>().getString('companyId');

  File? img;

  String? imgpath;
  var adharno;
  _AadhaarCardState(data) {
    response = data['data'];
    imageUrl = response != null ? response : "";
    var url = response.toString();
    print("URL1 --->$url");
    print('Constructor Data1 ------> $data');
  }
  bool onPressed = false;
  List imgfiles = [];
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    dynamic companyId = getIt<SharedPreferences>().getString('companyId');
    var data = await getIt<KycManager>().getCaptcha();

    //final docs = DioClient().KycDetails(companyId);
    dynamic responseData = await getIt<DioClient>().KycDetails(companyId);
    final details = responseData['data'];
    Aadhar Docdetails = Aadhar.fromJson(details['aadhar']);
    var adharno = Docdetails.number;
    setState(() {
      List<String> imgfiles = Docdetails.files;
      this.imgfiles = imgfiles;
      this.adharno = adharno;
    });
    aadhaarController.text = '${adharno}';
    print('adhaar files...))))))))))))${imgfiles[0].toString()}');
  }

  String name = '';
  String address = '';

  String dob = '';

  String gender = '';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      File imageFile = File(imageUrl.toString());
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
          height: maxHeight,
          decoration: const BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                        "Aadhaar Details",
                        style: TextStyles.leadingText,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: h1p * 1,
              ),
              // Card(

              //   elevation: 3,
              // child:
              Card(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
                elevation: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            //  onTap: () => ({

                            //  }),
                            onTap: () async {
                              // List<File?>? fileSelection =
                              //     await getIt<KycManager>().selectFile(widget.flag);

                              // print('=====>File uploaded====>${fileSelection}');
                              // if (fileSelection?.isEmpty == true ||
                              //     fileSelection == null) {
                              //   Fluttertoast.showToast(msg: "Please select file");
                              //   return;
                              // }

                              // setState(() {
                              //   img = fileSelection[0];
                              //   imgpath = '${img?.path}'; //error
                              // });
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //     behavior: SnackBarBehavior.floating,
                              //     content: Text(
                              //       fileSelection != null
                              //           ? "Uploaded images ${fileSelection.first}"
                              //           : "",
                              //       style: TextStyle(
                              //           color: fileSelection != null
                              //               ? Colors.green
                              //               : Colors.red),
                              //     )));
                              // widget.onFileSelection(fileSelection);
                              FilePickerResult? fileResult = (await FilePicker
                                  .platform
                                  .pickFiles(allowMultiple: false));
                              String? path = fileResult != null
                                  ? fileResult.files.isNotEmpty
                                      ? fileResult.files[0].path
                                      : ""
                                  : "";
                              final File selectFront = File(path as String);
                              // print(selectFront.readAsBytesSync());

                              setState(() {
                                this.frontImage = selectFront;
                                this.img1 = path.toString();
                              });
                              print("front img........$path");
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: w1p * 6,
                                      right: w1p * 6,
                                      top: h1p * 5),
                                  child: Container(
                                      height: h1p * 6,
                                      width: w10p * 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colours.disabledText,
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: w1p * 2,
                                              vertical: h1p * 2),
                                          child: Row(children: [
                                            InkWell(
                                              onTap: () async {
                                                // File? file = File("");
                                                // String filePath = "";
                                                XFile? fileResult =
                                                    await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .camera);
                                                String? path = fileResult !=
                                                        null
                                                    ? fileResult.path.isNotEmpty
                                                        ? fileResult.path
                                                        : ""
                                                    : "";

                                                final File selectFront =
                                                    File(path as String);
                                                setState(() {
                                                  this.frontImage = selectFront;
                                                  this.img1 = path.toString();
                                                });
                                              },
                                              child: Container(
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                      "assets/images/kycImages/camera.svg",
                                                      height: h1p * 4),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Upload Front Image',
                                              style: TextStyles.textStyle121,
                                            ),
                                          ]))),
                                ),
                                this.frontImage != null
                                    ? showImage(img1)
                                    : SizedBox()
                              ],
                            )),
                        InkWell(
                            onTap: () async {
                              FilePickerResult? fileResult = (await FilePicker
                                  .platform
                                  .pickFiles(allowMultiple: false));
                              String? path = fileResult != null
                                  ? fileResult.files.isNotEmpty
                                      ? fileResult.files[0].path
                                      : ""
                                  : "";
                              final File selectBack = File(path as String);
                              setState(() {
                                this.backImage = selectBack;
                                this.img2 = path.toString();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: w1p * 2, right: w1p * 3, top: h1p * 5),
                              child: Column(
                                children: [
                                  Container(
                                    height: h1p * 6,
                                    width: w10p * 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colours.disabledText,
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w1p * 2,
                                            vertical: h1p * 2),
                                        child: Row(children: [
                                          InkWell(
                                            onTap: () async {
                                              XFile? fileResult =
                                                  await ImagePicker().pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              String? path = fileResult != null
                                                  ? fileResult.path.isNotEmpty
                                                      ? fileResult.path
                                                      : ""
                                                  : "";
                                              final File selectBack =
                                                  File(path as String);
                                              setState(() {
                                                this.backImage = selectBack;
                                                this.img2 = path.toString();
                                              });
                                            },
                                            child: Container(
                                              child: SvgPicture.asset(
                                                "assets/images/kycImages/camera.svg",
                                                height: h1p * 4,
                                              ),
                                            ),
                                          ),
                                          // ),
                                          Text(
                                            'Upload Back Image',
                                            style: TextStyles.textStyle121,
                                          ),
                                        ])),
                                  ),
                                  this.backImage != null
                                      ? showImage(img2)
                                      : SizedBox()
                                ],
                              ),
                            )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: w1p * 3,
                        right: w1p * 6,
                      ),
                      child: SizedBox(
                        width: maxWidth,
                        height: 50,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            width: 120,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: imgfiles.length,
                          itemBuilder: (context, index) {
                            String doc = imgfiles[index];
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
                                                fit: BoxFit.fill,
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
                                        url: doc, filename: 'adhaarcard.pdf');
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
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: w1p * 6,
                              right: w1p * 6,
                              top: h1p * 2,
                              bottom: h1p),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              onPressed: () async {
                                print(
                                    "aadharfront--${frontImage} backImg --- ${backImage}");
                                dynamic aadhaar = await getIt<KycManager>()
                                    .adhaarDetails(
                                        companyId, frontImage!, backImage!);
                                // final result = aadhaar['data'];

                                AdhaarCapture adharDetails =
                                    AdhaarCapture.fromJson(aadhaar);
                                print('response data %%%%%%%%%%%% $aadhaar');

                                setState(() {
                                  this.onPressed = true;
                                  this.name = adharDetails.data.name;
                                  this.address = adharDetails.data.address;
                                  this.dob = adharDetails.data.dob;
                                  this.gender = adharDetails.data.gender;
                                });
                                String adharmsg = aadhaar.toString();
                                String adhaarmsg = adharmsg.substring(4);

                                // Fluttertoast.showToast(
                                //     msg: adhaarmsg,
                                //     toastLength: Toast.LENGTH_LONG,
                                //     gravity: ToastGravity.CENTER,
                                //     timeInSecForIosWeb: 3,
                                //     backgroundColor:
                                //         Color.fromARGB(255, 253, 153, 33),
                                //     textColor: Colors.white,
                                //     fontSize: 12.0);
                              },
                              child: Text(
                                'CAPTURED',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 253, 153, 33),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 150, 146, 146),
                                    ),
                                  ))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: maxWidth * 0.1,
                        ),
                        this.onPressed == true
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: w1p * 0.03,
                                    right: w1p * 1,
                                    top: h1p * 1),
                                child: adhaarDetails(this.name, this.address,
                                    this.dob, this.gender),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ],
                ),
              ),
              // ),

              Padding(
                padding: EdgeInsets.only(
                    left: w1p * 6, right: w1p * 6, top: h1p * 5),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: maxWidth * 0.8,
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
                        controller: aadhaarController = TextEditingController(
                            text: '${aadhaarController.text}'),
                        onChanged: (value) {
                          // documentNoController.clear();
                          value = aadhaarController.text;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: w1p * 6, vertical: h1p * .5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: Colours.paleGrey,
                          hintText: "Enter Aadhaar Number",
                          hintStyle: TextStyles.textStyle120,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: maxHeight * 0.03,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: w1p * 6,
                  right: w1p * 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (imageUrl != null && imageUrl.isNotEmpty)
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 5, color: Colors.grey),
                            ),
                            width: maxWidth * 0.3,
                            height: maxHeight * 0.07,
                            child: Image(
                                image: Image.memory(Base64Decoder()
                                        .convert(imageUrl.split(",").last))
                                    .image),
                          )
                        : SizedBox(),
                    InkWell(
                        onTap: () async {
                          setState(() {});
                          var data = await getIt<KycManager>().getCaptcha();
                          response = data['data'];
                          imageUrl = response != null ? response : "";
                          setState(() {});
                        },
                        child: Icon(Icons.refresh)),

                    // Image.network('https://picsum.photos/250?image=9'),
                    // Padding(
                    // padding: EdgeInsets.only(
                    //   left: w1p * 0.03,
                    //   right: w1p * 2,
                    // ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: maxWidth * 0.3,
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
                            controller: reCaptchaController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: w1p * 6, vertical: h1p * .5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colours.paleGrey,
                              hintText: "Captcha*",
                              hintStyle: TextStyles.textStyle120,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: h1p * 5),
                child: Container(
                  height: maxHeight * 0.06,
                  width: maxWidth * w1p * 0.2,
                  child: TextButton(
                    onPressed: () async {
                      // context.showLoader();
                      Map<String, dynamic> aadharOtp = await getIt<KycManager>()
                          .generateAdharOtp(
                              aadhaarController.text, reCaptchaController.text);
                      // AdhaarController.adhaarDetails(companyId, , back)
                      Fluttertoast.showToast(msg: aadharOtp['msg']);
                    },
                    child: Text(
                      'Generate OTP',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 253, 153, 33),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 150, 146, 146),
                          ),
                        ))),
                  ),
                ),
              ),

              SizedBox(
                height: 7,
                // height: maxHeight * 0.03,
              ),
              //generate otp

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: w1p * 10, right: w1p * 3, top: h1p * 5),
                    // padding: EdgeInsets.only(
                    //     left: w1p * 0.03, right: w1p * 2, top: h1p * 1),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: maxWidth * 0.4,
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
                            controller: otpController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: w1p * 6, vertical: h1p * .01),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colours.paleGrey,
                              hintText: "Enter OTP",
                              hintStyle: TextStyles.textStyle120,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w1p * 9, top: h1p * 5),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: maxHeight * 0.06,
                            width: maxWidth * 0.35,
                            child: TextButton(
                              onPressed: () async {
                                Map<String, dynamic> verifyAadharOtp =
                                    await getIt<KycManager>().verifyAdharOtp(
                                  otpController.text,
                                );

                                Fluttertoast.showToast(
                                    msg: verifyAadharOtp['msg']);
                                if (verifyAadharOtp['error'] == false) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Verify OTP',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 253, 153, 33),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 150, 146, 146),
                                    ),
                                  ))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h1p * 4,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: w1p * 9,
                        right: w1p * 3,
                        top: h1p * 2,
                        bottom: h1p * 3),
                    child: Text('Verification Status:'),
                  ))
            ]),
          ),
        ),
      ));
    });
  }

  Widget adhaarDetails(
          String name, String address, String dob, String gender) =>
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              'Address: $address',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              'DOB: $dob',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              'Gender: $gender',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
          ],
        ),
      );
  Widget showImage(path) => Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: Image.file(
              //to show image, you type like this.
              File(path),
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width * 0.38,
              height: 200,
            ),
          ),
        ),
      );
}

Widget imageDialog(path) {
  return Icon(Icons.edit_document);
}
