import 'dart:io';
import 'dart:ui';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/service_locator.dart';

class DioClient {
  final String baseUrl = "https://biz.xuriti.app/api";

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

  KycDetails(String companyid) async {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    String endUrl = '/kyc/$companyid/status';
    String? token = getIt<SharedPreferences>().getString('token');
    dynamic companyId = getIt<SharedPreferences>().getString('companyId');

    String url = baseUrl + endUrl;
    final uri = Uri.parse(url);

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
      return e;
    }
  }

  aadhaar_captured_data(String endUrl, FormData data, String? token) async {
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
    String url = baseUrl + endUrl;
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);
        print('URL11111 -----> $url');
        return response.data;
      }
      if (token != null) {
        Response response = await dio.post(url,
            data: data,
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        if (response.statusCode == 200) {
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
        }
        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }
}
