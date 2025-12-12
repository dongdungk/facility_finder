import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../view/human_status_container.dart';
import '../viewmodel/local_data.dart';
import 'chart_widget.dart';

int maxXValue = 0;
late Map<dynamic, dynamic> Hcate;

List<FlSpot> FlSpots = [];
String hName = '연령별';
bool stateChange = false;

List<Container> hStatsText = [];
List<Row> hStatsRow = [];
void getdataType(Map localHCate, String localHName) {
  // print(hCate);

  hName = localHName;
  FlSpots = [];
  hKeys = [];
  hStatsText = [];
  hStatsRow = [];
  maxXValue = localHCate.length;
  Hcate = localHCate;
  hKeys = localHCate.keys.toList();
  makeStatus();
}

void makeStatus() {
  for (int i = 0; i < maxXValue; i++) {
    FlSpots.add(FlSpot(i.toDouble(), Hcate[hKeys[i]]));

    hStatsText.add(
      Container(
        child: HumanStatusContainer(
          hStatTitle: hKeys[i],
          hPercent: Hcate[hKeys[i]],
        ),
      ),
    );

    if (hStatsText.length % 2 == 1 && i + 1 == maxXValue) {
      hStatsText.add(Container());
    }
  }
  getRowList();
}

void getRowList() {
  for (int i = 0; i < hStatsText.length; i++) {
    if (i >= 10) break;
    print (i);
    hStatsRow.add(
      Row(
        children: [
          Expanded(child: hStatsText[i]),
          Expanded(child: hStatsText[++i]),
        ],
      ),
    );
  }
}

class HumanCategoriesStatusWidget extends StatelessWidget {
  const HumanCategoriesStatusWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, top: 15),
            child: Text(
              '$hName 이용현황',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
          Container(width: 300, height: 300, child: CtLineChart()),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: Column(
               children: hStatsRow,
            ),
          ),
        ],
      ),
    );
  }
}
