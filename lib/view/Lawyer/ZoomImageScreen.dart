import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImageScreen extends StatefulWidget {
  String imgURL;

  ZoomImageScreen(this.imgURL);

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: NetworkImage(widget.imgURL),
    ));
  }
}
