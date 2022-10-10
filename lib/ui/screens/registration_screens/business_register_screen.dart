import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/logic/view_models/company_details_manager.dart';
import 'package:xuriti/models/core/CompanyInfo_model.dart';
import 'package:xuriti/models/core/user_details.dart';
import 'package:xuriti/models/helper/service_locator.dart';
import 'package:xuriti/ui/routes/router.dart';
import 'package:xuriti/ui/screens/response_screen.dart';

import '../../../logic/view_models/auth_manager.dart';
import '../../theme/constants.dart';

class BusinessRegister extends StatefulWidget {
  const BusinessRegister({Key? key}) : super(key: key);

  @override
  State<BusinessRegister> createState() => _BusinessRegisterState();
}

class _BusinessRegisterState extends State<BusinessRegister> {
  TextEditingController cinController = TextEditingController();
  TextEditingController tanController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController turnoverController = TextEditingController();

  double sheetSize = .6;
  double maxSize = 1;
  bool showDetails = false;
  bool showButton = false;

  @override
  void dispose() {
    getIt<CompanyDetailsManager>().disposeRegisterCompanyDetails();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserDetails? userInfo = Provider.of<AuthManager>(context).uInfo;
    // UserDetails? userInfo = UserDetails();

    Company? company;
    CompanyInfo? companyInfo;
    TextEditingController gstNumber = TextEditingController();

    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;

      return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset("assets/images/xuriti-logo.png"),
                )
              ]),
          body: ProgressHUD(
            child: Builder(
              builder: (context) {
                final progress = ProgressHUD.of(context);
                return Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView(
                      // controller: scrollController,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(
                                    "assets/images/arrowLeft.svg"),
                              ),
                              SizedBox(
                                width: w10p * 1.5,
                              ),
                              Text(
                                "Register your company",
                                style: TextStyles.textStyle3,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            height: 45,
                            child: TextField(
                                controller: gstNumber,
                                style: TextStyles.textStyle4,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 24),
                                  fillColor: Colours.paleGrey,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "GST No.",
                                )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: InkWell(
                                onTap: () async {
                                  progress!.show();
                                  gstNumber.text.isNotEmpty
                                      ?
                                  await getIt<CompanyDetailsManager>()
                                          .gstSearch(
                                              gstNo: gstNumber.text,
                                              uInfo: userInfo)
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ResponseScreen()));

                                      : Fluttertoast.showToast(
                                          msg: "Please enter GST number",
                                          textColor: Colors.red);
                                  progress.dismiss();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  width: w10p * 8.7,
                                  child: Center(
                                      child: Text("Get Company Details",
                                          style: TextStyles.textStyle5)),
                                  decoration: BoxDecoration(
                                      color: Colours.primary,
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Consumer<CompanyDetailsManager>(
                            builder: (context, params, child) {
                          return params.status == 1
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Container(
                                    height: h10p * 3,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 0.5,
                                              blurRadius: 3)
                                        ]),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24, horizontal: 18),
                                    width: maxWidth,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Company Name : ",
                                              style: TextStyles.textStyle17,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${params.companyinfo?.company!.companyName}",
                                                      style: TextStyles
                                                          .textStyle16),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Address : ",
                                              style: TextStyles.textStyle17,
                                            ),
                                            //  SizedBox(width: w10p * ,)
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                      "${params.companyinfo?.company!.address}",
                                                      //maxLines: 2,
                                                      softWrap: true,
                                                      style: TextStyles
                                                          .textStyle16),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "PAN No : ",
                                              style: TextStyles.textStyle17,
                                            ),
                                            Text(params.panNo,
                                                style: TextStyles.textStyle16),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "District : ",
                                              style: TextStyles.textStyle17,
                                            ),
                                            Text(
                                                "${params.companyinfo?.company!.district}",
                                                style: TextStyles.textStyle16),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "State : ",
                                              style: TextStyles.textStyle17,
                                            ),
                                            Text(
                                                "${params.companyinfo?.company!.state![0]}",
                                                style: TextStyles.textStyle16),
                                            SizedBox(
                                              width: w10p * .2,
                                            ),
                                            Text(
                                                "(${params.companyinfo?.company!.state![1]})",
                                                style: TextStyles.textStyle16),
                                            const SizedBox(
                                              width: 18,
                                            ),
                                            const Text(
                                              "Pincode : ",
                                              style: TextStyles.textStyle17,
                                            ),
                                            Text(
                                                "${params.companyinfo?.company!.pinCode}",
                                                style: TextStyles.textStyle16),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : params.status == 2
                                  ? Container(
                                      child: Center(
                                        child: Text(params.errorMessage ?? ""),
                                      ),
                                    )
                                  : Container();
                        }),
                        Consumer<CompanyDetailsManager>(
                            builder: (context, params, child) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                          controller: tanController,
                                          style: TextStyles.textStyle4,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 24),
                                            fillColor: Colours.paleGrey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            hintText: "TAN",
                                          )),
                                    )),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    Expanded(
                                        child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                          controller: cinController,
                                          style: TextStyles.textStyle4,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 24),
                                            fillColor: Colours.paleGrey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            hintText: "CIN",
                                          )),
                                    )),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(vertical: 8),
                              //   child: SizedBox(
                              //     height: 45,
                              //     child: TextField(
                              //
                              //         controller: panController,
                              //         style: TextStyles.textStyle4,
                              //         decoration: InputDecoration(
                              //           contentPadding:
                              //           const EdgeInsets.symmetric(
                              //               vertical: 10, horizontal: 24),
                              //           fillColor: Colours.paleGrey,
                              //           filled: true,
                              //           border: OutlineInputBorder(
                              //             borderRadius: BorderRadius.circular(10),
                              //           ),
                              //           hintText: "PAN",
                              //         )),
                              //   ),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: SizedBox(
                                  height: 45,
                                  child: TextField(
                                      controller: turnoverController,
                                      style: TextStyles.textStyle4,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 24),
                                        fillColor: Colours.paleGrey,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText: "Annual TurnOver",
                                      )),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: h1p * .1),
                                child: CheckboxListTile(
                                  title: Text("Accept terms and conditions"),
                                  value: params.isChecked,
                                  onChanged: (_) {
                                    getIt<CompanyDetailsManager>().checkBox();
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    gstNumber.text.isNotEmpty
                                        ? InkWell(
                                            onTap: () async {
                                              String gstIn = gstNumber.text;

                                              String panNo = gstIn.substring(
                                                  3, gstIn.length - 4);

                                              // if (tanController.text != "" &&
                                              //     cinController.text != "" &&
                                              //     panController.text != "" &&
                                              //     turnoverController.text != "") {
                                              if (params.isChecked == true) {
                                                progress!.show();
                                                Map<String,
                                                    dynamic> result = await getIt<
                                                        CompanyDetailsManager>()
                                                    .addEntity(
                                                        // consent: consent,
                                                        tan: tanController.text,
                                                        cin: cinController.text,
                                                        pan: panController
                                                                .text.isEmpty
                                                            ? panNo
                                                            : panController
                                                                .text,
                                                        annualTurnover:
                                                            turnoverController
                                                                .text);
                                                progress.dismiss();
                                                if (result['status'] == true) {
                                                  Fluttertoast.showToast(
                                                      msg: result['message']
                                                          .toString(),
                                                      textColor: Colors.green);

                                                  Navigator.pushNamed(
                                                      context, oktWrapper);
                                                } else {
                                                  if (result['errors'] ==
                                                      null) {
                                                    Fluttertoast.showToast(
                                                        msg: result['message']
                                                            .toString(),
                                                        textColor: Colors.red);
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg: result['errors']
                                                                ['message']
                                                            .toString(),
                                                        textColor: Colors.red);
                                                  }
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        content: Text(
                                                          "Please accept terms and conditions",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        )));
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              width: w10p * 8.7,
                                              child: const Center(
                                                  child: Text("CREATE",
                                                      style: TextStyles
                                                          .textStyle5)),
                                              decoration: BoxDecoration(
                                                  color: Colours.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            width: w10p * 8.7,
                                            child: const Center(
                                                child: Text("CREATE",
                                                    style:
                                                        TextStyles.textStyle5)),
                                            decoration: BoxDecoration(
                                                color: Colours.warmGrey,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ));
    });
  }
}

class CenterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 1),
          child: Text(
            "Your Shop has been \nsuccessfully registered.",
            style: TextStyles.textStyle15,
          ),
        ),
      ],
    );
  }
}
