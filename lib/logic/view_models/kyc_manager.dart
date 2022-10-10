import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/models/core/kyc_model.dart';
import 'package:xuriti/models/helper/service_locator.dart';
import 'package:xuriti/models/services/dio_service.dart';

class KycManager extends ChangeNotifier {
  KycModel kycModel = KycModel();
  File? file;
  File? image;
  String filePath = "";

  Future<Map<String, dynamic>> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      Map<String, dynamic> errorMessage = {
        'msg': 'Image selection failed',
        'status': false
      };
      return errorMessage;
    } else {
      final imageTemp = File(image.path);
      Map<String, dynamic> successMessage = {
        'msg': 'Image selected successfully $imageTemp',
        'status': true
      };
      return successMessage;
    }
  }

  Future<Map<String, dynamic>> selectFile() async {
    file = File("");
    filePath = "";

    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      Map<String, dynamic> errorMessage = {
        'msg': 'File selection failed',
        'status': false
      };
      return errorMessage;
    } else {
      final path = result.files.single.path;
      file = File(path!);
      // filePath = basename(file!.path);
      filePath = path;

      Map<String, dynamic> successMessage = {
        'msg': ' upload successfully $path',
        'status': true
      };
      return successMessage;
    }
  }

  Future uploadFile() async {
    if (file == null) {
      Map<String, dynamic> errorMessage = {
        'msg': 'File upload failed',
        'status': false
      };
      return errorMessage;
    } else {
      final fileName = basename(file!.path);
      final destination = 'files/$fileName';
    }
  }

  storePanCardDetails(String panNo) {
    kycModel.panCard = filePath;
    kycModel.panNo = panNo;
  }

  storeOwnershipProof(String docNo, String docType) {
    kycModel.propertyOwnership = filePath;
    kycModel.ownershipDocNumber = docNo;
    kycModel.ownershipDocType = docType;
  }

  storeBusinessProof(String docNo, String docType) {
    kycModel.businessProof = filePath;
    kycModel.businessDocNumber = docNo;
    kycModel.businessDocType = docType;
  }

  storeAddressProof(String docNo, String docType) {
    kycModel.addressFile = filePath;
    kycModel.addressDocNumber = docNo;
    kycModel.addressDocType = docType;
  }

  storeVintageProof() {
    kycModel.vintageProof = filePath;
  }

  storeFirmDetails() {
    kycModel.partnershipDetails = filePath;
  }

  storeBankDetails() {
    kycModel.bankStatementDetails = filePath;
  }

  storeGstDetails() {
    kycModel.gstDetails = filePath;
  }

  storeFinancialDetails() {
    kycModel.financialDetails = filePath;
  }

  getKycSubmission() async {
    kycModel.userID = await getIt<SharedPreferences>().getString('id');
    kycModel.companyId = await getIt<SharedPreferences>().getString('companyId');

    if (kycModel.panCard != null &&
        kycModel.propertyOwnership != null &&
        kycModel.ownershipDocNumber != null &&
        kycModel.businessProof != null &&
        kycModel.ownershipDocType != null &&
        kycModel.vintageProof != null &&
        kycModel.addressFile != null &&
        kycModel.gstDetails != null &&
        kycModel.businessDocType != null &&
        kycModel.businessDocNumber != null &&
        kycModel.addressDocNumber != null &&
        kycModel.businessDocType != null &&
        kycModel.bankStatementDetails != null &&
        kycModel.panNo != null &&
        kycModel.financialDetails != null &&
        kycModel.userID != null &&
        kycModel.companyId != null) {

      String url = "/entity/onboard";
      String? token = getIt<SharedPreferences>().getString('token');
      Map<String, dynamic> data = kycModel.toJson();


      FormData formData = FormData.fromMap({
        'panNo': data['panNo'],
        'addressDocType': data['addressDocType'],
        'addressDocNumber': data['addressDocNumber'],
        'ownershipDocType': data['ownershipDocType'],
        'ownershipDocNumber': data['ownershipDocNumber'],
        'businessDocType': data['businessDocType'],
        'businessDocNumber': data['businessDocNumber'],
        'vintageProof': data['vintageProof'],
        'panCard': await MultipartFile.fromFile(data['panCard'],
            filename: 'panCard.png'),
        'addressFile': await MultipartFile.fromFile(data['addressFile'],
            filename: 'addressFile.png'),
        'BusinessProof': await MultipartFile.fromFile(data['businessProof'],
            filename: 'BusinessProof.png'),
        'GstDetails': await MultipartFile.fromFile(data['gstDetails'],
            filename: 'GstDetails.png'),
        'propertyOwnership': await MultipartFile.fromFile(
            data['propertyOwnership'],
            filename: 'propertyOwnership.png'),
        'VintageProof': await MultipartFile.fromFile(data['vintageProof'],
            filename: 'VintageProof.png'),
        'BankStatementDetails': await MultipartFile.fromFile(
            data['bankStatementDetails'],
            filename: 'BankStatementDetails.png'),
        'PartnershipDetails': await MultipartFile.fromFile(
            data['partnershipDetails'],
            filename: 'PartnershipDetails.png'),
        'FinancialDetails': await MultipartFile.fromFile(
            data['financialDetails'],
            filename: 'FinancialDetails.png'),
        'FinancialDetails': await MultipartFile.fromFile(
            data['financialDetails'],
            filename: 'FinancialDetails.png'),
        'FinancialDetails': await MultipartFile.fromFile(
            data['financialDetails'],
            filename: 'FinancialDetails.png'),
        'userID': data['userID'],
        'companyId': data['companyId']
      });
      dynamic responseData =
          await getIt<DioClient>().postFormData(url, formData, token);
      if (responseData['status'] == true) {
        Map<String, dynamic> successMessage = {
          'msg': 'Details saved successfully',
        };
        return successMessage;
      }
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Enter all mandatory fields',
      };
      return errorMessage;
    }
  }
}
