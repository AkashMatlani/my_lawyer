import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_lawyer/generic_class/GenericButton.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:my_lawyer/utils/Constant.dart';
import 'package:my_lawyer/utils/FilePickerView.dart';
import 'package:my_lawyer/utils/DatePicker.dart';
import 'package:my_lawyer/view/Client/Create%20Case/CaseListScreen.dart';
import 'package:my_lawyer/view/Client/Create%20Case/CustomCaseScreen.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';

class CreateCaseScreen extends StatefulWidget {
  @override
  _CreateCaseScreenState createState() => _CreateCaseScreenState();
}

class _CreateCaseScreenState extends State<CreateCaseScreen> {
  var txtCasePortionController = TextEditingController();
  var txtRegistrationNoteController = TextEditingController();

  var selectedState;
  var selectedCounty;
  var selectedCaseType;
  var caseDate;
  var caseTime;
  var caseHiringDate;
  var isSelectedTermsCondition = false;
  var customCase = '';

  DateTime selectedCaseDate = DateTime.now();
  DateTime selectedHearingDate = DateTime.now();
  TimeOfDay selectedCaseTime = TimeOfDay(hour: 00, minute: 00);

  List<Map<String, dynamic>> selectedFilesList = [];
  List<Map<String, dynamic>> selectedCriminalCase = [];
  List<Map<String, dynamic>> selectedCivilCase = [];

  var stateList = [
    {'id': 1, 'name': 'Gujarat'},
    {'id': 1, 'name': 'Rajsthan'},
    {'id': 1, 'name': 'Gujarat'},
    {'id': 1, 'name': 'Panjab'},
    {'id': 1, 'name': 'Oddisha'},
    {'id': 1, 'name': 'MP'},
    {'id': 1, 'name': 'Mumbai'},
    {'id': 1, 'name': 'Gujarat'}
  ];

  var countyList = [
    {'id': 1, 'name': 'Gujarat'},
    {'id': 1, 'name': 'Rajsthan'},
    {'id': 1, 'name': 'Gujarat'},
    {'id': 1, 'name': 'Panjab'},
    {'id': 1, 'name': 'Oddisha'},
    {'id': 1, 'name': 'MP'},
    {'id': 1, 'name': 'Mumbai'},
    {'id': 1, 'name': 'Gujarat'}
  ];

