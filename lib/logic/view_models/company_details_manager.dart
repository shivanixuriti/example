import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/models/core/CompanyInfo_model.dart';
import 'package:xuriti/models/core/EntityModel.dart';
import 'package:xuriti/models/core/seller_info_model.dart';
import 'package:xuriti/models/core/user_details.dart';
import 'package:xuriti/models/helper/service_locator.dart';
import 'package:xuriti/models/services/dio_service.dart';

import '../../models/core/seller_list_model.dart';

class CompanyDetailsManager extends ChangeNotifier {
  CompanyInfo? companyinfo;
  SellerInfo? sellerInfo;
  List<MSeller> sellers = [];
  BussinessDetails bussinessDetails = BussinessDetails();
  String? revisedDiscount;
  String? payableAmount;
  String? revisedInterest;
  String? chosenSellerId;
  Map<String, dynamic> response = {};
  bool isDisable = true;
  String? errorMessage;
  String settleAmountMsg = "";
  String panNo = "";

  double? revisedTotalOutstandingAmount;
  int status = 0;
  int currentSellerIndex = 0;
  bool isSwitched = false;
  bool isChecked = false;
  bool isConsent = false;
  Map<String, dynamic> registrationData = {};

  String? sellerId;

  SellerList? sellerList;
  resetSellerInfo() {
    sellerInfo = null;
    isSwitched = false;
    chosenSellerId = null;
    revisedInterest = "0";
    revisedDiscount = "0";
    payableAmount = "0";
    isDisable = true;
  }

  resetRevisedValues() {
    revisedDiscount = "0";
    payableAmount = "0";
    revisedInterest = "0";
    settleAmountMsg = "";
    notifyListeners();
  }

  toggleSwitch() {
    isSwitched = !isSwitched;
    resetRevisedValues();
    notifyListeners();
  }

  validateSettleAmount(String settleAMount) {
    if (settleAMount.isNotEmpty) {
      String pattern = r"^[0-9]+$";
      RegExp regExp = RegExp(pattern);
      regExp.hasMatch(settleAMount)
          ? settleAmountMsg = ""
          : settleAmountMsg = "Please enter a valid amount";
    } else {
      settleAmountMsg = "Please enter settle amount";
    }
    notifyListeners();
  }

  isValidateSettleAmount(String settleAMount) {
    bool isValidate;

    String pattern = r"^[0-9]+$";
    RegExp regExp = RegExp(pattern);
    regExp.hasMatch(settleAMount) ? isValidate = true : isValidate = false;
    return isValidate;
  }

  checkBox() {
    isChecked = !isChecked;
    notifyListeners();
  }

  disposeRegisterCompanyDetails() {
    status = 0;
    isChecked = false;
  }

  Future<CompanyInfo?> gstSearch(
      {required String gstNo, required UserDetails? uInfo}) async {
    if (gstNo.isNotEmpty && gstNo.length > 8) {
      panNo = gstNo.substring(3, gstNo.length - 4);
    }

    String url = "/entity/search-gst";
    String? token = getIt<SharedPreferences>().getString('token');
    Map<String, dynamic> data = {
      "gstin": gstNo,
    };
    try {
      Map<String, dynamic> responseData =
          await getIt<DioClient>().post(url, data, token);
      response = responseData;
      if (responseData["status"] == true && responseData["company"] != null) {
        companyinfo = CompanyInfo.fromJson(responseData);

        registrationData = responseData["company"];
        registrationData['industryType'] = "IT";
        registrationData['annual_Turnover'] = "";
        registrationData['companyMobile'] = uInfo!.user!.mobileNumber ?? "";
        registrationData['companyEmail'] = uInfo.user!.email ?? "";
        registrationData['admin_mobile'] = uInfo.user!.mobileNumber ?? "";
        registrationData['admin_email'] = uInfo.user!.email ?? "";
        registrationData['userID'] = uInfo.user!.sId ?? "";
        registrationData['dealerName'] = uInfo.user!.name ?? "";
        status = 1;
        notifyListeners();
      } else {
        status = 2;

        notifyListeners();
        errorMessage = (responseData['message']);
        return responseData['message'];
      }
      return companyinfo;
    } catch (e) {}
  }

  addEntity({
    required String tan,
    required String cin,
    required String pan,
    required String annualTurnover,
  }) async {
    String? token = await getIt<SharedPreferences>().getString("token");
    String url = "/entity/add-entity";
    registrationData['consent_gst_defaultFlag'] = isChecked;
    registrationData['tan'] = tan;
    registrationData['cin'] = cin;
    registrationData['pan'] = pan;
    registrationData['annual_Turnover'] = annualTurnover;

    Map<String, dynamic> responseData =
        await getIt<DioClient>().post(url, registrationData, token);
    if (responseData != null) {
      if (responseData['status'] == true) {
        companyinfo = null;
        return responseData;
      } else {
        return responseData;
      }
    } else {
      return responseData;

      // "errors": {"message": "Entity GSTIN Already Exist"},
      // "status": false

    }
  }

