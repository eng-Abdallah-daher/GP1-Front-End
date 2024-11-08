import 'package:first/getcars.dart';
import 'package:first/glopalvars.dart';
import 'package:first/selectuser.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 

class CreateRentalPage extends StatefulWidget {
  @override
  _CreateRentalPageState createState() => _CreateRentalPageState();
}

class _CreateRentalPageState extends State<CreateRentalPage> {
 String formatDate(DateTime? date) {
    
    if (date == null) {
      return ''; 
    }

    int year = date.year;
    int month = date.month;
    int day = date.day;

    
    String formattedMonth = month.toString().padLeft(2, '0');
    String formattedDay = day.toString().padLeft(2, '0');

    
    return '$year-$formattedMonth-$formattedDay';
  }


  DateTime? startDate;
  String? selectedMethod = 'pickup';
  TextEditingController durationController = TextEditingController();

  
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), 
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  
  void _selectUser() {
 
 setState(() {
     Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserCardPage(),
          ));
 });
   setState(() {
      startDate = startDate;
    });
  }

  
  void _confirmRental() {
    if (startDate != null && durationController.text.isNotEmpty) {
      
      createRental(carId: selectedid,rentalDuration: int.parse(durationController.text),rentalMethod: "FromCompany",renterId: selectedUser.id,startDate: formatDate(startDate));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Create Rental', style: TextStyle(color: whiteColor)),
        backgroundColor: deepBlueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
         GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarSelectionApp()),
                );
             
              },
              child:     Center(
                child: Image.asset(
                  selectedcarimage, 
                  height: 200, 
                ),
              ),
            ),
            SizedBox(height: 16),

          
            Text(
              'Car Name: ${selectedcarname}', 
              style: TextStyle(color: whiteColor, fontSize: 20),
            ),
            SizedBox(height: 8),

            
            Text(
              'Model: ${selectedcarmodel}', 
              style: TextStyle(color: whiteColor, fontSize: 16),
            ),
            SizedBox(height: 20),

            
            ListTile(
              title: Text(
                'Start Date: ${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : 'Select'}',
                style: TextStyle(color: whiteColor),
              ),
              trailing: Icon(Icons.calendar_today, color: brightCoralColor),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),

          
          TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              style:
                  TextStyle(color: whiteColor), 
              decoration: InputDecoration(
                labelText: 'Duration (number)',
                labelStyle: TextStyle(color: whiteColor),
                filled: true,
                fillColor: deepBlueColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20),

           
            Center(
              child: ElevatedButton(
                onPressed: _selectUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brightCoralColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), 
                  ),
                ),
                child: Text('Select User', style: TextStyle(color: whiteColor)),
              ),
            ),
            SizedBox(height: 20),
              Text(
              "${selectedUser.name}", 
              style: TextStyle(color: whiteColor, fontSize: 20),
            ),
SizedBox(height: 20),
           
            Center(
              child: ElevatedButton(
                onPressed: _confirmRental,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brightCoralColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), 
                  ),
                ),
                child:
                    Text('Confirm Rental', style: TextStyle(color: whiteColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CreateRentalPage(),
  ));
}
