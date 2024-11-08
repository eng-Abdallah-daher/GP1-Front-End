import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

const Color backgroundColor = Color(0xFFB3E5FC); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0D47A1); 
const Color brightCoralColor = Color(0xFFE94560); 

class ProfitsPage extends StatefulWidget {
  @override
  _ProfitsPageState createState() => _ProfitsPageState();
}

class _ProfitsPageState extends State<ProfitsPage> {
  


  @override
  void initState() {
    super.initState();
   
  }



  @override
  Widget build(BuildContext context) {
    
    List profits = profitData.map((data) => data['profit'].toDouble()).toList();
    double totalProfit =
        profits.reduce((a, b) => a + b); 

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Profits Overview',
          style: TextStyle(
            color: whiteColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: deepBlueColor,
        centerTitle: true,
        elevation: 6.0,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, top: 16.0, bottom: 16.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Total Profit: \$${totalProfit.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: deepBlueColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Monthly Profits',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: deepBlueColor,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: profitData.length==0 ? Text("There is no data available") : BarChart(
                      BarChartData(
                        barGroups: _createBarChartGroups(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60, 
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 38,
                              getTitlesWidget: (value, meta) {
                                
                                return Text(
                                  profitData[value.toInt()]
                                      ['date'], 
                                  style: TextStyle(color: deepBlueColor),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '\$${rod.toY.toStringAsFixed(2)}',
                                TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  
  List<BarChartGroupData> _createBarChartGroups() {
    return List.generate(profitData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: profitData[index]['profit'],
            color: Colors.blueAccent,
            width: 30, 
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfitsPage(),
  ));
}
