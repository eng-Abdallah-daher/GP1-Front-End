import 'dart:async';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';

class TrackRepairStatusPage extends StatefulWidget {
  @override
  _TrackRepairStatusPageState createState() => _TrackRepairStatusPageState();
}

class _TrackRepairStatusPageState extends State<TrackRepairStatusPage> {
  Timer? _timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    super.initState();
   
    _initializeNotifications();
    _startTimer();
  }

  void _initializeNotifications() async {

     await getbookings();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        for (var repairStatus in bookings) {
          if (repairStatus.userid == global_user.id) {
            DateTime now = DateTime.now();

            if (now.isAfter(repairStatus.appointment) &&
                now.isBefore(repairStatus.appointmentDate)) {
              repairStatus.status = "In Progress";
            } else if (repairStatus.status != "Completed") {
              if (repairStatus.appointmentDate.isBefore(DateTime.now())) {
                repairStatus.status = "Completed";
                if (!repairStatus.appointmentDate
                    .isBefore(DateTime.now().subtract(Duration(days: 1))))
                  _showNotification(repairStatus);
              }
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _showNotification(Booking repairStatus) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'repair_status_updates_channel',
      'Repair Status Updates',
      channelDescription: 'Channel for Repair Status Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      vibrationPattern: Int64List.fromList([0, 1000, 500, 2000]),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        'The repair for "${repairStatus.customerName}" is now completed! Click here for more details.',
        contentTitle: 'Repair Status Update',
        summaryText: 'Repair for ${repairStatus.customerName} completed',
      ),
      showProgress: repairStatus.status == 'in_progress',
      maxProgress: 100,
      progress: repairStatus.status == 'in_progress' ? 50 : 100,
      indeterminate: repairStatus.status == 'in_progress',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'mark_as_completed',
          'Mark as Completed',
        ),
        AndroidNotificationAction(
          'view_details',
          'View Details',
        ),
      ],
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        repairStatus.bookingid,
        'Repair Status: ${repairStatus.status}',
        'The repair for "${repairStatus.customerName}" is ${repairStatus.status}.',
        platformChannelSpecifics,
        payload: repairStatus.customerName,
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  String _getRemainingTime(Booking repairStatus) {
    final Duration remainingTime =
        repairStatus.appointmentDate.difference(DateTime.now());

    if (remainingTime.isNegative) {
      return "Completed";
    }

    final int hours = remainingTime.inHours;
    final int minutes = remainingTime.inMinutes.remainder(60);
    final int seconds = remainingTime.inSeconds.remainder(60);

    return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track Repair Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),
      backgroundColor: white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            if (bookings[index]
                .appointmentDate
                .isBefore(DateTime.now().subtract(Duration(days: 1)))) {
              return SizedBox(
                width: 0,
              );
            } else if (bookings[index].userid != global_user.id)
              return null;
            else
              return _buildRepairStatusCard(bookings[index]);
          },
        ),
      ),
    );
  }

  Widget _buildRepairStatusCard(Booking repairStatus) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(repairStatus),
            SizedBox(height: 10),
            _buildStatusText(repairStatus),
            SizedBox(height: 10),
            _buildCompletionTime(repairStatus),
            SizedBox(height: 15),
            _buildActionButton(repairStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Booking repairStatus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          repairStatus.customerName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        Icon(
          Icons.repartition,
          color: Colors.blue.shade800,
          size: 30,
        ),
      ],
    );
  }

  Widget _buildStatusText(Booking repairStatus) {
    return Text(
      "Status: ${repairStatus.status}",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _getStatusColor(repairStatus.status),
      ),
    );
  }

  Widget _buildCompletionTime(Booking repairStatus) {
    return Text(
      "Time Remaining: ${_getRemainingTime(repairStatus)}",
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildActionButton(Booking repairStatus) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RepairStatusDetailPage(repairStatus: repairStatus),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      child: Text(
        "View Details",
        style: TextStyle(fontSize: 16, color: white),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "In Progress":
        return Colors.orange;
      case "Pending":
        return Colors.red;
      default:
        return black;
    }
  }
}

class RepairStatusDetailPage extends StatelessWidget {
  final Booking repairStatus;

  RepairStatusDetailPage({required this.repairStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repair Status Details"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceHeader(),
            SizedBox(height: 20),
            _buildStatusCard(),
            SizedBox(height: 20),
            _buildEstimatedCompletion(),
            SizedBox(height: 20),
            _buildAdditionalDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceHeader() {
    return Text(
      repairStatus.customerName,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Status: ${repairStatus.status}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(repairStatus.status),
              ),
            ),
            SizedBox(height: 10),
            Icon(
              Icons.check_circle,
              size: 50,
              color: _getStatusColor(repairStatus.status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimatedCompletion() {
    return Text(
      "Estimated Completion: ${repairStatus.appointmentDate.toLocal().toString().split(' ')[0]}",
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildAdditionalDetails() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: black,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Additional Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "In Progress":
        return Colors.orange;
      case "Pending":
        return Colors.red;
      default:
        return black;
    }
  }
}
