import 'dart:async';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:io';

class PDFApi {
  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.isEmpty) return null;

    return File(result.files.single.path!);
  }

  static Future<void> uploadFirebase(
      String userId, String fileName, File file) async {
    String filePath = 'files/$userId/$fileName';

    await FirebaseStorage.instance.ref(filePath).putFile(file);
  }

  Future<void> downloadFile(String userId, String fileName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference ref = storage.ref().child('files/$userId/$fileName');

    try {
      // Get the download URL of the file
      final String downloadURL = await ref.getDownloadURL();

      // Get the app's temporary directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // Create a File object with the desired file name
      File file = File('$appDocPath/$fileName');

      // Download the file to the device
      await ref.writeToFile(file);

      print('File downloaded to: ${file.path}');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }
}
