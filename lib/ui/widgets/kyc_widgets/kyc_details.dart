import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xuriti/Model/KycDetails.dart';

import '../../theme/constants.dart';

class KycDetails extends StatelessWidget {
  final String title;
  final double maxWidth;
  final double maxHeight;
  String? subtitle;
  String? kycStatus;

  KycDetails(
      {required this.title,
      required this.maxWidth,
      required this.maxHeight,
      this.subtitle,
      this.kycStatus});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double h1p = maxHeight * 0.01;
      double h10p = maxHeight * 0.1;
      double w10p = maxWidth * 0.1;
      double w1p = maxWidth * 0.01;
      return Padding(
        padding: EdgeInsets.only(left: w1p * 3, top: h1p * 4, right: w1p * 3),
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
                KycStatus.kycStatusToIcon(kycStatus),
                SizedBox(
                  width: w1p * 3,
                ),
                Text(
                  title,
                  style: TextStyles.textStyle44,
                ),
                Text(
                  subtitle ?? "",
                  style: TextStyles.textStyle119,
                ),
              ],
            ),
            trailing: SvgPicture.asset("assets/images/kycImages/vector.svg"),
          ),
        ),
      );
    });
  }
}
