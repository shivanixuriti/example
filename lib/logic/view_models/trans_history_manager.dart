import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/models/core/payment_history_model.dart';
import 'package:xuriti/models/core/seller_list_model.dart';
import 'package:xuriti/models/helper/service_locator.dart';
import 'package:xuriti/models/services/dio_service.dart';

class TransHistoryManager extends ChangeNotifier {
  TrancDetail? transDetail;
  SellerList? sellerList;
  String? sellerData;

  List<String> sellerName = [];
  List<String> sellerNameList = [];
  PaymentHistory? paymentDetails;

  resetFilterDetails() {
    sellerData = "";
  }

  getPaymentHistory(token, buyerId) async {
    String url = "/payment/transctionshistory?buyer=$buyerId";

    dynamic responseData = await getIt<DioClient>().get(url, token: token);
    if (responseData != null && responseData['status'] == true) {
      print('${responseData}================================>>>>>>>>>>>>>>>>');
      PaymentHistory paymentHistory = PaymentHistory.fromJson(responseData);
      print(
          'Payment History ${paymentHistory}================================>>>>>>>>>>>>>>>>');
      if (paymentHistory.trancDetail != null) {
        List<TrancDetail>? historyDetails = paymentHistory.trancDetail;
        for (var i in historyDetails!) {
          sellerName.add(i.sellerName ?? "");
        }
        sellerNameList = sellerName.toSet().toList();
        if (paymentHistory != null) {
          paymentDetails = paymentHistory;
          paymentHistory.trancDetail?.sort((b, a) {
            String newA = a.createdAt ?? '';
            String newB = b.createdAt ?? '';
            DateTime dtA = DateTime.parse(newA);
            DateTime dtB = DateTime.parse(newB);

            if (newA == '') {
              return 0;
            } else if (newB == '') {
              return 0;
            } else if (newA == '' && newB == '') {
              return 0;
            } else {
              return dtA.compareTo(dtB);
            }
          });
        }
        return paymentHistory;
      }
    } else if (responseData == null) {
      return PaymentHistory();
    }
  }

  filterBySeller(String? val) {
    sellerData = val;

    List<TrancDetail> temp = [];
    List<TrancDetail>? trd = paymentDetails!.trancDetail;

    if (trd != null && trd.isNotEmpty) {
      for (var i in trd) {
        if (i.sellerName == val) {
          temp.add(i);
        }
        paymentDetails!.trancDetail = temp;
        notifyListeners();
      }
    }
  }

  getPaymentHistoryDetails() async {
    String? token = getIt<SharedPreferences>().getString('token');
    String? companyId = getIt<SharedPreferences>().getString('companyId');
    String? sellerId = getIt<SharedPreferences>().getString('sellerId');
    String url =
        "/payment/transctionshistory?buyer=$companyId&seller=$sellerId";
    dynamic responseData = await getIt<DioClient>().get(url, token: token);
    if (responseData != null && responseData['status'] == true) {
      PaymentHistory paymentHistory = PaymentHistory.fromJson(responseData);
      return paymentHistory;
    } else if (responseData == null) {
      return PaymentHistory();
    }
  }

  changeSelectedPaymentHistory(transaction) {
    transDetail = transaction;
    notifyListeners();
  }
}
