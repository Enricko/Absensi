import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

extension DateTimeExtension on DateTime {
  int get lastDayOfMonth => DateTime(year, month + 1, 0).day;

  DateTime get lastDateOfMonth => DateTime(year, month + 1, 0);
}

class LineChartWeekly extends StatefulWidget {
  const LineChartWeekly({super.key, required this.data});
  final Map<dynamic, dynamic> data;
  @override
  State<LineChartWeekly> createState() => _LineChartWeeklyState();
}

class _LineChartWeeklyState extends State<LineChartWeekly> {
  final dbReference = FirebaseDatabase.instance.ref().child("lembur").child(FirebaseAuth.instance.currentUser!.uid);
  // Format Currency
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  Map<dynamic, dynamic> dataMap = {};
  Map<String, dynamic> sortDataMap = {};

  bool showAvg = false;
  DateTime nowDate = DateTime.now();
  DateTime semingguTerakhir = DateTime.now().subtract(Duration(days: 7));
  DateTime bulanLalu = DateTime(DateTime.now().year, DateTime.now().month - 1);
  // DateTime akhirBulan = DateTime(DateTime.now().year, DateTime.now().month).lastDateOfMonth;
  // DateTime endWeek = DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));

  Future<void> getData() async {
    dbReference.child(DateFormat("yyyy-MM", 'id').format(bulanLalu)).onValue.listen((event) {
      var snapshot = event.snapshot.value as Map;
      if (snapshot != null) {
        setState(() {
          dataMap.addAll(snapshot);
        });
      }
    });
    // Bulan ini
    dbReference.child(DateFormat("yyyy-MM", 'id').format(DateTime.now())).onValue.listen((event) {
      var snapshot = event.snapshot.value as Map;
      if (snapshot != null) {
        setState(() {
          dataMap.addAll(snapshot);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Bulan lalu
    getData().then((value) {
      Future.delayed(Duration(seconds: 2), () {
        dataMap.forEach((key, value) {
          var dataDate = DateFormat("EEEE, dd MMMM yyyy", 'id').parse(value['tanggal']);
          if (semingguTerakhir.isBefore(dataDate) && nowDate.isAfter(dataDate)) {
            setState(() {
              var keyName = DateFormat("dd-MM-yyyy", 'id').format(dataDate).toLowerCase();
              sortDataMap.putIfAbsent(keyName, () => value['total']);
            });
          }
        });
      });
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
                  LemburMingguan(
                      'H-6',
                      sortDataMap[DateFormat("dd-MM-yyyy", 'id')
                              .format(DateTime.now().subtract(Duration(days: 6)))
                              .toLowerCase()] ??
                          0),
                  LemburMingguan(
                      'H-5',
                      sortDataMap[DateFormat("dd-MM-yyyy", 'id')
                              .format(DateTime.now().subtract(Duration(days: 5)))
                              .toLowerCase()] ??
                          0),
                  LemburMingguan(
                      'H-4',
                      sortDataMap[DateFormat("dd-MM-yyyy", 'id')
                              .format(DateTime.now().subtract(Duration(days: 4)))
                              .toLowerCase()] ??
                          0),
                  LemburMingguan(
                      'H-3',
                      sortDataMap[DateFormat("dd-MM-yyyy", 'id')
                              .format(DateTime.now().subtract(Duration(days: 3)))
                              .toLowerCase()] ??
                          0),
                  LemburMingguan(
                      'H-2',
                      sortDataMap[DateFormat("dd-MM-yyyy", 'id')
                              .format(DateTime.now().subtract(Duration(days: 2)))
                              .toLowerCase()] ??
                          0),
                  LemburMingguan(
                      'H-1',
                      sortDataMap[DateFormat("dd-MM-yyyy", 'id')
                              .format(DateTime.now().subtract(Duration(days: 1)))
                              .toLowerCase()] ??
                          0),
                  LemburMingguan(
                      'H', sortDataMap[DateFormat("dd-MM-yyyy", 'id').format(DateTime.now()).toLowerCase()] ?? 0),
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
