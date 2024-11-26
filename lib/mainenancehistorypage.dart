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
        backgroundColor: blueAccent,
        elevation: 10.0,
        centerTitle: true,
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: maintenanceRecords.length,
          itemBuilder: (context, index) {
            return _buildMaintenanceRecord(context, maintenanceRecords[index]);
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
            color: blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.build,
            color: lightBlue,
            size: 45,
          ),
        ),
        title: Text(
          DateFormat('yyyy-MM-dd').format(record.date),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: blueAccent,
          ),
        ),
        subtitle: Text(
          record.description,
          style: TextStyle(
            fontSize: 16,
            color: blueAccent,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: blueAccent,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: white,
        selectedTileColor: blueAccent,
        onTap: () {
          _onMaintenanceRecordTap(context, record);
        },
      ),
    );
  }

  void _onMaintenanceRecordTap(BuildContext context, MaintenanceRecord record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.build,
                color: blueAccent,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                "Maintenance\nRecord",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: blueAccent,
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
                  color: blueAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Description:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: blueAccent,
                ),
              ),
              SizedBox(height: 5),
              Text(
                record.description,
                style: TextStyle(
                  fontSize: 16,
                  color: black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Close",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
