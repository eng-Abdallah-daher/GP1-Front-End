import 'package:first/CreateRentalPage.dart';
import 'package:first/glopalvars.dart';
import 'package:first/user.dart';
import 'package:flutter/material.dart';



class CarSelectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: deepBlueColor,
        scaffoldBackgroundColor: backgroundColor,
        
      ),
      home: CarSelectionPage(),
    );
  }
}

class CarSelectionPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Car'),
        backgroundColor: deepBlueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final car = cars[index];
            
            return GestureDetector(
              onTap: () {
selectedid=car['id']!;
                selectedcarimage=car['imageUrl']!;
                selectedcarmodel=car['model']!;
                selectedcarname=car['name']!;
                 Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => userpages()),
                );
              },
              child: Card(
                color: deepBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        image: DecorationImage(
                          image: AssetImage(car['imageUrl']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car['name']!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Model: ${car['model']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: lightGreyColor,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Price: ${car['pricePerDay']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: brightCoralColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF);
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 
const Color lightGreyColor = Color(0xFFB0B0B0); 
