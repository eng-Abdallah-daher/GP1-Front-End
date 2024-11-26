import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:qr_flutter/qr_flutter.dart'; // Import the QR package

class BillingPaymentPage extends StatefulWidget {
  @override
  _BillingPaymentPageState createState() => _BillingPaymentPageState();
}

class _BillingPaymentPageState extends State<BillingPaymentPage> {
  final double totalAmountDue = 150.0; // Example amount
  final List<String> paymentMethods = [
    'Cash',
    'QR Code'
  ]; // Added QR Code as a payment method

  String? selectedPaymentMethod;
  String customerName = '';
  double cashAmount = 0.0; // Cash amount to be entered
  String qrCodeData = ''; // To store the QR code data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing & Payment'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount Due: \$${totalAmountDue.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Payment Method:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedPaymentMethod,
              items: paymentMethods.map((String method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPaymentMethod = newValue;
                  // Reset cash amount if another payment method is selected
                  if (newValue != 'Cash') {
                    cashAmount = 0.0;
                    qrCodeData = totalAmountDue
                        .toStringAsFixed(2); // Set QR code data to total amount
                  }
                });
              },
              hint: Text('Choose a payment method'),
            ),
            SizedBox(height: 20),
            if (selectedPaymentMethod == 'Cash') ...[
              Text(
                'Enter Customer Name:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    customerName = value; // Update the customer name
                  });
                },
              ),
              SizedBox(height: 10),
              Text(
                'Enter Cash Amount:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cash Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    cashAmount =
                        double.tryParse(value) ?? 0.0; // Update cash amount
                  });
                },
              ),
              SizedBox(height: 20),
            ] else if (selectedPaymentMethod == 'QR Code') ...[
              Text(
                'Scan QR Code for Payment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              // QrImage(
              //   data: qrCodeData, // Use the total amount as QR data
              //   version: QrVersions.auto,
              //   size: 200.0,
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // String scannedData = await FlutterBarcodeScanner.scanBarcode(
                  //   '#ff6666', // Color of the scanning line
                  //   'Cancel', // Cancel button text
                  //   false, // Show flash icon
                  //   ScanMode.QR, // Set to QR mode
                  // );
                  // // Process the scanned data (assuming it's a payment amount)
                  // double amountReceived = double.tryParse(scannedData) ??
                  //     0.0; // Assuming scanned data is the amount
                  // if (amountReceived > 0) {
                  //   // Handle successful QR payment
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //         content: Text(
                  //             'QR payment of \$${amountReceived.toStringAsFixed(2)} received!')),
                  //   );
                  // }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text('Scan QR Code'),
              ),
              SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: () {
                // Handle payment submission logic here
                if (selectedPaymentMethod == 'Cash' &&
                    customerName.isNotEmpty &&
                    cashAmount > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Cash payment of \$${cashAmount.toStringAsFixed(2)} received from $customerName!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Please fill all required fields for cash payment.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Submit Payment'),
            ),
            SizedBox(height: 20),
            Text(
              'Transaction History:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            // Example transaction history
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Transaction 1'),
                    subtitle: Text('Amount: \$50.00'),
                    trailing: Text('Completed'),
                  ),
                  ListTile(
                    title: Text('Transaction 2'),
                    subtitle: Text('Amount: \$100.00'),
                    trailing: Text('Completed'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
