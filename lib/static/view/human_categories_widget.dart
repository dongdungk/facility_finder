import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/local_data.dart';
import '../view/human_categories_status_widget.dart';


class HumanCategoriesWidget extends StatelessWidget {
  final VoidCallback facilitiesCallback;
  const HumanCategoriesWidget(this.facilitiesCallback,{super.key});


  List<Expanded> getElevatedButton() { // 버튼생성
    List<String> statCategories = ['연령별', '시간대별', '성별'];
    List<int> buttonColors = [0xff2B7FFF, 0xffFB2C36, 0xffAD46FF, 0xF3F4F6];
    List<Expanded> categoriesButton = [
      Expanded(
        child: ElevatedButton(onPressed: () {
          hCatePressed[0] = true;
          hCatePressed[1] = false;
          hCatePressed[2] = false;
          getdataType(age, statCategories[0]);
          facilitiesCallback();
        },
            style: hCatePressed[0] ?
            ElevatedButton.styleFrom(
              backgroundColor: Color(buttonColors[0]),
              foregroundColor: Colors.white,

            ) :
            ElevatedButton.styleFrom(
                backgroundColor: Color(buttonColors[3]),
                foregroundColor: Colors.black,
            ),
            child: Text(statCategories[0]),
        ),
      ),
      Expanded(
        child: ElevatedButton(onPressed: () {
          hCatePressed[0] = false;
          hCatePressed[1] = true;
          hCatePressed[2] = false;
          getdataType(time, statCategories[1]);
          facilitiesCallback();
        },
            style: hCatePressed[1] ?
            ElevatedButton.styleFrom(
              backgroundColor: Color(buttonColors[1]),
              foregroundColor: Colors.white,
            ) :
            ElevatedButton.styleFrom(
              backgroundColor: Color(buttonColors[3]),
              foregroundColor: Colors.black,
            ),
            child: Text(statCategories[1]),
        ),
      ),
      Expanded(
        child: ElevatedButton(onPressed: () {
          hCatePressed[0] = false;
          hCatePressed[1] = false;
          hCatePressed[2] = true;
          getdataType(gender, statCategories[2]);
          facilitiesCallback();
        },
            style: hCatePressed[2] ?
            ElevatedButton.styleFrom(
              backgroundColor: Color(buttonColors[2]),
              foregroundColor: Colors.white,
            ) :
            ElevatedButton.styleFrom(
              backgroundColor: Color(buttonColors[3]),
              foregroundColor: Colors.black,

            ),
            child: Text(statCategories[2])
        ),
      ),
     ];
    return categoriesButton;
  }

    @override
    Widget build(BuildContext context) {

       // final viewModel = Provider.of<StatisticViewModel>(context);
       var hCateState = HumanCategoriesStatusWidget();
       // viewModel.loadHCateButtonData();



      return Scaffold(
        body: Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: getElevatedButton()
        ),
      );
    }
}
