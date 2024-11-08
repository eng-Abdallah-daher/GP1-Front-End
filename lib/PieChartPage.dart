import 'package:first/GetReviews.dart';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF);
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560);
const Color lightGreyColor = Color(0xFFB0B0B0);

class showreviews extends StatefulWidget {
  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<showreviews> {
 


  Map<int, int> countOccurrences(List<int> list) {
    Map<int, int> occurrences = {};
    for (int number in list) {
      occurrences.update(number, (value) => value + 1, ifAbsent: () => 1);
    }
    return occurrences;
  }

  @override
  Widget build(BuildContext context) {
    
    Map<int, int> numberCounts = countOccurrences(numbers);

    
    List<PieChartSectionData> pieChartData = numberCounts.entries.map((entry) {
      return PieChartSectionData(
        color: _getColor(entry.key), 
        value: entry.value.toDouble(), 
        title: '${entry.key}', 
        titleStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: whiteColor),
        radius: 70, 
        badgeWidget: _buildBadge(entry.key),
        badgePositionPercentageOffset: 1.2, 
      );
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Pie Chart',
            style: TextStyle(
                color: whiteColor, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: deepBlueColor,
        centerTitle: true,
        elevation: 8.0,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Integer Distribution',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: brightCoralColor,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 20),
            
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: whiteColor,
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 350, 
                    child: PieChart(
                      PieChartData(
                        sections: pieChartData,
                        centerSpaceRadius: 60,
                        sectionsSpace: 5,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GetReviews()),
        );
          
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brightCoralColor, 
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5, 
                shadowColor: Colors.black.withOpacity(0.3),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: whiteColor,
                ),
              ),
              child: Text(
                'Show All Reviews',
                style: TextStyle(color: whiteColor),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  
  Color _getColor(int number) {
    switch (number) {
      case 1:
        return Colors.blueAccent.shade400;
      case 2:
        return Colors.green.shade400;
      case 3:
        return Colors.orange.shade400;
      case 4:
        return Colors.purple.shade400;
      case 5:
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  
  Widget _buildBadge(int number) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: whiteColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: deepBlueColor,
        ),
      ),
    );
  }

  
  void _showReviewsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reviews', style: TextStyle(color: deepBlueColor)),
          content: Text('No reviews available yet.',
              style: TextStyle(color: lightGreyColor)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('Close', style: TextStyle(color: brightCoralColor)),
            ),
          ],
        );
      },
    );
  }
}

