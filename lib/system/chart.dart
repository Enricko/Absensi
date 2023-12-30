import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWeekly extends StatefulWidget {
  const LineChartWeekly({super.key, required this.data});
  final Map<dynamic, dynamic> data;
  @override
  State<LineChartWeekly> createState() => _LineChartWeeklyState();
}

class _LineChartWeeklyState extends State<LineChartWeekly> {
  // Format Currency
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  Map<String, dynamic> dataMap = {};

  bool showAvg = false;
  DateTime nowDate = DateTime.now();
  DateTime startWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime endWeek = DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));

  @override
  void initState() {
    super.initState();
    widget.data.forEach((key, value) {
      var dataDate = DateFormat("EEEE, dd MMMM yyyy", 'id').parse(value['tanggal']);
      if (startWeek.isBefore(dataDate) && endWeek.isAfter(dataDate)) {
        var keyName = DateFormat("EEEE", 'id').format(dataDate).toLowerCase();
        dataMap[keyName] = value['total'];
      }
    });
  }

  String shortedCurrency(double value) {
    if (value >= 1000000000000) {
      return '${(value / 1000000000000).toStringAsFixed(0)}t';
    } else if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(0)}m';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    } else {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: SfCartesianChart(
            title: ChartTitle(text: 'Diagram Lembur Mingguan'),
            tooltipBehavior: TooltipBehavior(
              enable: true,
            ),
            // Initialize category axis
            primaryXAxis: CategoryAxis(),
            series: <LineSeries<LemburMingguan, String>>[
              LineSeries<LemburMingguan, String>(
                // Bind data source
                dataSource: <LemburMingguan>[
                  LemburMingguan('Sen', dataMap['senin'] ?? 0),
                  LemburMingguan('Sel', dataMap['selasa'] ?? 0),
                  LemburMingguan('Rab', dataMap['rabu'] ?? 0),
                  LemburMingguan('Kam', dataMap['kamis'] ?? 0),
                  LemburMingguan('Jum', dataMap['jumat'] ?? 0),
                  LemburMingguan('Sab', dataMap['sabtu'] ?? 0),
                  LemburMingguan('Min', dataMap['minggu'] ?? 0),
                ],
                xValueMapper: (LemburMingguan lembur, _) => lembur.hari,
                yValueMapper: (LemburMingguan lembur, _) => lembur.jumlah,
                markerSettings: MarkerSettings(isVisible: true),
                // onPointTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LemburMingguan {
  LemburMingguan(this.hari, this.jumlah);
  final String hari;
  final int jumlah;
}
