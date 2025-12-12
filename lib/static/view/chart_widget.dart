import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'human_categories_status_widget.dart';

class CtLineChart extends StatefulWidget {
  const CtLineChart ({super.key});

  @override
  State<CtLineChart> createState() => _CtLineChartState();
}

class _CtLineChartState extends State<CtLineChart> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minX: 0,
            minY: 0,
            maxX: maxXValue-1.toDouble(),
            maxY: 100,
            gridData: const FlGridData(show: true),

            titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true,reservedSize: 35,  interval: 25),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true,reservedSize: 25, interval: 2,),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                )
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                bottom: BorderSide(color: Colors.black, width: 1),
                left: BorderSide(color: Colors.black, width: 1),
                right: BorderSide(color: Colors.transparent),
                top: BorderSide(color: Colors.transparent),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: false,
                  color: Colors.blue,
                ),
                spots: FlSpots ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}