import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/ownermainpage.dart';
import 'package:CarMate/usermainpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(CreditCardPage());
}

class CreditCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Credit Card Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 4,
          shadowColor: Colors.blue[100],
        ),
        body: CreditCardForm(),
      ),
    );
  }
}

class CreditCardForm extends StatefulWidget {
  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  final _formKey = GlobalKey<FormState>();

  String? _cardHolderName;
  String? _cardNumber;
  String? _expirationDate;
  String? _cvv;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return  Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: screenWidth > 600 ? 500 : double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Card(
          elevation: 12,
          shadowColor: Colors.blue[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Enter Your Credit Card Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.0),

                  // Cardholder Name Field
                  _buildTextField(
                    label: 'Cardholder Name',
                    icon: Icons.person,
                    onSaved: (value) => _cardHolderName = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter cardholder name' : null,
                  ),
                  SizedBox(height: 16.0),

                  // Card Number Field
                  _buildTextField(
                    label: 'Card Number',
                    icon: Icons.credit_card,
                    maxLength: 16,
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _cardNumber = value,
                    validator: (value) => value!.length != 16
                        ? 'Enter a valid 16-digit card number'
                        : null,
                  ),
                  SizedBox(height: 16.0),

                  // Expiration Date Field
                  _buildTextField(
                    label: 'Expiration Date (MM/YY)',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.datetime,
                    onSaved: (value) => _expirationDate = value,
                    validator: (value) =>
                        !RegExp(r"^(0[1-9]|1[0-2])\/\d{2}").hasMatch(value!)
                            ? 'Enter a valid expiration date'
                            : null,
                  ),
                  SizedBox(height: 16.0),

                  // CVV Field
                  _buildTextField(
                    label: 'CVV',
                    icon: Icons.lock,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    onSaved: (value) => _cvv = value,
                    validator: (value) =>
                        value!.length != 3 ? 'Enter a valid CVV' : null,
                  ),
                  SizedBox(height: 32.0),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 18.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 8,
                      ),
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    int? maxLength,
    TextInputType? keyboardType,
    bool obscureText = false,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.blue[50],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
      ),
      maxLength: maxLength,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator,
    );
  }

  void _handleSubmit() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
   await updateaccountnumber(_cardNumber!);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Payment Info Saved',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          content: Text(
            'Cardholder: $_cardHolderName\nCard Number: $_cardNumber\nExpiration Date: $_expirationDate',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        ),
      );
  
  global_user.accountnumber=_cardNumber!;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>global_user.role=="owner"?ownermainpage():usermainpage(),
        ),
      );
    }
  }
}
