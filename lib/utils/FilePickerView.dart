import 'dart:core';
import 'package:file_picker/file_picker.dart';

class FilePickerView {

  Future<dynamic> openFilePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'doc', 'png'],
        allowMultiple: false);

    List<Map<String, dynamic>> fileList = [];

    if (result != null) {
      for (PlatformFile file in result.files) {
        // PlatformFile platformFile = file;
        Map<String, dynamic> fileInfo = {
          'name': file.name,
          'extension': file.extension,
          'path': file.path
        };
        fileList.add(fileInfo);
      }

      return fileList;
    } else {
      // User canceled the picker
    }
  }
}