// To parse this JSON data, do
//
//     final adhaarCapture = adhaarCaptureFromJson(jsonString);

import 'dart:convert';

AdhaarCapture adhaarCaptureFromJson(String str) =>
    AdhaarCapture.fromJson(json.decode(str));

String adhaarCaptureToJson(AdhaarCapture data) => json.encode(data.toJson());

class AdhaarCapture {
  AdhaarCapture({
    required this.data,
    required this.status,
  });

  Data data;
  bool status;

  factory AdhaarCapture.fromJson(Map<String, dynamic> json) => AdhaarCapture(
        data: Data.fromJson(json["data"]),
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
      };
}

class Data {
  Data({
    required this.pan,
    required this.aadhar,
    required this.mobile,
    required this.faceMatch,
    required this.address,
    required this.bankStatement,
    required this.business,
    required this.financial,
    required this.gst,
    required this.ownership,
    required this.partnership,
    required this.vintage,
    required this.storeImages,
  });

  Pan pan;
  Aadhar aadhar;
  Mobile mobile;
  FaceMatch faceMatch;
  Address address;
  Banking bankStatement;
  Business business;
  Financial financial;
  Gst gst;
  Business ownership;
  Partnership partnership;
  Vintage vintage;
  StoreImage storeImages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pan: Pan.fromJson(json["pan"] ?? ""),
        aadhar: Aadhar.fromJson(json["aadhar"] ?? ""),
        mobile: Mobile.fromJson(json["mobile"] ?? ""),
        faceMatch: FaceMatch.fromJson(json["faceMatch"] ?? ""),
        address: Address.fromJson(json["address"] ?? ""),
        bankStatement: Banking.fromJson(json["bankStatement"] ?? ""),
        business: Business.fromJson(json["business"] ?? ""),
        financial: Financial.fromJson(json["financial"] ?? ""),
        gst: Gst.fromJson(json["gst"] ?? ""),
        ownership: Business.fromJson(json["ownership"] ?? ""),
        partnership: Partnership.fromJson(json["partnership"] ?? ""),
        vintage: Vintage.fromJson(json["vintage"] ?? ""),
        storeImages: StoreImage.fromJson(json["storeImages"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "pan": pan.toJson(),
        "aadhar": aadhar.toJson(),
        "mobile": mobile.toJson(),
        "faceMatch": faceMatch.toJson(),
        "address": address.toJson(),
        "bankStatement": bankStatement.toJson(),
        "business": business.toJson(),
        "financial": financial.toJson(),
        "gst": gst.toJson(),
        "ownership": ownership.toJson(),
        "partnership": partnership.toJson(),
        "vintage": vintage.toJson(),
        "storeImages": storeImages.toJson(),
      };
}

class Aadhar {
  Aadhar({
    required this.verified,
    required this.status,
    required this.comment,
    required this.holder,
    required this.number,
    required this.address,
    required this.dob,
    required this.gender,
    required this.files,
  });

  bool verified;
  String status;
  String comment;
  String holder;
  String number;
  String address;
  String dob;
  String gender;
  List<String> files;

