import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/weight_record.dart';
import '../services/weight_record_service.dart';
import '../services/local_storage_service.dart';
import '../models/user_profile.dart';

class WeightBmiChartScreen extends StatefulWidget {
  @override
  State<WeightBmiChartScreen> createState() => _WeightBmiChartScreenState();
}

class _WeightBmiChartScreenState extends State<WeightBmiChartScreen> {
  List<WeightRecord> _records = [];
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final records = await WeightRecordService.loadWeightRecords();
    final profile = await LocalStorageService.loadUserProfile();
    setState(() {
      _records = records..sort((a, b) => a.date.compareTo(b.date));
      _userProfile = profile;
    });
  }

  List<FlSpot> _getWeightSpots() {
    return List.generate(_records.length, (index) {
      return FlSpot(index.toDouble(), _records[index].weight);
    });
  }

  List<FlSpot> _getBmiSpots() {
    if (_userProfile == null) return [];
    return List.generate(_records.length, (index) {
      final bmi = _records[index].weight /
          ((_userProfile!.height / 100) * (_userProfile!.height / 100));
      return FlSpot(index.toDouble(), bmi);
    });
  }

  List<String> _getDates() {
    return _records.map((e) => "${e.date.month}/${e.date.day}").toList();
  }

  @override
  Widget build(BuildContext context) {
    final dates = _getDates();
    return Scaffold(
      appBar: AppBar(title: Text('몸무게 / BMI 그래프'), centerTitle: true),
      body: _records.isEmpty
          ? Center(child: Text('몸무게 기록이 없습니다.'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('몸무게 변화',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 250, child: _buildWeightChart(dates)),
                    SizedBox(height: 30),
                    Text('BMI 변화',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 250, child: _buildBmiChart(dates)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWeightChart(List<String> dates) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < dates.length) {
                  return Text(dates[index], style: TextStyle(fontSize: 10));
                }
                return Text('');
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _getWeightSpots(),
            isCurved: true,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBmiChart(List<String> dates) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < dates.length) {
                  return Text(dates[index], style: TextStyle(fontSize: 10));
                }
                return Text('');
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _getBmiSpots(),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}