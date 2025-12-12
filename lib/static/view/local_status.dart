import 'package:flutter/material.dart';

final _localList = ['서울시'];
String? selectedValue;
class LocalStatusPage extends StatelessWidget {
  const LocalStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border(bottom: BorderSide(width: 1, color: Color(0x33000000))),
                  color: Color(0xffF3F3F5)
              ),
              margin: EdgeInsets.all(20),
              width: double.maxFinite,
              
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Color(0xffF3F3F5)
                ),
                child: DropdownButton(
                  underline: Container(height: 0,),
                  icon: Image(image: AssetImage('assets/static/icons/downArrow.png')),
                    items: _localList.map((String item) => DropdownMenuItem<String>(
                      value: item, child: Text(item),
                    ),
                ).toList(),
                    value: selectedValue,
                    onChanged: (String? value){
                      setState(value);
                    },
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 1, color: Color(0x33000000),),)
              ),
              child: Text('구별 체육관 현황', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  spacing: 10,
                  children: [
                    Column(
                      spacing: 30,
                      children: [
                        Text('강남구',style: TextStyle(fontSize: 15),),
                        Text('서초구',style: TextStyle(fontSize: 15),),
                        Text('송파구',style: TextStyle(fontSize: 15),),
                        Text('강서구',style: TextStyle(fontSize: 15),),
                        Text('영등포구',style: TextStyle(fontSize: 15),),
                        Text('마포구',style: TextStyle(fontSize: 15),),
                        Text('양천구',style: TextStyle(fontSize: 15),),
                        Text('관악구',style: TextStyle(fontSize: 15),),
                        Text('강동구',style: TextStyle(fontSize: 15),),
                        Text('동작구',style: TextStyle(fontSize: 15),),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        spacing: 30,
                        children: [
                          Text('준비중입니다',style: TextStyle(fontSize: 15),),

                        ],
                      ),
                    ),
                    Column(
                      spacing: 28,
                      children: [
                        Text('124개',style: TextStyle(fontSize: 15),),
                        Text('98개',style: TextStyle(fontSize: 15),),
                        Text('87개',style: TextStyle(fontSize: 15),),
                        Text('76개',style: TextStyle(fontSize: 15),),
                        Text('65개',style: TextStyle(fontSize: 15),),
                        Text('58개',style: TextStyle(fontSize: 15),),
                        Text('52개',style: TextStyle(fontSize: 15),),
                        Text('47개',style: TextStyle(fontSize: 15),),
                        Text('43개',style: TextStyle(fontSize: 15),),
                        Text('39개',style: TextStyle(fontSize: 15),),
                      ],
                    )
                  ],
            )
            )
          ],
        ),
      ),
    );

  }




void setState(value) {
  selectedValue = value;
}
}