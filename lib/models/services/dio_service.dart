import 'dart:io';
import 'dart:ui';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

class DioClient {
  final String baseUrl = "https://biz.xuriti.app/api";
  // final String baseUrl = "https://dev.xuriti.app/api";
  // final String baseUrl = "https://uat.xuriti.app/api";

  postFormData(String endUrl, FormData data, String? token) async {
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 120 * 1000 // 60 seconds
        );
    String url = baseUrl + endUrl;
    var dio = Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);

        return response.data;
      }
      if (token != null) {
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));

        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  post(String endUrl, Map<String, dynamic> data, String? token) async {
    var dio = Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String url = baseUrl + endUrl;
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);
        return response.data;
      }
      if (token != null) {
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        return response.data;
      }
    } catch (e) {}
  }

  get(String endUrl, {String? token}) async {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String url = baseUrl + endUrl;
    try {
      print(token.toString());
      if (token == null) {
        Response response = await dio.get(url);
        return response.data;
      }
      if (token != null) {
        Response response = await dio.get(url,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        return response.data;
      }
    } catch (e) {
      // print(e);
    }
  }

  put(endUrl, data, {String? token}) async {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String url = baseUrl + endUrl;
    try {
      if (token == null) {
        Response response = await dio.put(url, data: data);
        return response.data;
      }
      if (token != null) {
        Response response = await dio.put(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        return response.data;
      }
    } catch (e) {}
  }

  Future<dynamic> patch(endUrl, data, {String? token}) async {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String url = baseUrl + endUrl;

    try {
      if (token == null) {
        Response response = await dio.patch(url, data: data);
        return response.data;
      }

      if (token != null) {
        Response response = await dio.patch(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        return response.data;
      }
    } catch (e) {}
  }

  // download(link, String fileName) async {
  //   String savePath = await getIt<TransactionManager>().getFilePath(fileName);
  //   var dio = Dio();
  // try{
  //   Response response = await dio.download(link, savePath);
  //   return response.statusCode;
  // }catch (e){
  //   print(e);
  // }
  //
  // }

  aadhaar_captured_data(String url, FormData data, String? token) async {
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 120 * 1000 // 60 seconds
        );
    var dio = Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //String url = baseUrl + endUrl;
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);

        return response.data;
      }
      if (token != null) {
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: 'Aadhaar api successful....',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Color.fromARGB(255, 253, 153, 33),
              textColor: Colors.white,
              fontSize: 12.0);
        }
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  pan_captured_data(String url, FormData data, String? token) async {
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 120 * 1000 // 60 seconds
        );
    var dio = Dio(options);

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);

        return response.data;
      }
      if (token != null) {
        print('=== $url $token $data');
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          // Fluttertoast.showToast(
          //     msg: 'Pan api successful....',
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 3,
          //     backgroundColor: Color.fromARGB(255, 253, 153, 33),
          //     textColor: Colors.white,
          //     fontSize: 12.0);
        }
        print(response);
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  // pan verify
  verify_pan(String url, FormData data, String? token) async {
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 120 * 1000 // 60 seconds
        );
    var dio = Dio(options);

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);

        return response.data;
      }
      if (token != null) {
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: 'Pan api successful....',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Color.fromARGB(255, 253, 153, 33),
              textColor: Colors.white,
              fontSize: 12.0);
        }
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  mobile_verfication(String url, Object data, String? token) async {
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 120 * 1000 // 60 seconds
        );
    var dio = Dio(options);
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);

        return response.data;
      }
      if (token != null) {
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: 'generate otp successful....',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Color.fromARGB(255, 253, 153, 33),
              textColor: Colors.white,
              fontSize: 12.0);
        }
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  otp_verfication(String url, Object data, String? token) async {
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 120 * 1000 // 60 seconds
        );
    var dio = Dio(options);
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);

        return response.data;
      }
      if (token != null) {
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: 'otp verified successful....',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Color.fromARGB(255, 253, 153, 33),
              textColor: Colors.white,
              fontSize: 12.0);
        }
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  getCaptcha(String endUrl, {String? token}) async {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String url = baseUrl + endUrl;
    try {
      print(token.toString());
      if (token == null) {
        Response response = await dio.get(url);
        return response.data;
      }
      if (token != null) {
        Response response = await dio.get(url,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        return response.data;
      }
    } catch (e) {
      // print(e);
    }
  }

  aadhaar_otp(String url, Object data, String? token) async {
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 120 * 1000 // 60 seconds
        );
    var dio = Dio(options);
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);

        return response.data;
      }
      if (token != null) {
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          // Fluttertoast.showToast(
          //     msg: 'otp verified successful....',
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 3,
          //     backgroundColor: Color.fromARGB(255, 253, 153, 33),
          //     textColor: Colors.white,
          //     fontSize: 12.0);
        }
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  aadhaar_otp_verify(String url, Object data, String? token) async {
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 120 * 1000 // 60 seconds
        );
    var dio = Dio(options);
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);

        return response.data;
      }
      if (token != null) {
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
          print("OTP Verified...");
          // Fluttertoast.showToast(
          //     msg: 'otp verified successful....',
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 3,
          //     backgroundColor: Color.fromARGB(255, 253, 153, 33),
          //     textColor: Colors.white,
          //     fontSize: 12.0);
        }
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }
}
