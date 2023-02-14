import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xuriti/logic/view_models/kyc_manager.dart';

import '../../logic/view_models/auth_manager.dart';
import '../../logic/view_models/profile_manager.dart';
import '../../logic/view_models/transaction_manager.dart';
import '../../models/core/get_company_list_model.dart';
import '../../models/core/user_details.dart';
import '../../models/core/user_info_model.dart';
import '../../models/helper/service_locator.dart';
import '../routes/router.dart';
import '../theme/constants.dart';

class DrawerWidget extends StatelessWidget {
  final double maxWidth;
  final double maxHeight;
  const DrawerWidget({
    required this.maxWidth,
    required this.maxHeight,
  });
  final padding = const EdgeInsets.symmetric(horizontal: 10);

  @override
  Widget build(BuildContext context) {
    GetCompany company = GetCompany();
    UserDetails? userInfo = Provider.of<AuthManager>(context).uInfo;
    int? indexOfCompany = getIt<SharedPreferences>().getInt('companyIndex');
    if (indexOfCompany != null) {
      company =
          Provider.of<TransactionManager>(context).companyList[indexOfCompany];
    }

    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    return Drawer(
      backgroundColor: Colours.black,
      child: ListView(
        children: [
          Row(
            children: [
              SizedBox(
                width: w10p * .5,
              ),
              SizedBox(
                height: h10p * 1,
              ),
              Image.asset(
                "assets/images/xuriti-white.png",
                height: h10p * .4,
              ),
            ],
          ),
          SizedBox(
            height: h10p * .1,
          ),
          Container(
            color: Colours.almostBlack,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: h1p * 1.9, horizontal: w10p * .5),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, profile);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/kycImages/avatar.png",
                      height: h1p * 6,
                      width: w10p * 2,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            (indexOfCompany == null ||
                                    company.companyDetails == null)
                                ? ""
                                : company.companyDetails!.companyName ?? '',
                            style: TextStyles.sName,
                          ),
                          Text(
                            (userInfo == null || userInfo.user == null)
                                ? ""
                                : userInfo.user!.name ?? '',
                            style: TextStyles.textStyle21,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: h10p * .6, horizontal: w10p * .7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "About Xuriti",
                  style: TextStyles.textStyle98,
                ),
                SizedBox(height: h1p * 5),
                const Text(
                  "Payment Options",
                  style: TextStyles.textStyle98,
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, kycVerification);
                  },
                  child: const Text(
                    "Kyc Verification",
                    style: TextStyles.textStyle98,
                  ),
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                const Text(
                  "Payment History",
                  style: TextStyles.textStyle98,
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, reportsOptions);
                  },
                  child: const Text(
                    "Reports",
                    style: TextStyles.textStyle98,
                  ),
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                const Text(
                  "Associated Companies",
                  style: TextStyles.textStyle98,
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                const Text(
                  "Help Center",
                  style: TextStyles.textStyle98,
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                InkWell(
                  onTap: () async {
                    Map<String, dynamic> data =
                        await getIt<ProfileManager>().getTermsAndConditions();
                    if (data != null && data['status'] == true) {
                      _launchInBrowser(Uri.parse(
                          "https://docs.google.com/gview?embedded=true&url=${data['url']}"));
                      Fluttertoast.showToast(msg: "Opening file");
                    }
                    Fluttertoast.showToast(msg: "Technical error occurred");
                    // await getIt<TransactionManager>().openFile(
                    //     url:
                    //         "https://s3.ap-south-1.amazonaws.com/xuriti.public.document/xuritiTermsofService.pdf");
                    //
                    // Fluttertoast.showToast(msg: "Opening file");
                  },
                  child: const Text(
                    "Privacy Policy",
                    style: TextStyles.textStyle98,
                  ),
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                InkWell(
                  onTap: () async {
                    Map<String, dynamic> data =
                        await getIt<ProfileManager>().getTermsAndConditions();
                    if (data != null && data['status'] == true) {
                      _launchInBrowser(Uri.parse(
                          "https://docs.google.com/gview?embedded=true&url=${data['url']}"));
                      Fluttertoast.showToast(msg: "Opening file");
                    }
                    Fluttertoast.showToast(msg: "Technical error occurred");
                  },
                  child: const Text(
                    "Terms of Use",
                    style: TextStyles.textStyle98,
                  ),
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                const Text(
                  "FAQs",
                  style: TextStyles.textStyle98,
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                const Text(
                  "Contact Us",
                  style: TextStyles.textStyle98,
                ),
                SizedBox(
                  height: h1p * 5,
                ),
                InkWell(
                  onTap: () async {
                    await getIt<AuthManager>().logOut();
                    await getIt<SharedPreferences>().clear();
                    await getIt<SharedPreferences>()
                        .setString('onboardViewed', 'true');

                    Navigator.pushNamed(context, getStarted);
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyles.textStyle98,
                  ),
                ),
                SizedBox(
                  height: h1p * 3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
