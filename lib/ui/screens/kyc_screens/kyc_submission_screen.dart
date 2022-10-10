import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/constants.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../../widgets/kyc_widgets/submitt_button.dart';

class kycSubmission extends StatelessWidget {
  const kycSubmission({Key? key}) : super(key: key);

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
                   Padding(
                     padding:  EdgeInsets.only(top: h10p * 2),
                     child: Center(child: Image.asset("assets/images/kycImages/thumbs-up.png")),
                   ),

                    Center(child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: h1p * 3,),
                      child: Text("Thank you!",style: TextStyles.textStyle125,),
                    )),
                    Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: w10p * 1),
                          child: Text("We received your KYC verification details.We ",style: TextStyles.textStyle126),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: w10p * 1.5),
                          child: Text("will let you know the deails in 2-3 days",style: TextStyles.textStyle126),
                        ),
                      ],
                    ),
                    Submitbutton(
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      content: "Back to Home",
                      isKyc: true,
                    )
                  ]))));
    });
  }
}
