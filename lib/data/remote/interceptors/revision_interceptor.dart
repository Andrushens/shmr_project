import 'package:dio/dio.dart';
import 'package:shmr/service/shared_provider.dart';
import 'package:shmr/utils/const.dart';

class RevisionInterceptor extends InterceptorsWrapper {
  RevisionInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final localRevision = SharedProvider.getLocalRevision();
    options.headers[ConstRemote.revisionHeader] = localRevision;
    //don't increase revision on GET api/list
    if (options.method != ConstRemote.methodGet ||
        options.path != ConstRemote.fetchTasksPath) {
      await SharedProvider.setLocalRevision(revision: localRevision + 1);
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final remoteRevision = data[ConstRemote.revisionField] as int;
      final localRevision = SharedProvider.getLocalRevision();
      await SharedProvider.setRemoteRevision(revision: remoteRevision);
      final options = response.requestOptions;
      if (localRevision == 0 ||
          (options.method == ConstRemote.methodPatch &&
              options.path == ConstRemote.patchTasksPath)) {
        await SharedProvider.setLocalRevision(revision: remoteRevision);
      }
    }
    super.onResponse(response, handler);
  }
}
