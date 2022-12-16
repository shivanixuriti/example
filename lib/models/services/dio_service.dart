import 'package:dio/dio.dart';

class DioClient {
  //final String baseUrl = "https://biz.xuriti.app/api";
  final String baseUrl = "https://uat.xuriti.app/api";

  postFormData(String url, FormData data, String? token) async {
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

        return response.data;
      }
    } catch (e) {
      print(e);
    }
  }

  post(String endUrl, Map<String, dynamic> data, String? token) async {
    var dio = Dio();
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
}
