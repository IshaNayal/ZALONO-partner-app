// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

void saveStringToStorage(String key, String value) {
  try {
    html.window.localStorage[key] = value;
  } catch (e) {
    debugPrint('Web storage save error: $e');
  }
}

String? loadStringFromStorage(String key) {
  try {
    return html.window.localStorage[key];
  } catch (e) {
    debugPrint('Web storage load error: $e');
    return null;
  }
}
