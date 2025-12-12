import 'package:flutter/material.dart';
import 'compare_status.dart';
import 'local_status.dart';
import 'status_main.dart';



class StatusTabbar extends StatelessWidget {
  const StatusTabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar:  const TabBar(
          padding: EdgeInsets.only(top: 20),
          tabs: <Widget>[
            //Tab(text: '시설 분석',),
            //Tab(text: '지역별 비교',),
            //Tab(text: '체육관별 비교',),
          ],
        ),
        body: const TabBarView(children: [
          //Center(child: SafeArea(child: StatusMainPage(),),),
          //Center(child: SafeArea(child: LocalStatusPage()),),
          Center(child: SafeArea(child: GymCompareStatPage()),),
          ],
        ),
      ),
    );
  }
}