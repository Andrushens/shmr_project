import 'package:dio/dio.dart';
import 'package:shmr/data/local/local_source.dart';
import 'package:shmr/service/shared_provider.dart';
import 'package:shmr/utils/const.dart';

class PatchInterceptor extends InterceptorsWrapper {
  PatchInterceptor(this.dio, this.localSource);

  final Dio dio;
  final LocalSource localSource;

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final localRevision = SharedProvider.getLocalRevision();
    final remoteRevision =
        err.requestOptions.headers[ConstRemote.revisionHeader] as int;
    final response = err.response;
    if (response != null &&
        response.statusCode == 400 &&
        remoteRevision != localRevision) {
      await patchTasks();
      return handler.resolve(await retryRequest(response.requestOptions));
    }
    super.onError(err, handler);
  }

  Future<void> patchTasks() async {
    final dbTasks = await localSource.fetchTasks();
    final tasksMaps = dbTasks.map((e) => e.toJson()).toList();
    await dio.patch<Map<String, dynamic>>(
      ConstRemote.patchTasksPath,
      data: {
        ConstRemote.listField: tasksMaps,
      },
    );
  }

  Future<Response<dynamic>> retryRequest(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
