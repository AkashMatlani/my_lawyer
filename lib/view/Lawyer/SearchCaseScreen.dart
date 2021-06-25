import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_lawyer/view/Sidebar/SideBarView.dart';

class SearchCasesScreen extends StatefulWidget {
  @override
  _SearchCasesScreenState createState() => _SearchCasesScreenState();
}

class _SearchCasesScreenState extends State<SearchCasesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Case'),
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
