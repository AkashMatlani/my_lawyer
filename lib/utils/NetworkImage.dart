import 'package:flutter/material.dart';
import 'package:my_lawyer/utils/AppColors.dart';

class ImageNetwork {
  Widget loadNetworkImage(String imgURL) {
    return Image.network(
      imgURL,
      fit: BoxFit.fill,

      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
            child: SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(
            strokeWidth: 0.5,
            color: AppColor.ColorRed,
            // value: loadingProgress.expectedTotalBytes != null
            //     ? loadingProgress.cumulativeBytesLoaded /
            //         loadingProgress.expectedTotalBytes
            //     : null,
          ),
        ));
      },
    );
  }
}
