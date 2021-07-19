import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/bloc/Lawyer/CaseDetailBloc.dart';
import 'package:my_lawyer/bloc/Lawyer/SendProposalBloc.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/models/CaseDetailModel.dart';
import 'package:my_lawyer/models/CaseTypeListModel.dart';
import 'package:my_lawyer/networking/APIResponse.dart';
import 'package:my_lawyer/utils/Alertview.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/AppMessages.dart';
import 'package:my_lawyer/utils/CommonStuff.dart';
import 'package:my_lawyer/utils/CommonWidgets.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/DatePicker.dart';
import 'package:my_lawyer/utils/DownloadFile.dart';
import 'package:my_lawyer/utils/LoadingView.dart';
import 'package:my_lawyer/utils/NetworkImage.dart';
import 'package:my_lawyer/view/Lawyer/CaseInfoView.dart';
import 'package:my_lawyer/view/Lawyer/PDFViewer.dart';
import 'package:my_lawyer/view/Lawyer/ZoomImageScreen.dart';
import 'package:path/path.dart' as path;

class CaseDetailScreen extends StatefulWidget {
  int caseId;

  CaseDetailScreen(this.caseId);

  @override
  _CaseDetailScreenState createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  var txtAmountController = TextEditingController();

  var strStartTimeToShowBid;
  var strEndTimeToShowBid;
  var strStartDateToShowBid;
  var strEndDateToShowBid;
  bool isDownloading = false;

  DateTime selectedStartDateToShowBid = DateTime.now();
  DateTime selectedEndDateToShowBid = DateTime.now();
  TimeOfDay selectedStartTimeToShowBid = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTimeToShowBid = TimeOfDay(hour: 00, minute: 00);

