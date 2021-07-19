import 'package:flutter/material.dart';
import 'package:my_lawyer/utils/AppColors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(widget.imgURL),
            loadingBuilder: (context, event) {
              return Container(
                child: Center(
                    child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: AppColor.ColorRed,
                  ),
                )),
              );
            },
          ),
        ],
      ),
    );
  }
}
