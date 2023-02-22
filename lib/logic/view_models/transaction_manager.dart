import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/logic/view_models/reward_manager.dart';
import 'package:xuriti/models/core/credit_limit_model.dart';
import 'package:xuriti/models/core/get_company_list_model.dart';
import 'package:xuriti/models/core/invoice_model.dart';

import 'package:xuriti/models/core/seller_list_model.dart';
import 'package:xuriti/models/services/dio_service.dart';
import 'package:open_file/open_file.dart';

import 'package:xuriti/ui/routes/router.dart';

import '../../models/core/transactional_model.dart';
import '../../models/helper/service_locator.dart';

class TransactionManager extends ChangeNotifier {
  Invoices? invoices;
  Invoices? tempInvoice;
  String? selectedCreditLimit = "0";
  TransactionModel? transactionModel;

  List<Invoice> pendingInvoice = [];
  List<Invoice> paidInvoices = [];
  List<Invoice> confirmedInvoices = [];

  double totalAmt = 0;
  Invoice? currentInvoice;
  Invoice? currentPaidInvoice;
  bool? isPending;
  String errorMessage = "";
  List<GetCompany> companyList = [];
  int paymentCounter = 0;

  Future<TransactionModel?> getTransactionLedger(String? id) async {
    TransactionModel? transactionModel;
    String? companyId = getIt<SharedPreferences>().getString('companyId');
    try {
      String url = "/ledger/companies/transaction_ledger?buyer=$companyId";
      String? token = getIt<SharedPreferences>().getString("token");
      notifyListeners();
      dynamic responseData = await getIt<DioClient>().get(url, token: token);
      if (responseData['status'] == true) {
        return responseData;
      }
    } catch (e) {
      print(e);
    }
    return transactionModel;
  }

  getInvoices(String? id) async {
    pendingInvoice = [];
    paidInvoices = [];
    confirmedInvoices = [];
    invoices = null;
    if (id != null) {
      print(id);

      String url = "/invoice/search-invoice/$id/buyer";
      print(url);
      String? token = getIt<SharedPreferences>().getString("token");
      print(token);
      await getCreditLimit(token);
      await getIt<RewardManager>().getRewards();

      notifyListeners();
      dynamic responseData = await getIt<DioClient>().get(url, token: token);

      if (responseData != null && responseData['status'] == true) {
        invoices = Invoices.fromJson(responseData);
        tempInvoice = invoices;
        List<Invoice>? invoiceList = tempInvoice!.invoice;

        confirmedInvoices = [];
        for (var i in invoiceList!) {
          if (i.invoiceStatus == "Confirmed" || i.invoiceStatus == "Partpay") {
            confirmedInvoices.add(i);
          } else if (i.invoiceStatus == "Paid") {
            paidInvoices.add(i);
          } else if (i.invoiceStatus == "Pending") {
            pendingInvoice.add(i);
          }
        }
        getOutStandingAmt();

        notifyListeners();

        return invoices;
      }
    }

    return Invoices();
  }

  invoiceDispose() {
    confirmedInvoices = [];
  }

  getCreditLimit(
    token,
  ) async {
    // String? gstNo = getIt<SharedPreferences>().getString("gstIn");
    String? companyId = getIt<SharedPreferences>().getString('companyId');

    String url = "/entity/entity/$companyId";

    dynamic responseData = await getIt<DioClient>().get(url, token: token);

    if (responseData != null) {
      if (responseData['status'] == true && responseData['company'] != null) {
        String credit = responseData['company']['creditLimit'].toString();

        selectedCreditLimit = double.parse(credit).toStringAsFixed(2);

        notifyListeners();
      }
      return selectedCreditLimit;
    }
  }

  getCompanyList(String? id, String? token) async {
    String url = "/entity/entities/$id";
    companyList = [];
    print(url);
    dynamic responseData = await getIt<DioClient>().get(url, token: token);
    print(responseData.toString());
    if (responseData != null &&
        responseData['company'] != null &&
        responseData['company'].length > 0) {
      List<dynamic> companies = responseData['company'];

      for (var company in companies) {
        if (company.containsKey('company') && company['company'] != null) {
          GetCompany singleCompany = GetCompany.fromJson(company);
          companyList.add(singleCompany);
        }
      }
    } else {
      print("failed");
      //print(responseData.toString());
    }
    return companyList;
  }