  SendProposalBloc sendProposalBloc;
  CaseDetailBloc caseDetailBloc;
  CaseDetailModel caseDetailModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    caseDetailBloc = CaseDetailBloc();
    sendProposalBloc = SendProposalBloc();
    getCaseDetailAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Detail',
            style: appThemeTextStyle(20,
                fontWeight: FontWeight.w600, textColor: Colors.black)),
      ),
      body: caseDetailStreamBuilder(),
    );
  }

  Widget caseDetailStreamBuilder() {
    return Container(
        child: StreamBuilder(
            stream: caseDetailBloc.caseDetailStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.Loading:
                    {
                      return Center(
                        child: LoadingView().loader(),
                      );
                    }
                    break;

                  case Status.Done:
                    {
                      caseDetailModel = snapshot.data.data;
                      return caseDetailView();
                    }

                  case Status.Error:
                    AlertView()
                        .showAlertView(context, snapshot.data.message, () {});
                }
              } else {
                return showLoaderInList();
              }
            }));
  }

  Widget caseDetailView() {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
      child: ListView(
        children: [
          clientProfileAndName(),
          txtCaseDescription(),
          txtDescriptionView(),
          for (dynamic attachInfo in caseDetailModel.attachment)
            attachmentView(attachInfo),
          Container(height: 1, color: Color.fromRGBO(151, 151, 151, 0.2)),
          txtFieldAmount(),
          bidStartDateAndTime(),
          bidEndDateAndTime(),
          sendProposalAndCancelBtn()
        ],
      ),
    );
  }

  Widget clientProfileAndName() {
    return Row(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtil().setHeight(80) / 2),
          child: (caseDetailModel.clientProfile == '')
              ? Image(
                  image: AssetImage('images/Client/ic_profile.jpeg'),
                  fit: BoxFit.fill,
                  width: ScreenUtil().setHeight(80),
                  height: ScreenUtil().setHeight(80),
                )
              : ImageNetwork().loadNetworkImage(
                  caseDetailModel.clientProfile, ScreenUtil().setHeight(80))),
      Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                caseDetailModel.clientName,
                style: appThemeTextStyle(17,
                    fontWeight: FontWeight.w700, textColor: Colors.black),
              ),
              Padding(
                padding: EdgeInsets.only(top: 7),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(211, 255, 211, 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      caseDetailModel.caseType,
                      textAlign: TextAlign.center,
                      style: appThemeTextStyle(13,
                          fontWeight: FontWeight.w600,
                          textColor: Color.fromRGBO(2, 165, 64, 1)),
                    ),
                  ),
                ),
              )
            ]),
      )
    ]);
  }

  Widget txtCaseDescription() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(13)),
      child: Text(
        'Case Discription',
        style: appThemeTextStyle(17,
            fontWeight: FontWeight.w700, textColor: Colors.black),
      ),
    );
  }

  Widget txtDescriptionView() {
    return Text(
      caseDetailModel.description,
      style: appThemeTextStyle(14, textColor: Colors.black, height: 2),
    );
  }

  Widget txtFieldAmount() {
    return Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            placeHolderText('Amount'),
            SizedBox(
              height: ScreenUtil().setHeight(46),
              child: appThemeTextField('Enter Your Bid Amount',
                  TextInputType.number, txtAmountController,
                  borderColor: AppColor.ColorBorder,
                  fontSize: 14,
                  fillColor: Colors.white,
                  filled: true),
            ),
          ],
        ));
  }

  Widget attachmentView(String attachURL) {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(20), bottom: ScreenUtil().setHeight(20)),
      child: Container(
        decoration: BoxDecoration(
            color: AppColor.ColorAttachmentGray,
            borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            Container(
              width: ScreenUtil().setWidth(64),
              height: ScreenUtil().setHeight(70),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 117, 80, 1),
                  borderRadius: BorderRadius.circular(6)),
              child: SvgPicture.asset('images/Lawyer/ic_pdf.svg'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getFileNameFromURL(attachURL),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appThemeTextStyle(12, textColor: Colors.black),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        '',
                        style: appThemeTextStyle(12,
                            textColor: Color.fromRGBO(0, 0, 0, 0.4)),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              if (!isDownloading) {
                                setState(() {
                                  isDownloading = true;
                                });
                                downloadFile(attachURL,
                                        getFileNameFromURL(attachURL), context)
                                    .then((isProcessing) => setState(() {
                                          isDownloading = false;
                                        }));
                              }
                            },
                            child: SizedBox(
                              height: ScreenUtil().setHeight(20),
                              child: Text(
                                isDownloading ? 'Downloading...' : 'Download',
                                style: appThemeTextStyle(12,
                                    fontWeight: FontWeight.w600,
                                    textColor: Colors.black),
                              ),
                            )),
                        SizedBox(
                          width: 30,
                        ),
                        InkWell(
                            onTap: () {
                              // html.window.open(attachURL, 'name');
                              _pressedOnViewFile(attachURL);
                            },
                            child: SizedBox(
                              height: ScreenUtil().setHeight(20),
                              child: Text(
                                'View',
                                style: appThemeTextStyle(12,
                                    fontWeight: FontWeight.w600,
                                    textColor: Colors.black),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bidStartDateAndTime() {
    return Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            placeHolderText('Set Start Duration to Show Your Bid'),
            Container(
                width: screenWidth(context),
                height: ScreenUtil().setHeight(46),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.ColorBorder),
                    color: Colors.white),
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.only(
                                right: ScreenUtil().setWidth(15)),
                            child: InkWell(
                              onTap: () {
                                DatePicker()
                                    .selectDate('yyyy/MM/dd',
                                        selectedStartDateToShowBid, context)
                                    .then((selectedDate) => setState(() {
                                          strStartDateToShowBid =
                                              selectedDate['selectedDate'];
                                          selectedStartDateToShowBid =
                                              selectedDate['date'];
                                        }));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.transparent),
                                      ),
                                      child: Text(
                                        (strStartDateToShowBid == null)
                                            ? 'YYYY/MM/DD'
                                            : strStartDateToShowBid,
                                        style: appThemeTextStyle(14,
                                            textColor: (strStartDateToShowBid !=
                                                    null)
                                                ? Colors.black
                                                : AppColor
                                                    .ColorGrayTextFieldHint),
                                      )),
                                  SvgPicture.asset(
                                      'images/Client/ic_calendar.svg')
                                ],
                              ),
                            ))),
                    Container(
                      width: 1,
                      height: ScreenUtil().setHeight(28),
                      decoration: BoxDecoration(color: AppColor.ColorBorder),
                    ),
                    SizedBox(
                        width: ScreenUtil().setWidth(130),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15),
                                right: ScreenUtil().setWidth(20)),
                            child: InkWell(
                              onTap: () {
                                DatePicker()
                                    .selectTime(
                                        context, selectedStartTimeToShowBid)
                                    .then((selectedTime) => setState(() {
                                          strStartTimeToShowBid =
                                              selectedTime['selectedTime'];
                                          selectedStartTimeToShowBid =
                                              selectedTime['time'];
                                        }));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.transparent),
                                      ),
                                      child: Text(
                                        (strStartTimeToShowBid == null)
                                            ? 'HH:MM'
                                            : strStartTimeToShowBid,
                                        style: appThemeTextStyle(14,
                                            textColor: (strStartTimeToShowBid !=
                                                    null)
                                                ? Colors.black
                                                : AppColor
                                                    .ColorGrayTextFieldHint),
                                      )),
                                  SvgPicture.asset('images/Client/ic_clock.svg')
                                ],
                              ),
                            )))
                  ],
                ))
          ],
        ));
  }

  Widget bidEndDateAndTime() {
    return Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            placeHolderText('Set End Duration to Show Your Bid'),
            Container(
                width: screenWidth(context),
                height: ScreenUtil().setHeight(46),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.ColorBorder),
                    color: Colors.white),
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.only(
                                right: ScreenUtil().setWidth(15)),
                            child: InkWell(
                              onTap: () {
                                DatePicker()
                                    .selectDate('yyyy/MM/dd',
                                        selectedEndDateToShowBid, context)
                                    .then((selectedDate) => setState(() {
                                          strEndDateToShowBid =
                                              selectedDate['selectedDate'];
                                          selectedEndDateToShowBid =
                                              selectedDate['date'];
                                        }));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.transparent),
                                      ),
                                      child: Text(
                                        (strEndDateToShowBid == null)
                                            ? 'YYYY/MM/DD'
                                            : strEndDateToShowBid,
                                        style: appThemeTextStyle(14,
                                            textColor: (strEndDateToShowBid !=
                                                    null)
                                                ? Colors.black
                                                : AppColor
                                                    .ColorGrayTextFieldHint),
                                      )),
                                  SvgPicture.asset(
                                      'images/Client/ic_calendar.svg')
                                ],
                              ),
                            ))),
                    Container(
                      width: 1,
                      height: ScreenUtil().setHeight(28),
                      decoration: BoxDecoration(color: AppColor.ColorBorder),
                    ),
                    SizedBox(
                        width: ScreenUtil().setWidth(130),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15),
                                right: ScreenUtil().setWidth(20)),
                            child: InkWell(
                              onTap: () {
                                DatePicker()
                                    .selectTime(
                                        context, selectedEndTimeToShowBid)
                                    .then((selectedTime) => setState(() {
                                          strEndTimeToShowBid =
                                              selectedTime['selectedTime'];
                                          selectedEndTimeToShowBid =
                                              selectedTime['time'];
                                        }));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.transparent),
                                      ),
                                      child: Text(
                                        (strEndTimeToShowBid == null)
                                            ? 'HH:MM'
                                            : strEndTimeToShowBid,
                                        style: appThemeTextStyle(14,
                                            textColor: (strEndTimeToShowBid !=
                                                    null)
                                                ? Colors.black
                                                : AppColor
                                                    .ColorGrayTextFieldHint),
                                      )),
                                  SvgPicture.asset('images/Client/ic_clock.svg')
                                ],
                              ),
                            )))
                  ],
                ))
          ],
        ));
  }

  Widget sendProposalAndCancelBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(32), bottom: ScreenUtil().setHeight(20)),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
                height: ScreenUtil().setHeight(52),
                child: GenericButton().appThemeButton(
                    'Send Proposal', 16, Colors.white, FontWeight.w700, () {
                  _pressedOnSendProposal();
                }, borderRadius: 6)),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
                height: ScreenUtil().setHeight(52),
                child: GenericButton().appThemeButton(
                    'Cancel', 16, Colors.black, FontWeight.w700, () {
                  Navigator.pop(context);
                }, borderRadius: 6, bgColor: AppColor.ColorGrayDottedLine)),
          )
        ],
      ),
    );
  }

  Widget placeHolderText(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: appThemeTextStyle(14,
            fontWeight: FontWeight.w600, textColor: Colors.black),
      ),
    );
  }

  _pressedOnSendProposal() {
    if (txtAmountController.text.isEmpty) {
      AlertView().showAlert(Messages.CBlankAmount, context);
      return;
    } else if (strStartDateToShowBid == null) {
      AlertView().showAlert(Messages.CBlankStartDate, context);
      return;
    } else if (strStartTimeToShowBid == null) {
      AlertView().showAlert(Messages.CBlankStartTime, context);
      return;
    } else if (strEndDateToShowBid == null) {
      AlertView().showAlert(Messages.CBlankEndDate, context);
      return;
    } else if (strEndTimeToShowBid == null) {
      AlertView().showAlert(Messages.CBlankEndTime, context);
      return;
    }

    sendProposalAPI();
  }

  getCaseDetailAPI() {
    caseDetailBloc.getCaseDetail(widget.caseId);
  }

  sendProposalAPI() {
    Map<String, dynamic> params = {
      'caseId': widget.caseId.toString(),
      'amount': txtAmountController.text,
      'bidStartDateTime': '$strStartDateToShowBid $strStartTimeToShowBid',
      'bidEndDateTime': '$strEndDateToShowBid $strEndTimeToShowBid'
    };

    LoadingView().showLoaderWithTitle(true, context);
    sendProposalBloc.sendProposalToClient(params);

    sendProposalBloc.sendProposalStream.listen((snapshot) {
      switch (snapshot.status) {
        case Status.Loading:
          return LoadingView(loadingMessage: snapshot.message);

        case Status.Done:
          LoadingView().showLoaderWithTitle(false, context);

          if (snapshot.data['meta']['status'] == 1) {
            AlertView().showToast(context, Messages.CSentProposal);
            Navigator.pop(context);
          } else {
            AlertView().showAlertView(context, snapshot.data['meta']['message'],
                () => {Navigator.of(context).pop()});
          }
          break;

        case Status.Error:
          LoadingView().showLoaderWithTitle(false, context);
          AlertView().showAlertView(
              context, snapshot.message, () => {Navigator.of(context).pop()});
          break;
      }
    });
  }

  _pressedOnViewFile(String attachURL) {
    final extension = path.extension(attachURL); // '.dart'

    if (extension == '.pdf') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PDFViewerScreen(
                    attachURL,
                  ),
              fullscreenDialog: true));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ZoomImageScreen(attachURL),
              fullscreenDialog: true));
    }
  }
}
