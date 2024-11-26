import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this package for date formatting

class Sale {
  final String itemName;
  final int quantity;
  final double price;
  final DateTime date;

  Sale({
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.date,
  });

  double get totalPrice => quantity * price;

  String get formattedDate =>
      DateFormat('yyyy-MM-dd – kk:mm').format(date); // Format date and time
}

class SalesPage extends StatelessWidget {
  // Sample sales data
  final List<Sale> sales = [
    Sale(
        itemName: 'Item A',
        quantity: 2,
        price: 25.0,
        date: DateTime.now().subtract(Duration(days: 1))),
    Sale(
        itemName: 'Item B',
        quantity: 1,
        price: 15.0,
        date: DateTime.now().subtract(Duration(days: 2))),
    Sale(
        itemName: 'Item C',
        quantity: 5,
        price: 10.0,
        date: DateTime.now().subtract(Duration(days: 3))),
    // Add more sales data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales History'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: sales.isEmpty
            ? Center(
                child: Text(
                  'No sales recorded.',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : ListView.builder(
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  return Card(
  elevation: 5, // Adds shadow for depth
  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15), // Rounded corners
    side: BorderSide(color: Colors.blueAccent, width: 1), // Accent border
  ),
  child: Padding(
    padding: const EdgeInsets.all(12.0), // Adds padding inside the card
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_bag, color: Colors.blueAccent, size: 24), // Add icon
                SizedBox(width: 8),
                Text(
                  sales[index].itemName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Bold title text
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Quantity: ${sales[index].quantity}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54, // Subtle secondary text
              ),
            ),
            Text(
              'Price: \$${sales[index].price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            Text(
              'Date: ${sales[index].formattedDate}',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black38, // Lighter text for date
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              'Total:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent, // Accent color for total label
              ),
            ),
            SizedBox(height: 4),
            Text(
              '\$${sales[index].totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Bold and bigger for total amount
              ),
            ),
          ],
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