  var caseTypeList = ['Criminal Case', 'Civil Case', 'Custom Case'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Case'),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset('images/Sidebar/ic_burger.svg')),
        ),
      ),
      drawer: SideBarView(),
      body: createCaseView(),
    );
  }

  Widget createCaseView() {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 247, 247, 1),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Form(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(34)),
                  child: dropDownTextField(
                      (selectedState == null)
                          ? 'Select state'
                          : selectedState['name'],
                      'State',
                      stateList,
                      true),
                ),
                Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(14)),
                    child: dropDownTextField(
                        (selectedCounty == null)
                            ? 'Select county'
                            : selectedCounty['name'],
                        'County',
                        countyList,
                        false)),
                txtFieldCaseType(),
                txtFieldCasePortion(),
                txtViewRegitrationNote(),
                txtFieldCaseDateAndTime(),
                caseHearingDateView(),
                attachmentView(),
                termsConditionView(),
                submitBtn()
              ],
            ),
          ),
        ));
  }

  Widget dropDownTextField(String placeholder, String title,
      List<Map<String, dynamic>> arrList, bool isState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        placeHolderText(title),
        Container(
          width: screenWidth(context),
          height: ScreenUtil().setHeight(46),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.ColorBorder),
              color: Colors.white),
          child: TextButton(
            onPressed: () {
              showBottomPicker(arrList, isState);
            },
            child: dropDownTextFieldAndArrow(placeholder),
          ),
        )
      ],
    );
  }

  Widget txtFieldCaseType() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          placeHolderText('Case Type'),
          Container(
              width: screenWidth(context),
              height: ScreenUtil().setHeight(46),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColor.ColorBorder),
                  color: Colors.white),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                      left: 10, right: 0, bottom: 0, top: 0),
                  hintText: 'Select Case Type',
                  hintStyle: appThemeTextStyle(14),
                ),
                items: caseTypeList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: appThemeTextStyle(14)),
                  );
                }).toList(),
                value: this.selectedCaseType,
                onChanged: (selectedCaseType) {
                  setState(() {
                    this.selectedCaseType = selectedCaseType;
                  });

                  switch (selectedCaseType) {
                    case 'Criminal Case':
                      navigateToCaseList(true);
                      break;

                    case 'Civil Case':
                      navigateToCaseList(false);
                      break;

                    case 'Custom Case':
                      navigateToCustomCaseScreen();
                      break;
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget txtFieldCasePortion() {
    return Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            placeHolderText('Case Portion'),
            SizedBox(
              height: ScreenUtil().setHeight(46),
              child: appThemeTextField('Enter Case Portion', TextInputType.name,
                  txtCasePortionController,
                  borderColor: AppColor.ColorBorder,
                  fontSize: 14,
                  fillColor: Colors.white,
                  filled: true),
            ),
          ],
        ));
  }

  Widget txtViewRegitrationNote() {
    return Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            placeHolderText('Registration Notes'),
            appThemeTextField('Write Your Registration Notes',
                TextInputType.name, txtRegistrationNoteController,
                maxLines: 4,
                borderColor: AppColor.ColorBorder,
                fontSize: 14,
                topPadding: 20,
                fillColor: Colors.white,
                filled: true)
          ],
        ));
  }

  Widget txtFieldCaseDateAndTime() {
    return Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            placeHolderText('Case Date and Time'),
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
                          padding:
                              EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent),
                                  ),
                                  onPressed: () {
                                    DatePicker()
                                        .selectDate('yyyy/MM/dd',
                                            selectedCaseDate, context)
                                        .then((selectedDate) => setState(() {
                                              caseDate =
                                                  selectedDate['selectedDate'];
                                              selectedCaseDate =
                                                  selectedDate['date'];
                                            }));
                                  },
                                  child: Text(
                                    (caseDate == null)
                                        ? 'YYYY/MM/DD'
                                        : caseDate,
                                    style: appThemeTextStyle(14),
                                  )),
                              SvgPicture.asset('images/Client/ic_calendar.svg')
                            ],
                          ),
                        )),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent),
                                  ),
                                  onPressed: () {
                                    DatePicker()
                                        .selectTime(context, selectedCaseTime)
                                        .then((selectedTime) => setState(() {
                                              caseTime =
                                                  selectedTime['selectedTime'];
                                              selectedCaseTime =
                                                  selectedTime['time'];
                                            }));
                                  },
                                  child: Text(
                                    (caseTime == null) ? 'HH:MM' : caseTime,
                                    style: appThemeTextStyle(14),
                                  )),
                              SvgPicture.asset('images/Client/ic_clock.svg')
                            ],
                          ),
                        ))
                  ],
                ))
          ],
        ));
  }

  Widget caseHearingDateView() {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        placeHolderText('Hearing Date'),
        Container(
          width: screenWidth(context),
          height: ScreenUtil().setHeight(46),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.ColorBorder),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent),
                  ),
                  onPressed: () {
                    DatePicker()
                        .selectDate('yyyy/MM/dd', selectedHearingDate, context)
                        .then((selectedDate) => setState(() {
                              caseHiringDate = selectedDate['selectedDate'];
                              selectedHearingDate = selectedDate['date'];
                            }));
                  },
                  child: Text(
                    (caseHiringDate == null) ? 'YYYY/MM/DD' : caseHiringDate,
                    style: appThemeTextStyle(14),
                  )),
              Padding(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: SvgPicture.asset('images/Client/ic_calendar.svg'),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget attachmentView() {
    return Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(14),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          placeHolderText('Attachment'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth(context) - ScreenUtil().setWidth(96),
                // Left-Right Padding+Add Btn (46+50),
                height: ScreenUtil().setHeight(46),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.ColorBorder),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'John Smith Case pdf, JPEG, PNG…',
                        style: appThemeTextStyle(14),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child:
                          SvgPicture.asset('images/Client/ic_attachment.svg'),
                    )
                  ],
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(46),
                height: ScreenUtil().setHeight(46),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(46) / 2),
                    border: Border.all(color: AppColor.ColorBorder),
                    color: Colors.white),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _pressedOnAddFile();
                  },
                ),
              ),
            ],
          )
        ]));
  }

  Widget termsConditionView() {
    return Row(
      children: [
        Checkbox(
            activeColor: AppColor.ColorRed,
            value: isSelectedTermsCondition,
            onChanged: (bool value) {
              setState(() {
                isSelectedTermsCondition = value;
              });
            }),
        Text(
          'Terms & Conditions',
          style: appThemeTextStyle(14, textColor: AppColor.ColorGray),
        ),
      ],
    );
  }

  Widget submitBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(24), bottom: ScreenUtil().setHeight(30)),
      child: SizedBox(
          width: screenWidth(context),
          height: ScreenUtil().setHeight(52),
          child: GenericButton()
              .appThemeButton('Submit', 16, Colors.white, FontWeight.w700, () {
            _pressedOnSubmit();
          }, borderRadius: 8)),
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

  Widget dropDownTextFieldAndArrow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: appThemeTextStyle(14),
        ),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColor.ColorArrow,
        )
      ],
    );
  }

  _pressedOnAddFile() {
    FilePickerView().openFilePicker().then((selectedFile) {
      setState(() {
        List<Map<String, dynamic>> files = selectedFile;
        selectedFilesList.add(files.first);
      });
    });
  }

  _pressedOnSubmit() {}

  navigateToCaseList(bool isCriminal) async {
    if (isCriminal)
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CaseListScreen('Criminal Cases', 0),
            fullscreenDialog: true),
      ).then((value) => selectedCriminalCase = value);
    else
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CaseListScreen('Civil Cases', 1),
            fullscreenDialog: true),
      ).then((value) => selectedCriminalCase = value);
  }

  navigateToCustomCaseScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomCaseScreen(), fullscreenDialog: true),
    ).then((value) => customCase = value);
  }

  showBottomPicker(List<Map<String, dynamic>> arrData, bool isState) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              height: ScreenUtil().setHeight(175),
              child: ListView.builder(
                  itemCount: arrData.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 35,
                            alignment: Alignment.center,
                            child: Text(
                              arrData[index]['name'],
                              style: appThemeTextStyle(16,
                                  textColor: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 0.5,
                            color: AppColor.ColorLightGray,
                          )
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          if (isState) {
                            selectedState = arrData[index];
                          } else {
                            selectedCounty = arrData[index];
                          }

                          Navigator.pop(context);
                        });
                      },
                    );
                  }),
            ),
          );
        });
  }
}
