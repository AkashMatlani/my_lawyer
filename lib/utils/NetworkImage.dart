import 'package:flutter/material.dart';
import 'package:my_lawyer/utils/AppColors.dart';

class ImageNetwork {
  Widget loadNetworkImage(String imgURL, double width) {
    return Image.network(
      imgURL,
      fit: BoxFit.fill,
      width: width,
      height: width,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          width: width,
          height: width,
          child: Center(
              child: SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 0.5,
                  color: AppColor.ColorRed,
                ),
              )),
        );
      },
    );
  }
}
