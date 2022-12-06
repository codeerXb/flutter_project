import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../../core/widget/custom_app_bar.dart';

/// 图表demo
class ChartDemo extends StatefulWidget {
  const ChartDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartDemoState();
}

class _ChartDemoState extends State<ChartDemo> {
  late TooltipBehavior _tooltip;
  late TooltipBehavior _tooltip2;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    _tooltip2 = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = [
      ChartData('Jan', 35),
      ChartData('Feb', 28),
      ChartData('Mar', 34),
      ChartData('Apr', 32),
      ChartData('May', 40)
    ];

    int total = 35 + 28 + 34 + 32 + 40;

    return Scaffold(
        appBar: customAppbar(context: context, title: '图表Demo'),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 折线图
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Half yearly sales analysis'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<ChartData, String>>[
                    LineSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        name: 'Sales',
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true))
                  ]),
              // 柱状图
              SfSparkBarChart.custom(
                //Enable the trackball
                trackball: const SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                //Enable marker
                //Enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => chartData[index].x,
                yValueMapper: (int index) => chartData[index].y,
                dataCount: 5,
              ),
              // 柱状图2 横向
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<ChartData, String>>[
                    BarSeries<ChartData, String>(
                        dataSource: chartData,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.top),
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        name: 'Gold',
                        color: Colors.pink)
                  ]),
              // 饼图
              SfCircularChart(series: <CircularSeries>[
                // Render pie chart
                PieSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ]),
              // 饼图2
              SfCircularChart(
                  tooltipBehavior: _tooltip2,
                  series: <CircularSeries<ChartData, String>>[
                    DoughnutSeries(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      innerRadius: '70%',
                      dataLabelMapper: (ChartData data, _) {
                        return '${data.x}：${data.y} \n ${(data.y / total * 100).toStringAsFixed(2)}%';
                      },
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelIntersectAction: LabelIntersectAction.none),
                    )
                  ])
            ],
          ),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
