import 'package:flutter/material.dart';
import '../viewmodel/local_data.dart';
import '../view/human_categories_status_widget.dart';
import '../view/human_categories_widget.dart';
import 'package:go_router/go_router.dart';

class FacilitiesStatusPage extends StatefulWidget {
  //시설분석통계창
  const FacilitiesStatusPage({super.key});

  @override
  State<FacilitiesStatusPage> createState() => _FacilitiesStatusPageState();
}

class _FacilitiesStatusPageState extends State<FacilitiesStatusPage> {
  String data = "";

  void getData(){
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E7EB),
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                context.go('/static');
              },
              child: Container(
                //시설분석으로 돌아가기
                color: Color(0xFFFFFFFF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15, top: 15),
                          child: Image.asset('assets/static/icons/backIcon.png'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            '시설분석으로 돌아가기',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 5),
                      child: Text(
                        '${selectGym}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, bottom: 15),
                      child: Text(
                        ' - 시설 통계 분석',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //통계 항목 선택
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    offset: const Offset(0, 1.5),
                    blurRadius: 1,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10, bottom: 5),
                    child: Text(
                      '통계 항목 선택',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child: HumanCategoriesWidget(getData),
                  ),
                ],
              ),
            ),

            Container(
              //**별 이용현황
              width: double.maxFinite,
              height: 600,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    offset: const Offset(0, 1.5),
                    blurRadius: 1,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: HumanCategoriesStatusWidget(),
            ),
          ],
        ),
      ),
    );
  }
}