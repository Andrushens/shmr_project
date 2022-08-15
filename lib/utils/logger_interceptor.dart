import 'package:dio/dio.dart';
import 'package:shmr/utils/const.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  LoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d(
      '**** API Request Start****\n\n'
      '${options.method} ${options.uri}\n\n'
      'Headers:\n'
      '${options.headers.entries.map((entry) => '\n    ${entry.key}: ${entry.value}${options.headers.entries.last.key == entry.key ? '\n' : ''}')}\n'
      'Body:\n'
      '    ${options.data ?? 'null'}\n\n'
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
    logger.i(
      '**** API Response Start ****\n\n'
      '${response.requestOptions.method} ${response.requestOptions.uri}\n'
      'Status code: ${response.statusCode}\n\n'
      '**** API Response End****',
    );
    handler.next(response);
  }
}
