import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/AdhaarCapture.dart';
import '../models/core/kyc_model.dart';
import '../models/helper/service_locator.dart';
import 'package:http/http.dart' as http;

import '../models/services/dio_service.dart';

class KycController {
  adhaarDetails(String? companyId, File front, File back) async {
    String url = "/kyc/document-verify/aadhaar";
    String? token = getIt<SharedPreferences>().getString('token');
    KycModel kycModel = KycModel();
    //Map<String, dynamic> data = kycModel.toJson();

    var map = new Map<String, dynamic>();

    map['companyId'] = companyId;
    map['front'] = await MultipartFile.fromFile(front as String);
    map['back'] = await MultipartFile.fromFile(back as String);

    FormData formData = FormData.fromMap(map);

    dynamic responseData =
        await getIt<DioClient>().aadhaar_captured_data(url, formData, token);

    if (responseData['status'] == true) {
      Map<String, dynamic> successMessage = {
        'msg': 'Details saved successfully',
      };
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Somthing wents wrong',
      };
      return errorMessage;
    }
    // throw Exception();
  }
}
