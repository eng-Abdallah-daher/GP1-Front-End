import 'package:first/RentCarPage.dart';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';


const Color backgroundColor = Colors.white; 
const Color lightBlueColor = Color(0xFFADD8E6); 
const Color blueColor = Color(0xFF0F3460); 
const Color cardColor = Color(0xFFB0E0E6); 

class RentalStorePage extends StatelessWidget {
  
  

  
  void printCarData(BuildContext context, Map<String, String> car) {
 

    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentCarPage(
          
          id:  car['id']!,
          name: car['name'] ?? '',
          imageUrl: car['imageUrl'] ?? '',
          pricePerDay: double.parse(car['pricePerDay'] ?? '0'), 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [lightBlueColor, blueColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('Rental Cars', style: TextStyle(color: whiteColor)),
              backgroundColor: blueColor, 
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  final car = cars[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    color: cardColor, 
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              printCarData(
                                  context, car); 
                            },
                            child: Image.asset(
                              car['imageUrl'] ?? '',
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            car['name'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: blueColor,
                            ),
                          ),
                          Text(
                            'Model: ${car['model']}',
                            style: TextStyle(fontSize: 16, color: blueColor),
                          ),
                          Text(
                            'Price: \$${car['pricePerDay']} per day',
                            style: TextStyle(fontSize: 16, color: blueColor),
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RentalStorePage(),
  ));
}
