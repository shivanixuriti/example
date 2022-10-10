import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../logic/view_models/company_details_manager.dart';

import '../../../../models/core/seller_list_model.dart';
import '../../../../models/helper/service_locator.dart';
import '../../../theme/constants.dart';
import '../../../widgets/payment_history_widgets/company_details.dart';

class AllSellers extends StatefulWidget {
  const AllSellers({Key? key}) : super(key: key);

  @override
  State<AllSellers> createState() => _AllSellersState();
}

class _AllSellersState extends State<AllSellers> {
  @override
  Widget build(BuildContext context) {
    String? companyId = getIt<SharedPreferences>().getString('companyId');



    List<Widget> screens = [];
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      double w1p = maxWidth * 0.01;
      return FutureBuilder(
          future: getIt<CompanyDetailsManager>().getSellerList(companyId),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              else if (snapshot.hasData) {
                List<MSeller> sellers = snapshot.data as List<MSeller>;
          return   sellers.isEmpty?
                 Container(
                  width: maxWidth,
                  height: maxHeight,
                  decoration: const BoxDecoration(
                      color: Colours.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      )),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(21),
                        child: Row(
                          children: const [
                            Text(
                              "Associated Sellers",
                              style: TextStyles.textStyle38,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w10p * .6, vertical: h1p * 1),
                        child: Container(
                            width: maxWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colours.offWhite),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: h1p * 3, horizontal: w10p * .3),
                              child: Row(children: [
                                SvgPicture.asset("assets/images/logo1.svg"),
                                SizedBox(
                                  width: w10p * 0.5,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: const [
                                              Text(
                                                "Please wait while we connect you with your",
                                                style: TextStyles.textStyle34,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: const [
                                        Text(
                                          "sellers and load your invoices>>",
                                          style: TextStyles.textStyle34,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                            )),
                      ),
                      SizedBox(
                        height: h1p * 8,
                      ),
                      Center(
                        child: Image.asset("assets/images/onboard-image-1.png"),
                      ),
                    ],
                  ),
                ):
          Container(
              width: maxWidth,
              height: maxHeight,
              decoration: const BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  )),
              child: ListView.builder(itemBuilder: (context,
                  index) {
                return Column(
                  children: [
                    index == 0?Padding(
                      padding:  EdgeInsets.only(left: w1p * 6,top: h1p * 4,bottom: h1p * 2),
                      child: Row(
                        children: [
                          Text("Associated Sellers", style: TextStyles.textStyle38,),
                        ],
                      ),
                    ):Container(),
                    GestureDetector(
                      onTap: () async {
                        // await getIt<CompanyDetailsManager>().changeSelectedSeller(index);
                        // Navigator.pushNamed(context, sellersDetails);
                      },
                      child: CompanyDetailsWidget(
                        maxHeight: maxHeight,
                        maxWidth: maxWidth,
                        image: "assets/images/company-vector.png",
                        companyName: sellers[index].seller!.companyName ?? "",
                        creditLimit: sellers[index].seller!.creditLimit.toString() ,
                        balanceCredit: sellers[index].seller!.availCredit ?? '',
                        state: sellers[index].seller!.state ?? "",
                        companyAddress: sellers[index].seller!.address ?? "",
                        gstNo: sellers[index].seller!.gstin ?? "",
                      ),

                    ),
                  ],
                );
              },
                itemCount: sellers.length,


              ));
              }
              else {
                return Container(
                  width: maxWidth,
                  height: maxHeight,
                  decoration: const BoxDecoration(
                      color: Colours.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      )),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(21),
                        child: Row(
                          children: const [
                            Text(
                              "Associated Sellers",
                              style: TextStyles.textStyle38,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w10p * .6, vertical: h1p * 1),
                        child: Container(
                            width: maxWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colours.offWhite),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: h1p * 3, horizontal: w10p * .3),
                              child: Row(children: [
                                SvgPicture.asset("assets/images/logo1.svg"),
                                SizedBox(
                                  width: w10p * 0.5,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: const [
                                              Text(
                                                "Please wait while we connect you with your",
                                                style: TextStyles.textStyle34,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: const [
                                        Text(
                                          "sellers and load your invoices>>",
                                          style: TextStyles.textStyle34,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                            )),
                      ),
                      SizedBox(
                        height: h1p * 8,
                      ),
                      Center(
                        child: Image.asset("assets/images/onboard-image-1.png"),
                      ),
                    ],
                  ),
                );
              }

            }
            else {

              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }
}
