import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/logic/view_models/company_details_manager.dart';
import 'package:xuriti/models/core/credit_limit_model.dart';
import 'package:xuriti/models/core/invoice_model.dart';
import 'package:xuriti/ui/screens/bhome_screens/bhome_screen.dart';
import 'package:xuriti/ui/screens/invoices_screens/invoices_screen.dart';
import 'package:xuriti/ui/theme/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../logic/view_models/transaction_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../widgets/drawer_widget.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    getIt<CompanyDetailsManager>().resetSellerInfo();

    super.initState();
  }

  @override
  // void didChangeDependencies() {
  //   print("dependency called");
  //
  //   // getIt<TransactionManager>().getOutStandingAmt();
  //   super.didChangeDependencies();
  // }
  GlobalKey<ScaffoldState> sk = GlobalKey();
  int currentIndex = 0;

  DateTime? currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    DateTime _lastExitTime = DateTime.now();
    onWillPop() async {
      if (DateTime.now().difference(_lastExitTime) >= Duration(seconds: 2)) {
        //showing message to user
        final snack = SnackBar(
          content: Text("Press the back button again to exist the app"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
        _lastExitTime = DateTime.now();
        return false; // disable back press
      } else {
        return true; //  exit the app
      }
    }

    String? id = getIt<SharedPreferences>().getString('companyId');

    List<Widget> screens = [
      const BhomeScreen(),
      const InvoicesScreen(),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      return WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
            child: FutureBuilder(
                future: getIt<TransactionManager>().getInvoices(id),
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
                      Invoices data = snapshot.data as Invoices;

                      return Scaffold(
                        key: sk,
                        endDrawer: DrawerWidget(
                          maxHeight: maxHeight,
                          maxWidth: maxWidth,
                        ),
                        backgroundColor: Colours.black,
                        appBar: AppBar(
                          backgroundColor: Colours.black,
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Image.asset("assets/images/xuriti1.png"),
                          ),
                          actions: [
                            InkWell(
                              onTap: () {
                                sk.currentState!.openEndDrawer();
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: SvgPicture.asset(
                                      "assets/images/menubutton.svg")),
                            ),
                          ],
                        ),
                        body: screens[currentIndex],
                        bottomNavigationBar: Container(
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    height: h10p * 0.5,
                                    width: w10p * 4.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: currentIndex == 0
                                            ? Colours.tangerine
                                            : Colours.black),
                                    child: const Center(
                                      child: Text(
                                        "Home",
                                        style: TextStyles.textStyle,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    height: h10p * 0.5,
                                    width: w10p * 4.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: currentIndex == 1
                                            ? Colours.tangerine
                                            : Colours.black),
                                    child: const Center(
                                      child: Text(
                                        "Invoices",
                                        style: TextStyles.textStyle,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(""),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
      );
    });
  }
}
