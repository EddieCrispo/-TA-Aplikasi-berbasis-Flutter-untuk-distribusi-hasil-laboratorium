import 'package:firebasetutorial/bar%20graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final List testsSummary;
  const MyBarGraph({super.key, required this.testsSummary});

  @override
  Widget build(BuildContext context) {
    // Debug print to check the length of testsSummary
    //print('testsSummary length: ${testsSummary.length}');

    // Check if testsSummary has at least 5 elements
    if (testsSummary.length < 5) {
      // Provide default values or handle this case according to your logic
      return Container(
        // You can customize this container based on your requirements
        child: Text('Insufficient data for the bar chart.'),
      );
    }

    // Initialize bar data
    BarData myBarData = BarData(
      firstAmount: testsSummary[0],
      secondAmount: testsSummary[1],
      thirdAmount: testsSummary[2],
      fourthAmount: testsSummary[3],
      fifthAmount: testsSummary[4],
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 200,
        minY: 0,
        gridData: FlGridData(show: false), // show grid
        borderData: FlBorderData(show: false), // show border
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, getTitlesWidget: getBottomTitles)),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                      toY: data.y,
                      color: Colors.blueGrey,
                      width: 25,
                      borderRadius: BorderRadius.circular(4)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
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
      text = const Text('1st', style: style);
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
