import 'dart:io';
import 'package:flutter/foundation.dart';

void saveStringToStorage(String key, String value) {
  try {
    final tempDir = Directory.systemTemp;
    final file = File('${tempDir.path}/zalono_$key.txt');
    file.writeAsStringSync(value);
  } catch (e) {
    debugPrint('IO storage save error: $e');
  }
}

String? loadStringFromStorage(String key) {
  try {
    final tempDir = Directory.systemTemp;
    final file = File('${tempDir.path}/zalono_$key.txt');
    if (file.existsSync()) {
      return file.readAsStringSync();
    }
  } catch (e) {
    debugPrint('IO storage load error: $e');
  }
  return null;
}