  getSellerList(
    companyId,
  ) async {
    sellerList = SellerList();
    if (companyId != null) {
      String url = "/invoice/paymentsummary/?buyer=$companyId";

      String? token = getIt<SharedPreferences>().getString("token");
      dynamic responseData = await getIt<DioClient>().get(url, token: token);

      if (responseData != null && responseData['status'] == true) {
        sellerList = SellerList.fromJson(responseData);
        if (sellerList != null) {
          if (sellerList!.seller != null) {
            return sellerList!.seller;
          }
        }
      }
    }
  }

  Future<MSeller> getPaymentHistorySeller() async {
    String? companyId = getIt<SharedPreferences>().getString('companyId');
    MSeller currentSeller = MSeller();
    await getSellerList(companyId);
    List<MSeller>? tempList = sellerList!.seller;
    for (var i in tempList!) {
      if (i.seller!.sId == sellerId) {
        // currentSeller = i;
        return i;
      }
    }
    return MSeller();
  }

  changeSelectedSellerId(sellerId) {
    sellerId = sellerId;
  }

  changeSelectedSeller(index) {
    currentSellerIndex = index;
  }

  Future<Map<String, dynamic>?> getSellerInfo(companyId, sellerId) async {
    chosenSellerId = sellerId;
    if (companyId != null && sellerId != null) {
      String url = "/invoice/paymentsummary/?buyer=$companyId&seller=$sellerId";

      String? token = getIt<SharedPreferences>().getString("token");
      dynamic responseData = await getIt<DioClient>().get(url, token: token);

      if (responseData != null) {
        if (responseData['status'] == true) {
          sellerInfo = null;
          sellerInfo = SellerInfo.fromJson(responseData);
          notifyListeners();
        } else {
          Map<String, dynamic> errorMessage = {
            "msg": "Something went wrong, please try again",
          };
          return errorMessage;
        }
      } else {
        Map<String, dynamic> errorMessage = {
          "msg": "Something went wrong, please try again",
        };
        return errorMessage;
      }
    }
  }

  outstandingPayNow(companyId, sellerId, paidAmount,
      {isToggled = false}) async {
    Map<String, dynamic>? tempData = {};

    if (companyId != null && sellerId != null) {
      String url =
          "/invoice/paymentsummary/?buyer=$companyId&seller=$sellerId&pay_amount=$paidAmount";

      String? token = getIt<SharedPreferences>().getString("token");
      dynamic responseData = await getIt<DioClient>().get(url, token: token);

      if (responseData != null && responseData['status'] == true) {
        tempData['payableAmount'] = responseData['paybaleAmount'] ?? 0;
        tempData['revisedDiscount'] = ((responseData['total_discount'] != null)
            ? responseData['total_discount'].toString()
            : 0) as String?;
        tempData['interest'] = responseData['total_interest'];
        if (paidAmount != null && isSwitched == true && isToggled == true) {
          isDisable = true;
          revisedDiscount = double.parse(tempData['revisedDiscount'].toString())
              .toStringAsFixed(2);
          payableAmount = double.parse(tempData['payableAmount'].toString())
              .toStringAsFixed(2);
          revisedInterest =
              double.parse(tempData['interest'].toString()).toStringAsFixed(2);
          notifyListeners();
        }

        if (sellerInfo != null && sellerInfo!.totalOutstanding != null) {
          tempData['revisedTotalOutstandingAmount'] =
              double.parse(sellerInfo!.totalOutstanding!) -
                  tempData['payableAmount'];
        }
      }
    }

    return tempData;
  }

  disablePaynow(bool disable) {
    isDisable = disable;
  }

  sendPayment({
    required String? buyerId,
    required String? sellerId,
    required String orderAmount,
    required String outStandingAmount,
    required String discount,
    required String settle_amount,
  }) async {
    String url = "/payment/send-payment";
    String? token = getIt<SharedPreferences>().getString("token");

    Map<String, dynamic> data = {
      "buyerid": buyerId,
      "sellerid": sellerId,
      "order_currency": "ruppee",
      "settle_amount": settle_amount,
      "order_amount": orderAmount,
      "outstanding_amount": outStandingAmount,
      "discount": discount,
      "customer_details": {
        "customer_id": getIt<SharedPreferences>().getString('id'),
        "customer_email": getIt<SharedPreferences>().getString("email"),
        "customer_phone": getIt<SharedPreferences>().getString("phoneNumber"),
      }
    };

    dynamic responseData = await getIt<DioClient>().post(url, data, token);

    return responseData;
  }
}
