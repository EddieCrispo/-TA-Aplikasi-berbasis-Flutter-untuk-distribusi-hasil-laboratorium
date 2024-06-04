// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyLineGraph extends StatelessWidget {
  final List testsSummary;
  final double minRange;
  final double maxRange;
  final double yMin;
  final double yMax;

  const MyLineGraph(
      {Key? key,
      required this.testsSummary,
      required this.minRange,
      required this.maxRange,
      required this.yMin,
      required this.yMax})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (testsSummary.length < 5) {
      return Container(
        child: Text('Insufficient data for the line chart.'),
      );
    }

    List<FlSpot> spots = [
      FlSpot(0, testsSummary[0]),
      FlSpot(1, testsSummary[1]),
      FlSpot(2, testsSummary[2]),
      FlSpot(3, testsSummary[3]),
      FlSpot(4, testsSummary[4]),
    ];

    return LineChart(
      LineChartData(
        minY: yMin,
        maxY: yMax,
        gridData: FlGridData(show: false),
        lineTouchData: LineTouchData(
            touchTooltipData:
                LineTouchTooltipData(tooltipBgColor: Colors.white)),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles:
                SideTitles(showTitles: true, getTitlesWidget: getBottomTitles),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.red,
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: [
              FlSpot(0, maxRange),
              FlSpot(1, maxRange),
              FlSpot(2, maxRange),
              FlSpot(3, maxRange),
              FlSpot(4, maxRange),
            ],
            isCurved: false,
            color: Colors.transparent,
            dotData: FlDotData(show: false),
            barWidth: 4,
            belowBarData: BarAreaData(
                show: true,
                color: Color.fromARGB(89, 144, 144, 144),
                cutOffY: minRange,
                applyCutOffY: true),
          ),
        ],
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text;
    switch (value) {
      case 0:
        text = Text('1st', style: style);
        break;
      case 1:
        text = const Text('2nd', style: style);
        break;
      case 2:
        text = const Text('3rd', style: style);
        break;
      case 3:
        text = const Text('4th', style: style);
        break;
      case 4:
        text = const Text('5th', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }
}
