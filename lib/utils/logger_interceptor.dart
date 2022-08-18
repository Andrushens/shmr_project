import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shmr/utils/const.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  final JsonEncoder encoder;
  final int maxLength;

  LoggingInterceptor()
      : encoder = const JsonEncoder.withIndent('     '),
        maxLength = 2048;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final formattedHeader = encoder.convert(options.headers);
    final formattedBody = encoder.convert(options.data);
    logger.d(
      '**** API Request Start****\n\n'
      '${options.method} ${options.uri}\n'
      'Headers: ${formattedHeader.length > maxLength ? 'HUGE OUTPUT(${formattedHeader.length} symbols)' : formattedHeader}\n'
      'Body: ${formattedBody.length > maxLength ? 'HUGE OUTPUT(${formattedBody.length} symbols)' : formattedBody}\n\n'
      '**** API Request End****',
    );
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e(
      '**** API Error Start ****\n\n'
      '${err.requestOptions.method} ${err.requestOptions.uri}\n'
      'Status code: ${err.response?.statusCode}\n'
      'Error: ${err.message}\n\n'
      '**** API Error End****',
    );
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final formattedData = encoder.convert(response.data);
    logger.i(
      '**** API Response Start ****\n\n'
      '${response.requestOptions.method} ${response.requestOptions.uri}\n'
      'Status code: ${response.statusCode}\n'
      'Data: ${formattedData.length > maxLength ? 'HUGE OUTPUT(${formattedData.length} symbols)' : formattedData}\n\n'
      '**** API Response End****',
    );
    handler.next(response);
  }
}
