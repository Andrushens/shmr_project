import 'package:connectivity/connectivity.dart';

abstract class ConnectivityProvider {
  Future<bool> get isConnected;
}

class ConnectivityProviderImpl implements ConnectivityProvider {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> get isConnected {
    return _connectivity
        .checkConnectivity()
        .then((value) => value != ConnectivityResult.none);
  }
}
