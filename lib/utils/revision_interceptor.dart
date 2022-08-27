import 'package:dio/dio.dart';
import 'package:shmr/utils/const.dart';

class RevisionInterceptor extends InterceptorsWrapper {
  RevisionInterceptor(this.dio);

  final Dio dio;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final revision = data[ConstRemote.revisionField];
      dio.options.headers[ConstRemote.revisionHeader] = revision;
    }
    super.onResponse(response, handler);
  }
}
