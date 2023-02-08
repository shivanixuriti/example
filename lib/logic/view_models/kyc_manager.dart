import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xuriti/models/core/kyc_model.dart';
import 'package:xuriti/models/core/mobile_verification_model.dart';
import 'package:xuriti/models/helper/service_locator.dart';
import 'package:xuriti/models/services/dio_service.dart';

class KycManager extends ChangeNotifier {
  KycModel kycModel = KycModel();
  MobileVerificationModel mobileVerificationModel = MobileVerificationModel();

  String mobile = '';
  dynamic otpReferenceId = '';
  bool? flag;

  dynamic companyId = getIt<SharedPreferences>().getString('companyId');
  dynamic userID = getIt<SharedPreferences>().getString('id');
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

  Future<List<File?>?> selectFile(bool? flag) async {
    final result =
        await FilePicker.platform.pickFiles(allowMultiple: flag ?? false);
    if (result == null) {
      // Map<String, dynamic> errorMessage = {
      //   'msg': 'File selection failed',
      //   'status': false
      // };
      // return errorMessage;
      return null;
    } else {
      // final path = result.files.single.
      //
      return result.paths
          .where((element) => (element?.length ?? 0) != 0)
          .map((e) => File(e!))
          .toList();
    }
  }

  // Future<Map<String, dynamic>> selectFile2() async {

  //   final result = await FilePicker.platform.pickFiles(allowMultiple: true);
  //   if (result == null) {
  //     Map<String, dynamic> errorMessage = {
  //       'msg': 'File selection failed',
  //       'status': false
  //     };
  //     return errorMessage;
  //   } else {
  //     final path = result.files.single.path;
  //     file = File(path!);
  //     // filePath = basename(file!.path);
  //     filePath2 = path;
  //     print('File Path : ---$filePath2');

  //     Map<String, dynamic> successMessage = {
  //       'msg': ' upload successfully $path',
  //       'status': true
  //     };
  //     return successMessage;
  //   }
  // }

  Future uploadFile({required File file}) async {
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

  storePanCardDetails(String panNo, {required String filePath}) {
    kycModel.panCard = filePath;
    kycModel.panNo = panNo;
  }

  storeOwnershipProof(String docNo, String docType,
      {required String filePath}) async {
    kycModel.propertyOwnership = filePath;
    kycModel.ownershipDocNumber = docNo;
    kycModel.ownershipDocType = docType;
    String url = "/entity/onboard";
    print(url);
    String? token = getIt<SharedPreferences>().getString('token');
    // Map<String, dynamic> data = kycModel.toJson();
    var map = new Map<String, dynamic>();

    map['companyId'] = companyId;
    map['ownershipDocType'] = docType;
    map['ownershipDocNumber'] = docNo;
    map['propertyOwnership'] = await MultipartFile.fromFile(filePath);

    FormData formData = FormData.fromMap(map);

    dynamic responseData =
        await getIt<DioClient>().postFormData(url, formData, token);

    if (responseData['status'] == true) {
      Map<String, dynamic> successMessage = {
        'msg': 'Details saved successfully',
      };
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Enter all mandatory fields',
      };
      return errorMessage;
    }
  }

  storeAadhaarProof(
    String adhaarUID,
  ) {
    // kycModel.frontImage = filePath;
    // kycModel.backImage = filePath2;
    // kycModel.adhaarUID = adhaarUID;
  }

