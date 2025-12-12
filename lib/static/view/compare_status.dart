import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class GymCompareStatPage extends StatelessWidget {
  const GymCompareStatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Column(
        spacing: 5,
        children: [
          Container(// 체육관 명
            decoration: BoxDecoration(
              border: Border.all(width: 1,color: Color(0xffE5E7EB)),
              borderRadius: BorderRadius.circular(2.0),
            ),
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.only(top:10 ,bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text('강남 체육관',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text('서초 클럽',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  ),
                ),
              ],
            ),
          ),
          Container(//코트 수
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,color: Color(0x226A7282),
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.only(top: 17,bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text('8개',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text('코트 수', style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text('10개', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                  ),
                ),
              ],
            ),
          ),
          Container(// 평균 혼잡도
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,color: Color(0x226A7282),
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.only(top: 19, bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image(image: AssetImage('assets/static/yellowCircle.png'),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7),
                        child: Text('보통',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text('평균 혼잡도', style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image(image: AssetImage('assets/static/greenCircle.png'),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7),
                        child: Text('여유',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(//평균 요금
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,color: Color(0x226A7282),
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.only(top: 17,bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text('₩3,000',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text('평균요금', style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text('₩3,500', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                  ),
                ),
              ],
            ),
          ),
          Container(// 평점
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,color: Color(0x226A7282),
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.only(top: 19, bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image(image: AssetImage('assets/static/icons/favoriteIcon.png'), width: 17, height: 17, fit: BoxFit.cover,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7),
                        child: Text('4.5',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text('평점', style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image(image: AssetImage('assets/static/icons/favoriteIcon.png'), width: 17, height: 17, fit: BoxFit.cover,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7),
                        child: Text('4.2',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(// 평점
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,color: Color(0x226A7282),
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.only(top: 19, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image(image: AssetImage('assets/static/icons/markerIcon.png'),width: 17, height: 17, fit: BoxFit.cover,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7),
                        child: Text('1.2km',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text('거리', style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image(image: AssetImage('assets/static/icons/markerIcon.png'), width: 17, height: 17, fit: BoxFit.cover,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7),
                        child: Text('2.5km',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.0),
              boxShadow: [
                BoxShadow(
                    color: Color(0x33000000),
                    offset: const Offset(0, 0.8),
                  blurRadius: 1,
                  spreadRadius: 1
                ),
              ]
            ),
            margin: EdgeInsets.fromLTRB(15, 30, 15, 30),
            padding: EdgeInsets.all(15),
            child: Column(
              spacing: 10,
              children: [
                Container(
                  child: Text('편의시설',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),
                Row( // 주차장
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          spacing: 5,
                          children: [
                            Image(image: AssetImage('assets/static/blueCircle.png'),width: 6, height: 6, fit: BoxFit.fill,),
                            Text('주차장')
                          ],
                        ),

                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          spacing: 5,
                          children: [
                            Image(image: AssetImage('assets/static/greenCircle.png'),width: 6, height: 6, fit: BoxFit.fill,),
                            Text('주차장')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row( // 샤워실
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          spacing: 5,
                          children: [
                            Image(image: AssetImage('assets/static/blueCircle.png'),width: 6, height: 6, fit: BoxFit.fill,),
                            Text('샤워실')
                          ],
                        ),

                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          spacing: 5,
                          children: [
                            Image(image: AssetImage('assets/static/greenCircle.png'),width: 6, height: 6, fit: BoxFit.fill,),
                            Text('샤워실')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row( // 라커,매점
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          spacing: 5,
                          children: [
                            Image(image: AssetImage('assets/static/blueCircle.png'),width: 6, height: 6, fit: BoxFit.fill,),
                            Text('라커')
                          ],
                        ),

                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          spacing: 5,
                          children: [
                            Image(image: AssetImage('assets/static/greenCircle.png'),width: 6, height: 6, fit: BoxFit.fill,),
                            Text('매점')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row( // '', 라커
                  children: [
                    Expanded(
                      child: Container(
                        child: Text('')
                        ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          spacing: 5,
                          children: [
                            Image(image: AssetImage('assets/static/greenCircle.png'),width: 6, height: 6, fit: BoxFit.fill,),
                            Text('라커')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 1,color: Color(0x226A7282),
                ),
                bottom: BorderSide(
                    width: 1,color: Color(0x226A7282),
                  ),
              )
            ),
            child: ElevatedButton(
                onPressed: (){
                  context.push('/static/SearchGym');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff155DFC),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )

                ),
                child: Text('체육관 비교하기',)
            ),
          )
        ],
      ),
      ),
    );
  }
}

