import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/DatePicker.dart';
import 'package:my_lawyer/view/Lawyer/CaseInfoView.dart';

class CaseDetailScreen extends StatefulWidget {
  @override
  _CaseDetailScreenState createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  var txtAmountController = TextEditingController();

  var timeToShowBid;
  var dateToShowBid;

  DateTime selectedDateToShowBid = DateTime.now();
  TimeOfDay selectedTimeToShowBid = TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Detail',
            style: appThemeTextStyle(20,
                fontWeight: FontWeight.w600, textColor: Colors.black)),
      ),
      body: caseDetailView(),
    );
  }

  Widget caseDetailView() {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
      child: ListView(
        children: [
          clientProfileAndName(),
          txtCaseDescription(),
          txtDescriptionView(),
          attachmentView(),
          Container(height: 1, color: Color.fromRGBO(151, 151, 151, 0.2)),
          txtFieldAmount(),
          dateToShowBidView(),
          timeToShowBidView(),
          sendProposalAndCancelBtn()
        ],
      ),
    ));
  }

  Widget clientProfileAndName() {
    return Row(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().setHeight(80) / 2),
        child: Image(
          image: AssetImage('images/Client/temp_ad1.jpeg'),
          fit: BoxFit.fill,
          width: ScreenUtil().setHeight(80),
          height: ScreenUtil().setHeight(80),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Miranda Gomes',
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
                      'Criminal',
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
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam dignissim, metus efficitur ullamcorper dictum, eros tellus gravida mi, in luctus turpis magna ac urna. Phasellus venenatis magna odio, at ultrices nisi pellentesque eget. Ut bibendum pulvinar egestas. Quisque non purus a lorem facilisis posuere vitae eu leo purus a lorem.',
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
                  TextInputType.name, txtAmountController,
                  borderColor: AppColor.ColorBorder,
                  fontSize: 14,
                  fillColor: Colors.white,
                  filled: true),
            ),
          ],
        ));
  }

  Widget attachmentView() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(20), bottom: ScreenUtil().setHeight(20)),
      child: Container(
        height: ScreenUtil().setHeight(70),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'my-criminal-case-detail.pdf',
                    style: appThemeTextStyle(14, textColor: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      '1.8 MB',
                      style: appThemeTextStyle(12,
                          textColor: Color.fromRGBO(0, 0, 0, 0.4)),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Download',
                          style: appThemeTextStyle(12,
                              fontWeight: FontWeight.w600,
                              textColor: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'View',
                          style: appThemeTextStyle(12,
                              fontWeight: FontWeight.w600,
                              textColor: Colors.black),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dateToShowBidView() {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        placeHolderText('Date'),
        Container(
            width: screenWidth(context),
            height: ScreenUtil().setHeight(46),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.ColorBorder),
                color: Colors.white),
            child: InkWell(
              onTap: () {
                DatePicker()
                    .selectDate('yyyy/MM/dd', selectedDateToShowBid, context)
                    .then((selectedDate) => setState(() {
                          dateToShowBid = selectedDate['selectedDate'];
                          selectedDateToShowBid = selectedDate['date'];
                        }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                      ),
                      child: Text(
                        (dateToShowBid == null) ? 'YYYY/MM/DD' : dateToShowBid,
                        style: appThemeTextStyle(14,
                            textColor: (dateToShowBid != null)
                                ? Colors.black
                                : AppColor.ColorGrayTextFieldHint),
                      )),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                    child: SvgPicture.asset('images/Client/ic_calendar.svg'),
                  )
                ],
              ),
            )),
      ]),
    );
  }

  Widget timeToShowBidView() {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        placeHolderText('Set Duration to Show Your Bid'),
        Container(
            width: screenWidth(context),
            height: ScreenUtil().setHeight(46),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.ColorBorder),
                color: Colors.white),
            child: InkWell(
              onTap: () {
                DatePicker()
                    .selectTime(context, selectedTimeToShowBid)
                    .then((selectedTime) => setState(() {
                          timeToShowBid = selectedTime['selectedTime'];
                          selectedTimeToShowBid = selectedTime['time'];
                        }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                      ),
                      child: Text(
                        (timeToShowBid == null)
                            ? 'Select Hours'
                            : timeToShowBid,
                        style: appThemeTextStyle(14,
                            textColor: (timeToShowBid != null)
                                ? Colors.black
                                : AppColor.ColorGrayTextFieldHint),
                      )),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                    child: SvgPicture.asset('images/Client/ic_clock.svg'),
                  )
                ],
              ),
            )),
      ]),
    );
  }

  Widget sendProposalAndCancelBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(32), bottom: ScreenUtil().setHeight(20)),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
                // width: screenWidth(context),
                height: ScreenUtil().setHeight(52),
                child: GenericButton().appThemeButton(
                    'Send Proposal', 16, Colors.white, FontWeight.w700, () {},
                    borderRadius: 6)),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
                // width: screenWidth(context),
                height: ScreenUtil().setHeight(52),
                child: GenericButton().appThemeButton(
                    'Cancel', 16, Colors.black, FontWeight.w700, () {},
                    borderRadius: 6, bgColor: AppColor.ColorGrayDottedLine)),
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
}
