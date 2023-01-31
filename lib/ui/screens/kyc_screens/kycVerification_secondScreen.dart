import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/models/helper/service_locator.dart';

import '../../../logic/view_models/kyc_manager.dart';
import '../../../logic/view_models/transaction_manager.dart';
import '../../../models/core/get_company_list_model.dart';
import '../../routes/router.dart';
import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/kyc_details.dart';

class KycVerificationNextStep extends StatefulWidget {
  const KycVerificationNextStep({Key? key}) : super(key: key);

  @override
  State<KycVerificationNextStep> createState() =>
      _KycVerificationNextStepState();
}

class _KycVerificationNextStepState extends State<KycVerificationNextStep> {
  @override
  Widget build(BuildContext context) {
    GetCompany company = GetCompany();
    int? indexOfCompany = getIt<SharedPreferences>().getInt('companyIndex');
    if (indexOfCompany != null) {
      company =
          Provider.of<TransactionManager>(context).companyList[indexOfCompany];
    }
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
              body: ProgressHUD(
                child: Builder(builder: (context) {
                  final progress = ProgressHUD.of(context);
                  return Container(
                    width: maxWidth,
                    decoration: const BoxDecoration(
                        color: Colours.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
                    child: ListView(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w1p * 4, vertical: h1p * 3),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/arrowLeft.svg"),
                                SizedBox(
                                  width: w10p * .3,
                                ),
                                const Text(
                                  "KYC Verification",
                                  style: TextStyles.leadingText,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w1p * 2,
                          ),
                          child: Container(
                            height: h10p * 1.1,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0x66000000),
                                    offset: Offset(0, 1),
                                    blurRadius: 1,
                                    spreadRadius: 0)
                              ],
                              borderRadius: BorderRadius.circular(16),
                              color: Colours.offWhite,
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w1p * 5),
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/images/logo1.svg"),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w1p * 3),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            AutoSizeText(
                                              (indexOfCompany == null &&
                                                      company.companyDetails ==
                                                          null)
                                                  ? ""
                                                  : company.companyDetails!
                                                          .companyName ??
                                                      '',
                                              style: TextStyles.textStyle116,
                                            ),
                                            Text(
                                              " Submit the",
                                              style: TextStyles.textStyle117,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "following documents to complete your KYC",
                                          style: TextStyles.textStyle117,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //     padding:
                        //         EdgeInsets.only(left: w1p * 3, right: w1p * 3),
                        //child:
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, addressProof);
                          },
                          child: KycDetails(
                            title: "Address Proof",
                            subtitle: " (Any one of the following)",
                            maxHeight: maxHeight,
                            maxWidth: maxWidth,
                          ),
                        ),
                        //),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, businessProof);
                          },
                          child: KycDetails(
                            title: "Business Proof",
                            subtitle: " (Any one of the following)",
                            maxHeight: maxHeight,
                            maxWidth: maxWidth,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, ownershipProof);
                          },
                          child: KycDetails(
                            title: "Ownership Proof",
                            subtitle:
                                " (Business/Residence) (Any one of the following)",
                            maxHeight: maxHeight,
                            maxWidth: maxWidth,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, vintageProof);
                          },
                          child: KycDetails(
                            title: "Vintage Proof",
                            maxHeight: maxHeight,
                            maxWidth: maxWidth,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, firmDetails);
                          },
                          child: KycDetails(
                            title: "Firm/Partnership Details",
                            maxHeight: maxHeight,
                            maxWidth: maxWidth,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, bankDetails);
                          },
                          child: KycDetails(
                            title: "Banking Details",
                            maxHeight: maxHeight,
                            maxWidth: maxWidth,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: w1p * 3, top: h1p * 4, right: w1p * 3),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, finGstDetails);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0x1f000000),
                                        offset: Offset(0, 3),
                                        blurRadius: 1,
                                        spreadRadius: 0)
                                  ],
                                  color: Colours.white),
                              child: ListTile(
                                tileColor: Colours.white,
                                title: Row(
                                  children: [
                                    Text(
                                      "Financial & GST Details ",
                                      style: TextStyles.textStyle44,
                                    ),
                                    Text(
                                      "(Upto 24 Months)",
                                      style: TextStyles.textStyle119,
                                    ),
                                  ],
                                ),
                                trailing: SvgPicture.asset(
                                    "assets/images/kycImages/vector.svg"),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: h1p * 3,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: w1p * 3, right: w1p * 3),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, kycVerification);
                                },
                                child: const Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(
                                    Icons.keyboard_arrow_left_rounded,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Text(
                                'prev',
                                style: TextStyles.textStyle44,
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     // Padding(
                        //     //   padding: EdgeInsets.only(
                        //     //       left: w1p * 3, right: w1p * 3),
                        //     //   child:
                        //     InkWell(
                        //       onTap: () {
                        //         Navigator.pushNamed(context, kycSubmission);
                        //       },
                        //       child: Align(
                        //         alignment: Alignment.center,
                        //         child: Icon(
                        //           Icons.keyboard_arrow_left_rounded,
                        //           size: 30,
                        //         ),
                        //       ),
                        //       //),
                        //     ),
                        //     // Padding(
                        //     //   padding: EdgeInsets.only(
                        //     //       left: w1p * 3, right: w1p * 3),
                        //     //   child:
                        //     InkWell(
                        //       onTap: () {
                        //         Navigator.pushNamed(context, kycSubmission);
                        //       },
                        //       child: Align(
                        //         alignment: Alignment.center,
                        //         child: Icon(
                        //           Icons.keyboard_arrow_right_rounded,
                        //           size: 30,
                        //         ),
                        //       ),
                        //     ),
                        //     //),
                        //   ],
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w1p * 5,
                          ),
                          child: InkWell(
                            onTap: () async {
                              progress!.show();
                              Map<String, dynamic> kyc =
                                  await getIt<KycManager>().getKycSubmission();
                              progress.dismiss();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        kyc['msg'],
                                        style: TextStyle(
                                            color: kyc['status'] == true
                                                ? Colors.green
                                                : Colors.green),
                                      )));
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: h1p * 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colours.tangerine,
                              ),
                              child: Center(
                                child: Text(
                                  "Submit Details",
                                  style: TextStyles.subHeading,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: h1p * 10,
                        ),
                      ],
                    ),
                  );
                }),
              )));
    });
  }
}
