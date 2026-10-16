import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PickedFileData {
  final Uint8List bytes;
  final String name;
  final bool isPdf;

  const PickedFileData({
    required this.bytes,
    required this.name,
    required this.isPdf,
  });
}

class FileUploadHelper {
  /// Picks a document file (image or PDF) from local storage.
  /// Works across Flutter Web, Windows Desktop, Android, and iOS.
  static Future<PickedFileData?> pickDocumentFile() async {
    // 1. Try FilePicker first: supports PDF and images natively on Web & Desktop
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        final isPdf = file.name.toLowerCase().endsWith('.pdf');
        return PickedFileData(bytes: bytes, name: file.name, isPdf: isPdf);
      }
    } catch (e) {
      debugPrint('FilePicker pickDocumentFile error: $e');
    }

    // 2. Fallback to ImagePicker (e.g. mobile gallery)
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (xFile != null) {
        final bytes = await xFile.readAsBytes();
        return PickedFileData(bytes: bytes, name: xFile.name, isPdf: false);
      }
    } catch (e) {
      debugPrint('ImagePicker pickDocumentFile error: $e');
    }

    return null;
  }

  /// Picks an image file from local storage / gallery.
  /// Works across Flutter Web, Windows Desktop, Android, and iOS.
  static Future<PickedFileData?> pickImageFile() async {
    // 1. Try ImagePicker first
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (xFile != null) {
        final bytes = await xFile.readAsBytes();
        return PickedFileData(bytes: bytes, name: xFile.name, isPdf: false);
      }
    } catch (e) {
      debugPrint('ImagePicker pickImageFile error: $e');
    }

    // 2. Fallback to FilePicker
    try {
      final file = await FilePicker.pickFile(
        type: FileType.image,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        return PickedFileData(bytes: bytes, name: file.name, isPdf: false);
      }
    } catch (e) {
      debugPrint('FilePicker pickImageFile error: $e');
    }

    return null;
  }
}
