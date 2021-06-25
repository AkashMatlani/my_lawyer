import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImagePickerView {
  Future<PickedFile> pickImage(ImageSource source) async {
    final image =
        await ImagePicker().getImage(source: source, imageQuality: 75);
    return image;
  }

  showChooseImagePicker(
      BuildContext context, Function tapOnGallery, Function tapOnCamera) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Choose from gallery'),
                      onTap: () {
                        tapOnGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Choose from camera'),
                      onTap: (){
                        tapOnCamera();
                        Navigator.of(context).pop();
                      })
                ],
              ),
            ),
          );
        });
  }
}
