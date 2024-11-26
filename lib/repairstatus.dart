import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RepairStatus {
  final int id;
  final String service;
  String status;
  final DateTime estimatedCompletion;

  RepairStatus({
    required this.id,
    required this.service,
    required this.status,
    required this.estimatedCompletion,
  });
}

class TrackRepairStatusPage extends StatefulWidget {
  @override
  _TrackRepairStatusPageState createState() => _TrackRepairStatusPageState();
}

class _TrackRepairStatusPageState extends State<TrackRepairStatusPage> {
  final List<RepairStatus> repairStatuses = [
    RepairStatus(
      id: 1,
      service: "Oil Change",
      status: "In Progress",
      estimatedCompletion: DateTime(2024, 12, 10, 15, 30),
    ),
    RepairStatus(
      id: 2,
      service: "Tire Rotation",
      status: "Completed",
      estimatedCompletion: DateTime(2024, 12, 10, 14, 30),
    ),
    RepairStatus(
      id: 3,
      service: "Brake Inspection",
      status: "Pending",
      estimatedCompletion: DateTime(2024, 12, 11, 10, 0),
    ),
  ];

  Timer? _timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // Initialize notifications
    _startTimer();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS initialization for proper cross-platform behavior
    
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        for (var repairStatus in repairStatuses) {
          if (repairStatus.status != "Completed" &&
              repairStatus.estimatedCompletion.isBefore(DateTime.now())) {
            repairStatus.status = "Completed";
            _showNotification(repairStatus);
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

  Future<void> _showNotification(RepairStatus repairStatus) async {
    // Big Picture Style with a relevant image
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      DrawableResourceAndroidBitmap(
          '@mipmap/ic_launcher'), // Add an image related to your service
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      contentTitle: 'Repair Status: ${repairStatus.service}',
      summaryText: 'The repair for "${repairStatus.service}" is now completed!',
      htmlFormatContentTitle: true,
      htmlFormatSummaryText: true,
    );

    // Remove `const` from AndroidNotificationDetails
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'repair_status_updates_channel',
      'Repair Status Updates',
      channelDescription: 'Channel for Repair Status Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: bigPictureStyleInformation, // Big Picture style added
      enableLights: true, // Enable LED lights for the notification
      color: Colors.blue, // Custom notification color
      playSound: true, // Play a custom sound
      sound: RawResourceAndroidNotificationSound(
          'notification_sound'), // Ensure to add this sound file in your Android project
      enableVibration: true, // Enable vibration for more impact
      ledColor: Colors.blueAccent,
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    // No `const` here either
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        repairStatus.id,
        'Repair Status: ${repairStatus.service}',
        'The repair for "${repairStatus.service}" is now completed!',
        platformChannelSpecifics,
        payload: repairStatus.service,
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }


  String _getRemainingTime(RepairStatus repairStatus) {
    final Duration remainingTime =
        repairStatus.estimatedCompletion.difference(DateTime.now());

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
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: repairStatuses.length,
          itemBuilder: (context, index) {
            return _buildRepairStatusCard(repairStatuses[index]);
          },
        ),
      ),
    );
  }

  Widget _buildRepairStatusCard(RepairStatus repairStatus) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
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

  Widget _buildHeader(RepairStatus repairStatus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          repairStatus.service,
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

  Widget _buildStatusText(RepairStatus repairStatus) {
    return Text(
      "Status: ${repairStatus.status}",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _getStatusColor(repairStatus.status),
      ),
    );
  }

  Widget _buildCompletionTime(RepairStatus repairStatus) {
    return Text(
      "Time Remaining: ${_getRemainingTime(repairStatus)}",
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildActionButton(RepairStatus repairStatus) {
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
        style: TextStyle(fontSize: 16, color: Colors.white),
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
        return Colors.black;
    }
  }
}

class RepairStatusDetailPage extends StatelessWidget {
  final RepairStatus repairStatus;

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
            colors: [Colors.blue.shade50, Colors.white],
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
      repairStatus.service,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Current Status: ${repairStatus.status}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _getStatusColor(repairStatus.status),
          ),
        ),
      ),
    );
  }

  Widget _buildEstimatedCompletion() {
    return Text(
      "Estimated Completion: ${repairStatus.estimatedCompletion}",
      style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
    );
  }

  Widget _buildAdditionalDetails() {
    return Text(
      "Additional repair details will be displayed here.",
      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
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
        return Colors.black;
    }
  }
}
