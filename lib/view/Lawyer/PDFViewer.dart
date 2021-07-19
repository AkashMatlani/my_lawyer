import 'package:flutter/material.dart';
import 'package:my_lawyer/utils/AppColors.dart';

// import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PDFViewerScreen extends StatefulWidget {
  String pdfURL;

  PDFViewerScreen(this.pdfURL);

  @override
  PDFViewerScreenState createState() => PDFViewerScreenState();
}

class PDFViewerScreenState extends State<PDFViewerScreen> {
  num position = 1;

  final key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('')),
        body:  WebView(initialUrl: 'http://drive.google.com/viewerng/viewer?embedded=true&url=${widget.pdfURL}',)
        // IndexedStack(index: position, children: <Widget>[
        //   WebView(
        //     initialUrl: widget.pdfURL,
        //     // javascriptMode: JavascriptMode.unrestricted,
        //     // key: key ,
        //     onPageFinished: doneLoading,
        //     onPageStarted: startLoading,
        //   ),
        //   Container(
        //     color: Colors.white,
        //     child: Center(
        //       child: CircularProgressIndicator(
        //         strokeWidth: 1,
        //         color: AppColor.ColorRed,
        //       ),
        //     ),
        //   ),
        // ])

        // WebView(
        //   initialUrl: (widget.pdfURL),
        //   onProgress: (int progress) {
        //     return Container(
        //       child: Center(
        //           child: SizedBox(
        //             width: 35,
        //             height: 35,
        //             child: CircularProgressIndicator(
        //               strokeWidth: 1,
        //               color: AppColor.ColorRed,
        //             ),
        //           )),
        //     );
        //   },
        // )

        );
  }

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }
}
