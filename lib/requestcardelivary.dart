import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Service App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Car Service Features')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildActionButton(
              Icons.delivery_dining,
              "Request Car Delivery",
              Colors.white,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestCarDeliveryPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, Function onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon, color: Colors.blue),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: color, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestCarDeliveryPage extends StatefulWidget {
  @override
  _RequestCarDeliveryPageState createState() => _RequestCarDeliveryPageState();
}

class _RequestCarDeliveryPageState extends State<RequestCarDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  DateTime? _deliveryDateTime;

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticated = false;
  List<BiometricType>? _availableBiometrics;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    List<BiometricType>? availableBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      canCheckBiometrics = false;
      availableBiometrics = [];
      print("Error checking biometrics: $e");
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint or use face recognition to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Error using biometrics: $e");
    }

    setState(() {
      _isAuthenticated = authenticated;
    });

    if (_isAuthenticated) {
      print("Authentication successful");
      _submitRequest(); // Call _submitRequest here if authentication is successful
    } else {
      print("Authentication failed");
    }
  }

  void _submitRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Submit the delivery request
      await _authenticateWithBiometrics();
      if (_isAuthenticated) {
        _showConfirmationDialog();
        _clearForm();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Delivery'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueAccent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fill in the details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(_nameController, "Your Name"),
              SizedBox(height: 20),
              _buildTextField(_phoneController, "Phone Number",
                  keyboardType: TextInputType.phone),
              SizedBox(height: 20),
              _buildTextField(_addressController, "Delivery Address"),
              SizedBox(height: 20),
              _buildTextField(
                  _instructionsController, "Additional Instructions",
                  maxLines: 3),
              SizedBox(height: 20),
              _buildDateTimePicker(context),
              SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            _deliveryDateTime = pickedDate;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Text(
          _deliveryDateTime == null
              ? 'Select Delivery Date'
              : '${_deliveryDateTime!.toLocal()}'.split(' ')[0],
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        //   if (_canCheckBiometrics &&
        //     (_availableBiometrics?.contains(BiometricType.fingerprint) ??
        //         false)) {
        //   _authenticateWithBiometrics();
        // } else {
        //   _submitRequest();
        // }
        _submitRequest();
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Text(
          'Submit Request',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    print("Form Submitted");
    // Implement form submission logic
  }

  Future<void> _selectDeliveryDateTime(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(picked),
      );

      if (timePicked != null) {
        setState(() {
          _deliveryDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Request Submitted"),
          content: Text(
              "Your car delivery request has been submitted successfully."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();
    _instructionsController.clear();
    setState(() {
      _deliveryDateTime = null;
    });
  }
}
