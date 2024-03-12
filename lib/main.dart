import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ChartApp());
}

class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chart Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Map<String, dynamic>> chartData;

  @override
  void initState() {
    loadChartData();
    super.initState();
  }

  Future<void> loadChartData() async {
    final String jsonString = await getJsonFromFirebase();
    final List<dynamic> jsonResponse = json.decode(jsonString);
    chartData = jsonResponse.cast<Map<String, dynamic>>();
    setState(() {});
  }

  Future<String> getJsonFromFirebase() async {
    String url = "https://safenest-31386-default-rtdb.asia-southeast1.firebasedatabase.app/data.json";
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime Data Visualization'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total IPC Crimes for Districts in 2001',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 400,
              child: SfCartesianChart(
                title: ChartTitle(text: 'Total IPC Crimes for Districts in 2001'),
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(),
                series: [
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: chartData,
                    xValueMapper: (Map<String, dynamic> data, _) => data['DISTRICT'] as String,
                    yValueMapper: (Map<String, dynamic> data, _) => data['TOTAL IPC CRIMES'] as int,
                    name: 'Total IPC Crimes',
                  )
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: SfCircularChart(
                title: ChartTitle(text: 'Crime Analysis (Pie Chart)'),
                series: <CircularSeries>[
                  PieSeries<Map<String, dynamic>, String>(
                    dataSource: chartData,
                    xValueMapper: (Map<String, dynamic> data, _) => 'Murder',
                    yValueMapper: (Map<String, dynamic> data, _) => data['MURDER'] as int,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                  PieSeries<Map<String, dynamic>, String>(
                    dataSource: chartData,
                    xValueMapper: (Map<String, dynamic> data, _) => 'Rape',
                    yValueMapper: (Map<String, dynamic> data, _) => data['RAPE'] as int,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: SfCircularChart(
                title: ChartTitle(text: 'Crime Analysis (Doughnut Chart)'),
                series: <CircularSeries>[
                  DoughnutSeries<Map<String, dynamic>, String>(
                    dataSource: chartData,
                    xValueMapper: (Map<String, dynamic> data, _) => 'Murder',
                    yValueMapper: (Map<String, dynamic> data, _) => data['MURDER'] as int,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                  DoughnutSeries<Map<String, dynamic>, String>(
                    dataSource: chartData,
                    xValueMapper: (Map<String, dynamic> data, _) => 'Rape',
                    yValueMapper: (Map<String, dynamic> data, _) => data['RAPE'] as int,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
