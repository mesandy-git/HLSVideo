import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:hls_video_player/constant/weburl.dart';

class ServiceHttp {
  final Dio _dio = Dio();
  final String _apiUrl = WebUrl.baseUrl;

  ServiceHttp() {
    _dio.options.baseUrl = _apiUrl;
    // Configure Dio to accept self-signed certificates (for development only)
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return client;
      },
    );
    _dio.interceptors.add(
      LogInterceptor(
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );
  }

  Future<dynamic> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      // log(response.data);
      return response.data;
    } on DioException catch (error) {
      log('${error.response}');
    }
  }
}
