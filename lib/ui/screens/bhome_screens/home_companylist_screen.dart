import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../logic/view_models/transaction_manager.dart';
import '../../../models/core/get_company_list_model.dart';
import '../../../models/helper/service_locator.dart';
import '../../routes/router.dart';
import '../../routes/router.dart';
import '../../theme/constants.dart';
import '../../widgets/payment_history_widgets/leading.dart';

class HomeCompanyList extends StatefulWidget {
  const HomeCompanyList({Key? key}) : super(key: key);

  @override
  State<HomeCompanyList> createState() => _HomeCompanyListState();
}

class _HomeCompanyListState extends State<HomeCompanyList> {
  @override
  Widget build(BuildContext context) {
    String? id = getIt<SharedPreferences>().getString("id");
    String? token = getIt<SharedPreferences>().getString('token');

    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      double w1p = maxWidth * 0.01;

      return SafeArea(
          child: FutureBuilder(
              future: getIt<TransactionManager>().getCompanyList(id, token),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<GetCompany> data = snapshot.data as List<GetCompany>;
                    return Scaffold(
                      backgroundColor: Colours.black,
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: Colours.black,
                        automaticallyImplyLeading: false,
                        toolbarHeight: h1p * 8,
                        flexibleSpace: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: h1p * 2, horizontal: w1p * 3),
                              child: Image.asset(
                                "assets/images/xuriti1.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: Container(
                        width: maxWidth,
                        decoration: const BoxDecoration(
                            color: Colours.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(26),
                              topRight: Radius.circular(26),
                            )),
                        child: CustomScrollView(slivers: [
                          SliverList(
                              delegate: SliverChildListDelegate(
                            [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: w1p * 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                          "assets/images/arrowLeft.svg"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: h1p * 5),
                                      child: Text(
                                        "Companies",
                                        style: TextStyles.textStyle56,
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, addCompany);
                                        },
                                        child: Icon(Icons.add))
                                  ],
                                ),
                              )
                            ],
                          )),
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return InkWell(
                                  onTap: () async {
                                    String? companyId =
                                        data[index].companyDetails!.sId;
                                    String? companyName =
                                        data[index].companyDetails!.companyName;
                                    String? companyStatus =
                                        data[index].companyDetails!.status;
                                    await getIt<SharedPreferences>()
                                        .setString('companyId', companyId!);
                                    await getIt<SharedPreferences>()
                                        .setInt('companyIndex', index);
                                    if (companyStatus == "Approved") {
                                      Navigator.pushReplacementNamed(
                                          context, landing);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Text(
                                                'You are not allowed to perform any operation, $companyName status is $companyStatus. Please contact to Xuriti team.',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )));
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: w1p * 5,
                                      right: w1p * 5,
                                      bottom: h1p * 3,
                                    ),
                                    child: Container(
                                      height: h10p * 1,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colours.tangerine),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data[index].companyDetails == null
                                                  ? ""
                                                  : data[index]
                                                          .companyDetails!
                                                          .companyName ??
                                                      "",
                                              style: TextStyles.textStyle85,
                                            ),
                                            // Text("Asian Paints",style: TextStyles.textStyle85,),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "GST No :",
                                                  style: TextStyles.textStyle71,
                                                ),
                                                Text(
                                                  data[index]
                                                          .companyDetails!
                                                          .gstin ??
                                                      '',
                                                  style: TextStyles.textStyle71,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                            childCount: data.length,
                          ))
                        ]),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }));
    });
  }
}
