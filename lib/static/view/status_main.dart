import 'package:flutter/material.dart';
import '../viewmodel/local_data.dart';



class StatusMainPage extends StatelessWidget {

  List<Container> getLocalList(){
    List<Container> LocalListContainer = [];
    String name;
    for(int i = 0; i < Seoul.length; i++){
      name = Seoul[i][0];
      LocalListContainer.add(
        Container(
          decoration: BoxDecoration(
              color:Color(0xffF9FAFB),
              border: Border.all(width: 0, color: Color(0xffE5E7EB),),
              borderRadius: BorderRadius.circular(10.0)
          ),
          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
          padding: EdgeInsets.only(left: 20, top: 8),
          width: double.maxFinite,
          height: 40,
          child: Text('$name',style: TextStyle(fontSize: 16),),
        ),
      );
    }
    return LocalListContainer;
  }
  const StatusMainPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          // Container(
          //     width: double.maxFinite,
          //     height: 50,
          //     child: Status_Tabbar()
          // ),
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
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 800,
            child:ListView(
              children: getLocalList(),
            ),
          )
        ],
      )
      ),
    );
  }
}
