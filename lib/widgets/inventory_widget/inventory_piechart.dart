import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Condition;
import 'package:responsive_framework/responsive_framework.dart';

import '../../../controller/home_controller.dart';
import 'indicator.dart';

class InventoryPieChart extends StatelessWidget {
  const InventoryPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveRowColumn(
      layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? ResponsiveRowColumnType.ROW
          : ResponsiveRowColumnType.COLUMN,
      columnCrossAxisAlignment: CrossAxisAlignment.start,
      columnMainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ResponsiveRowColumnItem(
          child: ResponsiveVisibility(
            visible: false,
            visibleWhen: [Condition.largerThan(name: TABLET)],
            child: Text(
              "Stock Pie Chart",
              style: TextStyle(
                color: Color.fromARGB(255, 15, 70, 17),
                fontSize: 18,
                wordSpacing: 1,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: SizedBox(
            height: 150,
            width: 150,
            child: PieChart(
              PieChartData(
                  pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      // _inController.pieTouchIndex = -1;
                      return;
                    }
                    // _inController.pieTouchIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 10,
                  sections: showingSections()),
            ),
          ),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'Total Quantity',
                  isSquare: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Indicator(
                  color: Color(0xff13d38e),
                  text: 'Remain Quantity',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    HomeController _controller = Get.find();
    return List.generate(2, (i) {
      final isTouched = i == _controller.pieTouchIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: _controller.totalProduct.value + .0,
            title: '${_controller.totalProduct.value}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: _controller.remainProduct.value + .0,
            title: '${_controller.remainProduct.value}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
