import 'package:firebasetutorial/bar%20graph/individual_bar.dart';

class BarData {
  final double firstAmount;
  final double secondAmount;
  final double thirdAmount;
  final double fourthAmount;
  final double fifthAmount;

  BarData({
    required this.firstAmount,
    required this.secondAmount,
    required this.thirdAmount,
    required this.fourthAmount,
    required this.fifthAmount,
  });

  List<IndividualBar> barData = [];

  // initialize barData
  void initializeBarData() {
    barData = [
      // first
      IndividualBar(x: 0, y: firstAmount),
      // second
      IndividualBar(x: 1, y: secondAmount),
      // third
      IndividualBar(x: 2, y: thirdAmount),
      // fourth
      IndividualBar(x: 3, y: fourthAmount),
      // fifth
      IndividualBar(x: 4, y: fifthAmount),
    ];
  }
}
