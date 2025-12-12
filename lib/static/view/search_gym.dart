import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../view/human_categories_status_widget.dart';
import '../viewmodel/local_data.dart';


class SearchGymPage extends StatelessWidget {
  const SearchGymPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:
          Column(
            children: [
              GestureDetector(
                onTap: (){
                  context.go('/static');
                },
                child: Container( // 뒤로가기
                  margin: EdgeInsets.all(15),
                  child:  Row(
                    spacing: 10,
                    children: [
                      Container(
                        child: Image(image: AssetImage('assets/static/icons/backIcon.png'),),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('뒤로가기'),
                      ),
                    ],
                  ),
                ),
              ),
              Container( // 체육관 정보
                  margin: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(child: Container(
                        child: Text('강남 체육관', style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                      ),
                      ),
                      Expanded(child: Container(
                        child: Text('서초 클럽', style: TextStyle(fontSize: 20,), textAlign: TextAlign.center,),
                      ),
                      ),
                    ],
                  )
              ),
              Container(
                decoration: BoxDecoration(
                    color:Color(0xffD9D9D9),
                    border: Border.all(width: 0, color: Color(0xffD9D9D9),),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                width: double.maxFinite,
                height: 40,
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top:  11,
                      child: Image(
                        image: AssetImage('assets/static/icons/searchIcon.png'),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      top: -3,
                      child: Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: TextField(
                          controller: TextEditingController(),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintText: '검색창 : '),
                        ),
                      ),
                    ),
                    //
                  ],
                ),
              ),
              Container( // 체육관 세부정보
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  width: double.maxFinite,
                  height: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: GestureDetector(
                        onTap: (){
                          selectGym = gymList[0];
                          context.push('/static/facilities');
                          getdataType(age, hName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Color(0x30000000),),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 15,left: 5),
                                child: Text('양천구민체육센터', style: TextStyle(fontSize: 15)),
                              )
                              ,
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Image(image: AssetImage('assets/static/icons/markerIcon.png')),
                                    Text('서울 마포구 망원로 411',style: TextStyle(color: Color(0xff6A7282)),)
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Container(
                                      child: Image(image: AssetImage('assets/static/icons/favoriteIcon.png'),),
                                    ),
                                    Container(
                                      child: Text('4.5'),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text('코트 5개', style: TextStyle(color: Color(0xff6A7282),),),),
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      child: Text('5.2km' ,style: TextStyle(color: Color(0xff6A7282),),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text('₩3,000'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Container(
                                      child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text('주차장',style: TextStyle(color: Color(0xff4A5565),),),
                                    ),
                                    Container(
                                      child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text('샤워실',style: TextStyle(color: Color(0xff4A5565),),),
                                    ),
                                    Container(
                                      child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text('라커',style: TextStyle(color: Color(0xff4A5565),),),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            selectGym = gymList[1];
                            context.push('/static/facilities');
                            getdataType(age, hName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Color(0x30000000),),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 15,left: 5),
                                  child: Text('잠실체육구민센터', style: TextStyle(fontSize: 15)),
                                )
                                ,
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      Image(image: AssetImage('assets/static/icons/markerIcon.png')),
                                      Text('서울 송파구 올림픽로 323',style: TextStyle(color: Color(0xff6A7282)),)
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      Container(
                                        child: Image(image: AssetImage('assets/static/icons/favoriteIcon.png'),),
                                      ),
                                      Container(
                                        child: Text('4.5'),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('코트 4개', style: TextStyle(color: Color(0xff6A7282),),),),
                                      Container(
                                        padding: EdgeInsets.only(left: 35),
                                        child: Text('12km' ,style: TextStyle(color: Color(0xff6A7282),),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('₩3,000'),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      Container(
                                        child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text('주차장',style: TextStyle(color: Color(0xff4A5565),),),
                                      ),
                                      Container(
                                        child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text('샤워실',style: TextStyle(color: Color(0xff4A5565),),),
                                      ),
                                      Container(
                                        child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text('라커',style: TextStyle(color: Color(0xff4A5565),),),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child:GestureDetector(
                          onTap: (){
                            selectGym = gymList[2];
                            context.push('/static/facilities');
                            getdataType(age, hName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Color(0x30000000),),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 15,left: 5),
                                  child: Text('서초시민구민센터', style: TextStyle(fontSize: 15)),
                                )
                                ,
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      Image(image: AssetImage('assets/static/icons/markerIcon.png')),
                                      Text('서울 서초구 서초동 314',style: TextStyle(color: Color(0xff6A7282)),)
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      Container(
                                        child: Image(image: AssetImage('assets/static/icons/favoriteIcon.png'),),
                                      ),
                                      Container(
                                        child: Text('4.5'),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('코트 6개', style: TextStyle(color: Color(0xff6A7282),),),),
                                      Container(
                                        padding: EdgeInsets.only(left: 35),
                                        child: Text('10.2km' ,style: TextStyle(color: Color(0xff6A7282),),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('₩3,000'),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      Container(
                                        child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text('주차장',style: TextStyle(color: Color(0xff4A5565),),),
                                      ),
                                      Container(
                                        child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text('샤워실',style: TextStyle(color: Color(0xff4A5565),),),
                                      ),
                                      Container(
                                        child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text('라커',style: TextStyle(color: Color(0xff4A5565),),),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: GestureDetector(
                        onTap: (){
                          selectGym = gymList[3];
                          context.push('/static/facilities');
                          getdataType(age, hName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Color(0x30000000),),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 15,left: 5),
                                child: Text('마포구민체육센터', style: TextStyle(fontSize: 15)),
                              )
                              ,
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Image(image: AssetImage('assets/static/icons/markerIcon.png')),
                                    Text('서울 마포구 망원로 124',style: TextStyle(color: Color(0xff6A7282)),)
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Container(
                                      child: Image(image: AssetImage('assets/static/icons/favoriteIcon.png'),),
                                    ),
                                    Container(
                                      child: Text('4.5'),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text('코트 4개', style: TextStyle(color: Color(0xff6A7282),),),),
                                    Container(
                                      padding: EdgeInsets.only(left: 35),
                                      child: Text('4.2km' ,style: TextStyle(color: Color(0xff6A7282),),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text('₩3,000'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Container(
                                      child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text('주차장',style: TextStyle(color: Color(0xff4A5565),),),
                                    ),
                                    Container(
                                      child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text('샤워실',style: TextStyle(color: Color(0xff4A5565),),),
                                    ),
                                    Container(
                                      child: Image(image: AssetImage('assets/static/blueCircle.png'),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text('라커',style: TextStyle(color: Color(0xff4A5565),),),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ),
                    ],
                  )
              ),
            ],
          )
      ),

    );
  }
}
