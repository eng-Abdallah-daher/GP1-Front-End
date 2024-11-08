import 'package:flutter/material.dart';

const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 
const Color lightGrey = Color(0xFFAAAAAA); 

class Rental {
  String carImage;
  String carName;
  String carModel;
  String startDate;
  String duration;
  String status;

  Rental({
    required this.carImage,
    required this.carName,
    required this.carModel,
    required this.startDate,
    required this.duration,
    this.status = 'pending', 
  });
}

class ViewRentalsPage extends StatefulWidget {
  @override
  _ViewRentalsPageState createState() => _ViewRentalsPageState();
}

class _ViewRentalsPageState extends State<ViewRentalsPage> {
  final List<Rental> rentals = [
    Rental(
      carImage: 'images/logo.png',
      carName: 'BMW',
      carModel: 'Model S',
      startDate: '2024-10-20',
      duration: '4',
      status: 'Completed',
    ),
    Rental(
      carImage: 'images/logo2.png',
      carName: 'BMW',
      carModel: 'Model X',
      startDate: '2024-10-21',
      duration: '9',
      status: 'pending',
    ),
  ];

  String searchQuery = '';
  List<Rental> filteredRentals = [];

  @override
  void initState() {
    super.initState();
    filteredRentals = rentals; 
  }

  void _filterRentals(String query) {
    setState(() {
      searchQuery = query;
      filteredRentals = rentals.where((rental) {
        return rental.carName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('View Rentals', style: TextStyle(color: whiteColor)),
        backgroundColor: deepBlueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            TextField(
              onChanged: _filterRentals,
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                labelText: 'Search Rentals',
                labelStyle: TextStyle(color: whiteColor, fontSize: 16),
                filled: true,
                fillColor: deepBlueColor.withOpacity(0.8),
                prefixIcon: Icon(Icons.search, color: whiteColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
            ),
            SizedBox(height: 20),

            
            Expanded(
              child: ListView.builder(
                itemCount: filteredRentals.length,
                itemBuilder: (context, index) {
                  final rental = filteredRentals[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: deepBlueColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(rental.carImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),

                          
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text(
                                  rental.carName,
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),

                                
                                Text(
                                  'Model: ${rental.carModel}',
                                  style:
                                      TextStyle(color: lightGrey, fontSize: 14),
                                ),
                                SizedBox(height: 4),

                                
                                Text(
                                  'Start: ${rental.startDate}',
                                  style:
                                      TextStyle(color: lightGrey, fontSize: 14),
                                ),
                                SizedBox(height: 4),

                                
                                Text(
                                  'Duration: ${rental.duration}',
                                  style:
                                      TextStyle(color: lightGrey, fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          
                          Text(
                            rental.status,
                            style: TextStyle(
                              color: rental.status == 'pending'
                                  ? brightCoralColor
                                  : Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
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
    home: ViewRentalsPage(),
  ));
}
