// // car_data_page.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:first/Bluetoothservice.dart';

// class CarDataPage extends StatefulWidget {
//   @override
//   _CarDataPageState createState() => _CarDataPageState();
// }

// class _CarDataPageState extends State<CarDataPage> {
//   CarData? _carData;

//   @override
//   void initState() {
//     super.initState();
//     _connectAndFetchData();
//   }

//   Future<void> _connectAndFetchData() async {
//     try {
//       final bluetoothService =
//           Provider.of<BluetoothService>(context, listen: false);
//       await bluetoothService.connectToCar(context);

//       // Fetch data after connecting
//       final data = await bluetoothService.fetchCarData();
//       setState(() {
//         _carData = data;
//       });
//     } catch (e) {
//       // Handle errors
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Car Data')),
//       body: Center(
//         child: _carData == null
//             ? CircularProgressIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Average Speed: ${_carData!.averageSpeed} km/h'),
//                   // Display other data here
//                 ],
//               ),
//       ),
//     );
//   }
// }
