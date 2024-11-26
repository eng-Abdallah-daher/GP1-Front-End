import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageRequestsPage extends StatefulWidget {
  @override
  _ManageRequestsPageState createState() => _ManageRequestsPageState();
}

class _ManageRequestsPageState extends State<ManageRequestsPage> {
  

  void _acceptRequest(MaintenanceRequest request) {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request ID : ${request.requestId} has been accepted'),
        backgroundColor: Colors.lightBlue.shade700,
      ),
    );
  }

  void _removeRequest(MaintenanceRequest request) {
    setState(() {
      maintenanceRecords.remove(request);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request ID: ${request.requestId} has been removed'),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Requests & Maintenance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.lightBlue.shade800,
        centerTitle: true,
        elevation: 8,
        shadowColor: Colors.black54,
      ),
      body: Stack(
        children: [
          // Background gradient for the whole page
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlue.shade700,
                  Colors.cyan.shade600,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: maintenanceRecords.length,
              itemBuilder: (context, index) {
                final request = maintenanceRecords[index];

                return Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shadowColor: Colors.lightBlue.withOpacity(0.5),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightBlue.shade600,
                      child: Icon(Icons.build, color: Colors.white),
                    ),
                    title: Text(
                      'Request ID: ${request.userid}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'Customer : ${request.userid}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Text(
                          'Request Date : ${request.getFormattedDate()}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 3,
                      children: [
                        _buildIconButton(
                          Icons.check_circle,
                          Colors.green.shade700,
                          'Accept',
                          () => {},
                        ),
                        _buildIconButton(
                          Icons.delete,
                          Colors.red.shade700,
                          'Remove',
                          () =>{},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, Color color, String tooltip, Function() onPressed) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: color, size: 33),
        onPressed: onPressed,
      ),
    );
  }
}

class MaintenanceRequest {
  final String requestId;
  final String customerName;
  final DateTime requestDate;

  final bool invoiceGenerated;

  MaintenanceRequest({
    required this.requestId,
    required this.customerName,
    required this.requestDate,
    required this.invoiceGenerated,
  });

  String getFormattedDate() {
    return DateFormat('yyyy-MM-dd - kk:mm').format(requestDate);
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ManageRequestsPage(),
  ));
}
