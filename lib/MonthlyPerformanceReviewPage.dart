import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceAndProfitPage extends StatefulWidget {
  @override
  _PerformanceAndProfitPageState createState() =>
      _PerformanceAndProfitPageState();
}

class _PerformanceAndProfitPageState extends State<PerformanceAndProfitPage> {
  List<double> monthlyProfits = [];
  int selectedYear = DateTime.now().year;
  List<int> years =
      List<int>.generate(5, (index) => DateTime.now().year - index)
          .reversed
          .toList();

  @override
  void initState() {
    super.initState();
    _updateProfits();
  }

  void _updateProfits() {
    setState(() {
      monthlyProfits = calculateMonthlyProfits(year: selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Performance Review',
          style: TextStyle(color: white),
        ),
        backgroundColor: blue,
      ),
      body: Container(
        color: white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<int>(
                value: selectedYear,
                dropdownColor: Colors.blue.shade50,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                underline: SizedBox(),
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedYear = newValue;
                      _updateProfits();
                    });
                  }
                },
                items: years.map<DropdownMenuItem<int>>((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: monthlyProfits.isEmpty
                  ? Center(
                      child: Text(
                        'No data blueilable for the selected year.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: BarChart(
                        BarChartData(
                          maxY: monthlyProfits.reduce((a, b) => a > b ? a : b) +
                              10,
                          barGroups:
                              monthlyProfits.asMap().entries.map((entry) {
                            int index = entry.key;
                            double value = entry.value;
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: value,
                                  color: blue,
                                  width: 16,
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '\$${value.toInt()}',
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      getMonthName(value.toInt()),
                                      style: TextStyle(
                                        color: Colors.blue.shade800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.blue.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            if (monthlyProfits.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Total Profits This Year: \$${monthlyProfits.reduce((a, b) => a + b).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Average Monthly Profit: \$${(monthlyProfits.reduce((a, b) => a + b) / monthlyProfits.length).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'This Month\'s Top Seller:${getitemnamebyid(getBestSellingItem())}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  String getMonthName(int monthIndex) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[monthIndex];
  }
}
