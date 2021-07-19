import 'dart:typed_data';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;

Future<bool> downloadFile(
    String url, String filename, BuildContext context) async {
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  var status = await Permission.storage.status;
  if (status.isGranted) {
    if (io.Platform.isIOS) {
      String folderName = "MyLawyer";
      createFolderInAppDocDir(folderName).then((value) async {
        print(value + filename);
        File file = new File('$value$filename');
        print('File Path - $file');
        AlertView().showToast(context, 'File downloaded successfully.');
        await file.writeAsBytes(bytes);
        return false;
      });
      // print("temp folder"+temp.toString());
      /*io.Directory appDocDirectory;
      appDocDirectory = await getApplicationDocumentsDirectory();*/
      /* Directory directory =
          await new Directory(appDocDirectory.path + '/' + 'Download')
              .create(recursive: true);*/
      /*  final Directory _appDocDir = await getApplicationDocumentsDirectory();
     //App Document Directory + folder name
     final Directory _appDocDirFolder =
     Directory('${_appDocDir.path}/$folderName/');

     if (await _appDocDirFolder.exists()) {

       //if folder already exists return path
       return _appDocDirFolder.path;
     } else {
       //if folder not exists create folder and then return its path
       final Directory _appDocDirNewFolder =
       await _appDocDirFolder.create(recursive: true);

       return _appDocDirNewFolder.path;
     }
*/

      /*  new Directory('MyLawyer').create(recursive: true)
      // The created directory is returned as a Future.
          .then((Directory directory) async {
        print(directory.path);
        String path = directory.path.toString();
        File file = new File('$path/$filename');
        print('File Path - $file');
        AlertView().showToast(context, 'File downloaded successfully.');
        await file.writeAsBytes(bytes);
        return file;*/
      //});

    } else {
      String path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      File file = new File('$path/$filename');
      print('File Path android - ${file.path}');
      AlertView().showToast(context, 'File downloaded successfully.');
      await file.writeAsBytes(bytes);
      return false;
    }
  } else {
    Map<Permission, PermissionStatus> status = await [
      Permission.storage,
    ].request();
    print("Permission status :: $status");
  }
}
//
// Future<String> getExternalStoragePublicDirectory() async {
//   if (!Platform.isAndroid) {
//     throw UnsupportedError("Only android supported");
//   }
//   return await MethodChannel('ext_storage')
//       .invokeMethod('getExternalStoragePublicDirectory', {"type": 'Documents'});
// }

// var imageUrl =
//     "https://www.itl.cat/pngfile/big/10-100326_desktop-wallpaper-hd-full-screen-free-download-full.jpg";
// bool downloading = true;
// String downloadingStr = "No data";
// String savePath = "";

// downloadFile(String url, String filename, BuildContext context) async {
//   var request = new http.Request('GET', Uri.parse(url)).send();
//   String dir = (await getApplicationDocumentsDirectory()).path + '/Download';
//
//   List<List<int>> chunks = [];
//   int downloaded = 0;
//
//   request.asStream().listen((http.StreamedResponse response) {
//     response.stream.listen((List<int> chunk) {
//       // Display percentage of completion
//       print('downloadPercentage: ${downloaded / response.contentLength * 100}');
//
//       chunks.add(chunk);
//       downloaded += chunk.length;
//     }, onDone: () async {
//       // Display percentage of completion
//       print('downloadPercentage: ${downloaded / response.contentLength * 100}');
//
//       // Save the file
//       File file = new File('$dir/$filename');
//       print('File Path - ${file.path}');
//       final Uint8List bytes = Uint8List(response.contentLength);
//       int offset = 0;
//       for (List<int> chunk in chunks) {
//         bytes.setRange(offset, offset + chunk.length, chunk);
//         offset += chunk.length;
//       }
//       await file.writeAsBytes(bytes);
//       AlertView().showToast(context, 'File downloaded successfully.');
//       return;
//     });
//   });
// }

Future<String> createFolderInAppDocDir(String folderName) async {
  //Get this App Document Directory

  final Directory _appDocDir = await getApplicationDocumentsDirectory();
  //App Document Directory + folder name
  final Directory _appDocDirFolder =
      Directory('${_appDocDir.path}/$folderName/');

  print('Directory - ${_appDocDirFolder.path}');
  if (await _appDocDirFolder.exists()) {
    //if folder already exists return path
    print('_appDocDirFolder.exists()');
    return _appDocDirFolder.path;
  } else {
    //if folder not exists create folder and then return its path
    print('Else _appDocDirFolder');
    final Directory _appDocDirNewFolder =
        await _appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }
}
