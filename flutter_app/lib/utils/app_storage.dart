import 'app_storage_stub.dart'
    if (dart.library.html) 'app_storage_web.dart'
    if (dart.library.io) 'app_storage_io.dart';

class AppStorage {
  static void saveString(String key, String value) {
    saveStringToStorage(key, value);
  }

  static String? loadString(String key) {
    return loadStringFromStorage(key);
  }
}
