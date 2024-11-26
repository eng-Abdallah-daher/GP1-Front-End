import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaintenanceHistoryPage extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Maintenance History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 10.0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: maintenanceRecords.length,
          itemBuilder: (context, index) {
            return _buildMaintenanceRecord(context,maintenanceRecords[index]);
          },
        ),
      ),
    );
  }

Widget _buildMaintenanceRecord(
      BuildContext context, MaintenanceRecord record) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.build,
            color: Colors.blue.shade800,
            size: 45,
          ),
        ),
        title: Text(
          DateFormat('yyyy-MM-dd').format(record.date),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        subtitle: Text(
          record.description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue.shade700,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.blue.shade600,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Colors.white,
        selectedTileColor: Colors.blue.shade50,
        onTap: () {
          // Action to perform on row tap
          _onMaintenanceRecordTap(context, record);
        },
      ),
    );
  }

  void _onMaintenanceRecordTap(BuildContext context, MaintenanceRecord record) {
    // Show a more visually appealing dialog with a modern design
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.build,
                color: Colors.blue.shade800,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                "Maintenance Record",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Date: ${DateFormat('yyyy-MM-dd').format(record.date)}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Description:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                record.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Close",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


}


