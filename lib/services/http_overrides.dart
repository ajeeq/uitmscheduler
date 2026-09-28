import 'dart:io';

/// A helper class to handle SSL certificate overrides.
/// 
/// ⚠️ WARNING: Bypassing bad certificate validation makes the app 
/// vulnerable to Man-in-the-Middle attacks. Use this ONLY for local 
/// development and staging environments.
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }

  /// Global initializer to quickly apply the bypass across the app.
  static void init() {
    HttpOverrides.global = DevHttpOverrides();
  }
}
