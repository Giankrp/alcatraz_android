import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  late Dio _dio;
  late CookieJar _cookieJar;

  ApiClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? 'http://10.0.2.2:8080',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<void> init() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final String stackPath = '${appDocDir.path}/.cookies/';
    _cookieJar = PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage(stackPath),
    );
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Add logger interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('API: $obj'),
      ),
    );
  }

  Dio get dio => _dio;
  CookieJar get cookieJar => _cookieJar;

  Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
  }
}
