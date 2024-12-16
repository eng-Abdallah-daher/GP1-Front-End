import 'package:first/deliveryrequests.dart';
import 'package:first/glopalvars.dart';
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
        scaffoldBackgroundColor: white,
        fontFamily: 'Helvetica',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Your Car Service',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: blueAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildFeatureCard(
              context,
              "Request Car Delivery",
              Icons.car_rental,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestCarDeliveryPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            _buildFeatureCard(
              context,
              "Emergency SOS",
              Icons.sos,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, String label, IconData icon, Function onPressed) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 30,
              left: 20,
              child: CircleAvatar(
                backgroundColor: white,
                radius: 30,
                child: Icon(icon, size: 35, color: blueAccent),
              ),
            ),
            Positioned(
              top: 30,
              left: 100,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Icon(
                Icons.arrow_forward_ios,
                color: white,
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
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Delivery'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: blueAccent),
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
                  color: blueAccent,
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
              _buildSubmitButton(),
              SizedBox(height: 20),
              _buildshowrequestsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      cursorColor: blueAccent,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: blueAccent),
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: blueAccent),
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Future<void> _selectDeliveryDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deliveryDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(pickedDate),
      );

      if (timePicked != null) {
        setState(() {
          _deliveryDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          _submitRequest();
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueAccent, Colors.lightBlueAccent],
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
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildshowrequestsButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryRequestsPage(),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueAccent, Colors.lightBlueAccent],
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
          'Show the Requests',
          style: TextStyle(
            fontSize: 20,
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;

  List<BiometricType>? _availableBiometrics;

  @override
  void initState() {
    super.initState();
 
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
      await  getbookings();
    await getDeliveryRequests();
    setState(() {
      
    });
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
      _showConfirmationDialog();
      _clearForm();
    } else {
      print("Authentication failed");
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                colors: [blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Request Confirmed",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Your car delivery request has been sent.",
                  style: TextStyle(
                    fontSize: 16,
                    color: white,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: white.withOpacity(0.8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 16,
                        color: blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitRequest() async {
    Booking? m = findCurrentBooking();
    if (m != null) {
   try{
       addDeliveryRequest(address: _addressController.text,instructions:_instructionsController.text,ownerId: m.ownerid,phone:_phoneController.text,userId:  global_user.id );
      deliveryRequests.add(DeliveryRequest(
        requestid: deliveryRequests.length,
          ownerid: m.ownerid,
          userid: global_user.id,
          phone: _phoneController.text,
          address: _addressController.text,
          instructions: _instructionsController.text));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Your delivery request has been submitted successfully!'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ));
   }catch(e){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred while submitting your request. Please try again.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
     print(e);
   }
    }
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

Booking? findCurrentBooking() {
  DateTime now = DateTime.now();

  for (var booking in bookings) {
    if (booking.userid == global_user.id &&
        now.isAfter(booking.appointment) &&
        now.isBefore(booking.appointmentDate)) {
      return booking;
    }
  }
  return null;
}
