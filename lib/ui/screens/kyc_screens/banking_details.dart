import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/logic/view_models/kyc_manager.dart';

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
                    InkWell(
                      onTap: () async {
                        Map<String, dynamic> bankingDetails =
                            await getIt<KycManager>().storeBankDetails(
                                bankStatementImage:
                                    bankDetailsImages?.first?.path ?? "");
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