  factory Aadhar.fromJson(Map<String, dynamic> json) => Aadhar(
        verified: json["verified"] ?? "",
        status: json["status"] ?? "",
        comment: json["comment"] ?? "",
        holder: json["holder"] ?? "",
        number: json["number"] ?? "",
        address: json["address"] ?? "",
        dob: json["dob"] ?? "",
        gender: json["gender"] ?? "",
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "status": status,
        "comment": comment,
        "holder": holder,
        "number": number,
        "address": address,
        "dob": dob,
        "gender": gender,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class Address {
  Address({
    required this.status,
    this.comment,
    required this.verified,
    required this.files,
  });

  String status;
  String? comment;
  bool verified;
  List<String> files;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        status: json["status"] ?? "",
        comment: json["comment"] ?? "",
        verified: json["verified"] ?? "",
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "comment": comment,
        "verified": verified,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class Business {
  Business({
    required this.documentNumber,
    required this.documentType,
    required this.status,
    required this.verified,
    required this.files,
  });

  String documentNumber;
  String documentType;
  String status;
  bool verified;
  List<String> files;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        documentNumber: json["documentNumber"] ?? "",
        documentType: json["documentType"] ?? "",
        status: json["status"] ?? "",
        verified: json["verified"] ?? false,
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "documentNumber": documentNumber,
        "documentType": documentType,
        "status": status,
        "verified": verified,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class Ownership {
  Ownership({
    required this.documentNumber,
    required this.documentType,
    required this.status,
    required this.verified,
    required this.files,
  });

  String documentNumber;
  String documentType;
  String status;
  bool verified;
  List<String> files;

  factory Ownership.fromJson(Map<String, dynamic> json) => Ownership(
        documentNumber: json["documentNumber"] ?? "",
        documentType: json["documentType"] ?? "",
        status: json["status"] ?? "",
        verified: json["verified"] ?? "",
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "documentNumber": documentNumber,
        "documentType": documentType,
        "status": status,
        "verified": verified,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class Partnership {
  Partnership({
    required this.status,
    required this.verified,
    required this.files,
  });

  String status;
  bool verified;
  List<String> files;

  factory Partnership.fromJson(Map<String, dynamic> json) => Partnership(
        status: json["status"] ?? "",
        verified: json["verified"] ?? false,
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "verified": verified,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class Vintage {
  Vintage({
    required this.status,
    required this.verified,
    required this.files,
  });

  String status;
  bool verified;
  List<String> files;

  factory Vintage.fromJson(Map<String, dynamic> json) => Vintage(
        status: json["status"] ?? "",
        verified: json["verified"] ?? false,
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "verified": verified,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class StoreImage {
  StoreImage({
    required this.status,
    required this.verified,
    required this.files,
  });

  String status;
  bool verified;
  List<String> files;

  factory StoreImage.fromJson(Map<String, dynamic> json) => StoreImage(
        status: json["status"] ?? "",
        verified: json["verified"] ?? false,
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "verified": verified,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class Banking {
  Banking({
    required this.status,
    required this.verified,
    required this.files,
  });

  String status;
  bool verified;
  List<String> files;

  factory Banking.fromJson(Map<String, dynamic> json) => Banking(
        status: json["status"] ?? "",
        verified: json["verified"] ?? false,
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "verified": verified,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class FaceMatch {
  FaceMatch({
    required this.verified,
    required this.status,
    required this.comment,
    required this.holder,
    required this.matchPercentage,
    required this.message,
    required this.dob,
    required this.files,
  });

  String verified;
  String status;
  String comment;
  String holder;
  String matchPercentage;
  String message;
  String dob;
  List<String> files;

  factory FaceMatch.fromJson(Map<String, dynamic> json) => FaceMatch(
        verified: json["verified"] ?? "",
        status: json["status"] ?? "",
        comment: json["comment"] ?? "",
        holder: json["holder"] ?? "",
        matchPercentage: json["matchPercentage"],
        message: json["message"] ?? "",
        dob: json["dob"] ?? "",
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "status": status,
        "comment": comment,
        "holder": holder,
        "matchPercentage": matchPercentage,
        "message": message,
        "dob": dob,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class Financial {
  Financial({
    required this.verified,
    required this.files,
  });

  bool verified;
  List<String> files;

  factory Financial.fromJson(Map<String, dynamic> json) => Financial(
        verified: json["verified"] ?? false,
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class Gst {
  Gst({
    required this.verified,
    required this.files,
  });

  bool verified;
  List<String> files;

  factory Gst.fromJson(Map<String, dynamic> json) => Gst(
        verified: json["verified"] ?? false,
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}

class Mobile {
  Mobile({
    required this.verified,
    required this.status,
    required this.comment,
    required this.number,
    required this.countryCode,
    required this.holder,
    required this.address,
    required this.email,
  });

  bool verified;
  String status;
  String comment;
  String number;
  String countryCode;
  String holder;
  String address;
  String email;

  factory Mobile.fromJson(Map<String, dynamic> json) => Mobile(
        verified: json["verified"] ?? "",
        status: json["status"] ?? "",
        comment: json["comment"] ?? "",
        number: json["number"] ?? "",
        countryCode: json["countryCode"] ?? "",
        holder: json["holder"] ?? "",
        address: json["address"] ?? "",
        email: json["email"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "status": status,
        "comment": comment,
        "number": number,
        "countryCode": countryCode,
        "holder": holder,
        "address": address,
        "email": email,
      };
}

class Pan {
  Pan({
    required this.verified,
    required this.status,
    required this.comment,
    required this.holder,
    required this.number,
    required this.files,
  });

  bool verified;
  String status;
  String comment;
  String holder;
  String number;
  List<String> files;

  factory Pan.fromJson(Map<String, dynamic> json) => Pan(
        verified: json["verified"] ?? "",
        status: json["status"] ?? "",
        comment: json["comment"] ?? "",
        holder: json["holder"] ?? "",
        number: json["number"] ?? "",
        files: List<String>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "status": status,
        "comment": comment,
        "holder": holder,
        "number": number,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}
