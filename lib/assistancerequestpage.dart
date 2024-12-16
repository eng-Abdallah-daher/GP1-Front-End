// import 'package:flutter/material.dart';
// import 'package:first/glopalvars.dart';
// import 'package:first/main.dart';

// class Assistancerequestpag extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SOS App',
//       theme: ThemeData(
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: RequestImmediateAssistancePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class RequestImmediateAssistancePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 40,
//             ),
//             Text(
//               'Please provide the following information to request immediate assistance:',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyLarge
//                   ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Name',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.person),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.phone),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Location',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.location_on),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Details of the Emergency',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.warning),
//               ),
//               maxLines: 3,
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Assistance request submitted!')),
//                 );
//               },
//               child: Text(
//                 'Request Assistance',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepOrange,
//                 foregroundColor: white,
//                 minimumSize: Size(double.infinity, 60),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 20),
//                 elevation: 10,
//                 shadowColor: Colors.black.withOpacity(0.5),
//                 side: BorderSide(
//                   color: Colors.orangeAccent,
//                   width: 2,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