  getOutStandingAmt() {
    totalAmt = 0;

    for (var i in confirmedInvoices) {
      String outStandingAmt = "0";
      if (i.outstandingAmount != null) {
        outStandingAmt = i.outstandingAmount!;

        totalAmt = totalAmt + double.parse(outStandingAmt);
        notifyListeners();
      } else {
        return double.parse(outStandingAmt.toString()).toStringAsFixed(2);
      }
    }
  }

  changeSelectedInvoice(invoice) {
    currentInvoice = invoice;
    notifyListeners();
  }

  changePaidInvoice(invoice) {
    currentPaidInvoice = invoice;
    notifyListeners();
  }

  setWidgetType(widgetType) {
    isPending = widgetType;
  }

  changeInvoiceStatus(
      String? id,
      String status,
      int index,
      Invoice inv,
      String timeStamp,
      bool userConsent,
      String userComment,
      String userConsentMessage) async {
    String url = "/invoice/status";
    print(id);
    Map<String, dynamic> data = {
      "invoiceID": id,
      "status": status,
      "user_comment": userComment,
      "user_consent_message": userConsentMessage,
      "reason": "xyz",
      "userConsentGiven": userConsent,
      "consentimeStamp": timeStamp,
    };
    print(data);
    // print("status");
    String? token = getIt<SharedPreferences>().getString('token');
    dynamic responseData =
        await getIt<DioClient>().patch(url, data, token: token);
    print(responseData);
    if (responseData != null && responseData['status'] == true) {
      String message = responseData["message"];

      if (responseData["message"] == "Invoice confirmed") {
        confirmedInvoices.add(inv);

        pendingInvoice.removeAt(index);
        notifyListeners();
        return message;
      } else if (responseData["message"] == "Invoice rejected") {
        pendingInvoice.removeAt(index);
        notifyListeners();
        return message;
      }
      return message;
    } else {
      return "Unexpected error occurred please try again later";
    }
  }

  // downloadInvoice(String link) async {
  //   dynamic responseData = await getIt<DioClient>().download(link,"inv1");
  //   print("responseData");
  //   print(responseData);
  //   return responseData;
  // }
  //
  // Future<String> getFilePath(uniqueFileName) async {
  //   String path = '';
  //
  //   Directory dir = await getApplicationDocumentsDirectory();
  //
  //   path = '${dir.path}/$uniqueFileName.pdf';
  //  print(path);
  //   return path;
  // }

//   Future<String> downloadFile(String url, String fileName,) async {
//     HttpClient httpClient =  HttpClient();
//     File file;
//     String filePath = '';
//     String myUrl = '';
//     String dir = (await getApplicationDocumentsDirectory()).path;
// print(dir);
//     try {
//       myUrl = url+'/'+fileName;
//       var request = await httpClient.getUrl(Uri.parse(myUrl));
//       print(request);
//       var response = await request.close();
//       print(response.statusCode);
//       if(response.statusCode == 200) {
//         var bytes = await consolidateHttpClientResponseBytes(response);
//         filePath = '$dir/$fileName';
//         file = File(filePath);
//         print(file);
//         await file.writeAsBytes(bytes);
//       }
//       else
//         filePath = 'Error code: '+response.statusCode.toString();
//       print(filePath);
//       print("ashduigdjdb");
//     }
//     catch(ex){
//       print("12535");
//       filePath = 'Can not fetch url';
//     }
//
//     return filePath;
//   }

  // Future download2(Dio dio,String url, String savePath) async {
  //   var dio = Dio();
  //
  //   try {
  //     Response response = await dio.get(
  //       url,
  //       onReceiveProgress: showDownloadProgress,
  //       //Received data with List<int>
  //       options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           validateStatus: (status) {
  //             return status! < 500;
  //           }),
  //     );
  //     print(response.headers);
  //     File file = File(savePath);
  //     print("file");
  //     print(file);
  //
  //     print("file");
  //     var raf = file.openSync(mode: FileMode.write);
  //     // response.data is List<int> type
  //     raf.writeFromSync(response.data);
  //     await raf.close();
  //   } catch (e) {
  //     print("skjafhiaf");
  //     print(e);
  //   }
  // }

  void showDownloadProgress(received, total) {
    if (total != -1) {}
  }

  Future openFile({required String url, String? fileName}) async {
    final name = fileName ?? url.split('/').last;
    final file = await downloadFile(url, name);
    if (file == null) return;

    print('Path:${file.path}');

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      final response = await Dio().get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }
}
