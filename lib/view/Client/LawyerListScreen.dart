import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';

class LawyerListScreen extends StatefulWidget {
  @override
  _LawyerListScreenState createState() => _LawyerListScreenState();
}

class _LawyerListScreenState extends State<LawyerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hire Lawyer'),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset('images/Sidebar/ic_burger.svg')),
        ),
      ),
      drawer: SideBarView(),
      body: Container(),
    );
  }
}