  storeBusinessProof(String docNo, String? docType,
      {required String filePath}) async {
    kycModel.businessProof = filePath;
    kycModel.businessDocNumber = docNo;
    kycModel.businessDocType = docType;
    String url = "/entity/onboard";
    print(url);
    String? token = getIt<SharedPreferences>().getString('token');
    // Map<String, dynamic> data = kycModel.toJson();
    var map = new Map<String, dynamic>();

    map['companyId'] = companyId;
    map['businessDocType'] = docType;
    map['businessDocNumber'] = docNo;
    map['BusinessProof'] = await MultipartFile.fromFile(filePath);

    FormData formData = FormData.fromMap(map);

    dynamic responseData =
        await getIt<DioClient>().postFormData(url, formData, token);

    if (responseData['status'] == true) {
      Map<String, dynamic> successMessage = {
        'msg': 'Details saved successfully',
      };
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Enter all mandatory fields',
      };
      return errorMessage;
    }
  }

  storeAddressProof(String docNo, String docType, {required String filePath}) {
    kycModel.addressFile = filePath;
    kycModel.addressDocNumber = docNo;
    kycModel.addressDocType = docType;
  }

  storeVintageProof({required String filePath}) async {
    kycModel.vintageProof = filePath;
    String url = "/entity/onboard";
    print(url);
    String? token = getIt<SharedPreferences>().getString('token');
    // Map<String, dynamic> data = kycModel.toJson();
    var map = new Map<String, dynamic>();

    map['companyId'] = companyId;
    map['VintageProof'] = await MultipartFile.fromFile(filePath);
    FormData formData = FormData.fromMap(map);

    dynamic responseData =
        await getIt<DioClient>().postFormData(url, formData, token);

    if (responseData['status'] == true) {
      Map<String, dynamic> successMessage = {
        'msg': 'Details saved successfully',
      };
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Enter all mandatory fields',
      };
      return errorMessage;
    }
  }

  storeFirmDetails({required String filePath}) async {
    kycModel.partnershipDetails = filePath;
    String url = "/entity/onboard";
    print(url);
    String? token = getIt<SharedPreferences>().getString('token');
    // Map<String, dynamic> data = kycModel.toJson();
    var map = new Map<String, dynamic>();

    map['companyId'] = companyId;
    map['companyId'] = companyId;
    map['PartnershipDetails'] = await MultipartFile.fromFile(filePath);

    FormData formData = FormData.fromMap(map);

    dynamic responseData =
        await getIt<DioClient>().postFormData(url, formData, token);

    if (responseData['status'] == true) {
      Map<String, dynamic> successMessage = {
        'msg': 'Details saved successfully',
      };
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Enter all mandatory fields',
      };
      return errorMessage;
    }
  }

  storeBankDetails({required String bankStatementImage}) async {
    kycModel.bankStatementDetails = bankStatementImage;
    String url = "/entity/onboard";
    print(url);
    String? token = getIt<SharedPreferences>().getString('token');
    // Map<String, dynamic> data = kycModel.toJson();
    var map = new Map<String, dynamic>();

    map['companyId'] = companyId;
    map['BankStatementDetails'] =
        await MultipartFile.fromFile(bankStatementImage);

    FormData formData = FormData.fromMap(map);

    dynamic responseData =
        await getIt<DioClient>().postFormData(url, formData, token);

    if (responseData['status'] == true) {
      Map<String, dynamic> successMessage = {
        'msg': 'Details saved successfully',
      };
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Enter all mandatory fields',
      };
      return errorMessage;
    }
  }

  storeGstDetails(
      {required List<String> gstImage,
      required List<String> financialDetailsImage}) async {
    kycModel.gstDetails = gstImage;
    kycModel.financialDetails = financialDetailsImage;
    String url = "/entity/onboard";
    print(url);
    String? token = getIt<SharedPreferences>().getString('token');
    // Map<String, dynamic> data = kycModel.toJson();
    var map = new Map<String, dynamic>();

    map['companyId'] = companyId;
    int counter = 0;
    financialDetailsImage.forEach((element) async {
      map['FinancialDetails[${counter}]'] =
          await MultipartFile.fromFile(element);
      counter += 1;
    });

    counter = 0;
    gstImage.forEach((element) async {
      map['GstDetails[${counter}]'] = await MultipartFile.fromFile(element);
      counter += 1;
    });

    FormData formData = FormData.fromMap(map);

    dynamic responseData =
        await getIt<DioClient>().postFormData(url, formData, token);

    if (responseData['status'] == true) {
      Map<String, dynamic> successMessage = {
        'msg': 'Details saved successfully',
      };
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Enter all mandatory fields',
      };
      return errorMessage;
    }
  }

  // storeFinancialDetails() {
  //   kycModel.financialDetails = filePath;
  // }

  storeFinancial_and_Details(String? companyId, File front, File back) async {
    String url = "/entity/onboard";
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

  generateOTP(String mobile) async {
    String url = "/kyc/phone-verification/request-otp";
    String? token = getIt<SharedPreferences>().getString('token');
    KycModel kycModel = KycModel();
    // MobileVerificationModel mobileVerificationModel = MobileVerificationModel();
    // //Map<String, dynamic> data = kycModel.toJson();
    //  mobileVerificationModel.mobileNumber = mobile;

    Map data = {'mobile_number': mobile};
    this.mobile = mobile;

    dynamic responseData =
        await getIt<DioClient>().mobile_verfication(url, data, token);

    print('Response Data : ------> $responseData');

    if (responseData['status'] == true) {
      var data = json.decode(responseData.data);
      print('Data -- > $data');
      var rest = data["referenceId"];
      print('Rest Data -- > $rest');

      otpReferenceId = responseData['data'].referenceId;

      // otpReferenceId = responseData['referenceId'];
      print('Referenece ID : ${otpReferenceId}');
      Map<String, dynamic> successMessage = {
        'msg': 'OTP send successfully',
      };
      print('OTP : $successMessage');
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Somthing wents wrong',
      };
      return errorMessage;
    }
  }

  verifyOTP(
    String otp,
  ) async {
    String url = "/kyc/phone-verification/verify-otp";
    String? token = getIt<SharedPreferences>().getString('token');

    KycModel kycModel = KycModel();

    Map data = {
      'mobile_number': this.mobile,
      'company_id': companyId,
      'otp': otp,
      'referenceId': this.otpReferenceId
    };

    dynamic responseData =
        await getIt<DioClient>().otp_verfication(url, data, token);

    if (responseData['status'] == true) {
      Map<String, dynamic> successMessage = {
        'msg': 'OTP verified successfully',
      };
      print('OTP : $successMessage');
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Somthing wents wrong',
      };
      return errorMessage;
    }
  }

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

  storeImages({required List<String> filePath}) async {
    kycModel.storeImages = filePath;
    String url = "https://dev.xuriti.app/api/entity/onboard";
    print(url);
    String? token = getIt<SharedPreferences>().getString('token');
    // Map<String, dynamic> data = kycModel.toJson();
    var map = new Map<String, dynamic>();
    List uploadImages = [];
    map['_id'] = userID;
    map['companyId'] = companyId;
    int indexCounter = 0;
    // for (; indexCounter < filePath.length;) {
    //   print(filePath);
    for (var file in filePath) {
      var multipartFile = await MultipartFile.fromFile(file);
      uploadImages.add(multipartFile);
    }
    print(uploadImages);
    // }

    map["StoreImages"] = uploadImages;

    FormData formData = FormData.fromMap(map);
    print(map);
    dynamic responseData =
        await getIt<DioClient>().postFormData(url, formData, token);

    if (responseData['status'] == true) {
      Map<String, dynamic> successMessage = {
        'msg': 'Details saved successfully',
      };
      return successMessage;
    } else {
      Map<String, dynamic> errorMessage = {
        'msg': 'Enter all mandatory fields',
      };
      return errorMessage;
    }
  }

  getKycSubmission() async {
    print('----------->In Get_Kyc_Submission ------------------>');
    kycModel.userID = await getIt<SharedPreferences>().getString('id');
    print('=========>${kycModel.userID}');
    kycModel.companyId =
        await getIt<SharedPreferences>().getString('companyId');

    // if (kycModel.panCard != null &&
    //     kycModel.propertyOwnership != null &&
    //     kycModel.ownershipDocNumber != null &&
    //     kycModel.businessProof != null &&
    //     kycModel.ownershipDocType != null &&
    //     kycModel.vintageProof != null &&
    //     kycModel.addressFile != null &&
    //     kycModel.gstDetails != null &&
    //     kycModel.businessDocType != null &&
    //     kycModel.businessDocNumber != null &&
    //     kycModel.addressDocNumber != null &&
    //     kycModel.businessDocType != null &&
    //     kycModel.bankStatementDetails != null &&
    //     kycModel.panNo != null &&
    //     kycModel.financialDetails != null &&
    //     kycModel.userID != null &&
    //     kycModel.companyId != null)
    if (kycModel.businessProof != null &&
        kycModel.businessDocType != null &&
        kycModel.businessDocNumber != null &&
        kycModel.userID != null &&
        kycModel.companyId != null) {
      String url = "/entity/onboard";
      print(url);
      String? token = getIt<SharedPreferences>().getString('token');
      Map<String, dynamic> data = kycModel.toJson();
      print('Data : ${data}');
      FormData formData = FormData.fromMap({
        // 'panNo': data['panNo'],
        // 'addressDocType': data['addressDocType'],
        // 'addressDocNumber': data['addressDocNumber'],
        // 'ownershipDocType': data['ownershipDocType'],
        // 'ownershipDocNumber': data['ownershipDocNumber'],
        'businessDocType': data['businessDocType'],
        'businessDocNumber': data['businessDocNumber'],

        // 'vintageProof': data['vintageProof'],
        // 'panCard': await MultipartFile.fromFile(data['panCard'],
        //     filename: 'panCard.png'),
        // 'addressFile': await MultipartFile.fromFile(data['addressFile'],
        //     filename: 'addressFile.png'),
        'BusinessProof': await MultipartFile.fromFile(data['businessProof'],
            filename: 'BusinessProof.png'),
        // 'GstDetails': await MultipartFile.fromFile(data['gstDetails'],
        //     filename: 'GstDetails.png'),
        // 'propertyOwnership': await MultipartFile.fromFile(
        //     data['propertyOwnership'],
        //     filename: 'propertyOwnership.png'),
        // 'VintageProof': await MultipartFile.fromFile(data['vintageProof'],
        //     filename: 'VintageProof.png'),
        // 'BankStatementDetails': await MultipartFile.fromFile(
        //     data['bankStatementDetails'],
        //     filename: 'BankStatementDetails.png'),
        // 'PartnershipDetails': await MultipartFile.fromFile(
        //     data['partnershipDetails'],
        //     filename: 'PartnershipDetails.png'),
        // 'FinancialDetails': await MultipartFile.fromFile(
        //     data['financialDetails'],
        //     filename: 'FinancialDetails.png'),
        // 'FinancialDetails': await MultipartFile.fromFile(
        //     data['financialDetails'],
        //     filename: 'FinancialDetails.png'),
        // 'FinancialDetails': await MultipartFile.fromFile(
        //     data['financialDetails'],
        //     filename: 'FinancialDetails.png'),
        'userID': data['userID'],
        'companyId': data['companyId']
      });
      dynamic responseData =
          await getIt<DioClient>().postFormData(url, formData, token);
      print('Form Data-->>>>---->${formData}----->>>>>---->');
      print('-->>>>---->${responseData}----->>>>>---->');
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
