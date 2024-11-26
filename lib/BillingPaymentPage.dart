import 'package:flutter/material.dart';

class BillingPaymentPage extends StatefulWidget {
  @override
  _BillingPaymentPageState createState() => _BillingPaymentPageState();
}

class _BillingPaymentPageState extends State<BillingPaymentPage> {
  final double totalAmountDue = 150.0;
  final List<String> paymentMethods = ['Cash', 'QR Code'];

  String? selectedPaymentMethod;
  String customerName = '';
  double cashAmount = 0.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing & Payment'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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

                    if (newValue != 'Cash') {
                      cashAmount = 0.0;
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      customerName = value;
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
                  validator: (value) {
                    if (value == null ||
                        double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      cashAmount = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
                SizedBox(height: 20),
              ] else if (selectedPaymentMethod == 'QR Code') ...[
                Text(
                  'QR Code for Payment:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
              ],
              ElevatedButton(
                onPressed: () {
                  if (selectedPaymentMethod == 'Cash') {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Cash payment of \$${cashAmount.toStringAsFixed(2)} received from $customerName!'),
                        ),
                      );
                    }
                  } else if (selectedPaymentMethod == 'QR Code') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('QR Code payment initiated.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please select a payment method.')),
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
      ),
    );
  }
}
