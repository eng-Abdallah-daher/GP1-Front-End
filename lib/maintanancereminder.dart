import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class MaintenanceReminderPage extends StatefulWidget {
  @override
  _MaintenanceReminderPageState createState() =>
      _MaintenanceReminderPageState();
}

class _MaintenanceReminderPageState extends State<MaintenanceReminderPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _lastMaintenanceController = TextEditingController();
  TextEditingController _mileageController = TextEditingController();
  DateTime? _nextReminderDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Maintenance Reminder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 10.0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Set Up Your Maintenance Reminder",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 20),
              _buildInputField(
                label: "Last Maintenance Date",
                hint: "e.g., 2023-09-25",
                controller: _lastMaintenanceController,
                validatorMessage: "Please enter the last maintenance date",
              ),
              SizedBox(height: 20),
              _buildInputField(
                label: "Car Mileage (km)",
                hint: "e.g., 15000",
                controller: _mileageController,
                inputType: TextInputType.number,
                validatorMessage: "Please enter the current mileage",
              ),
              SizedBox(height: 20),
              _buildDatePickerTile(),
              SizedBox(height: 20),
              if (_nextReminderDate != null) _buildReminderSign(),
              SizedBox(height: 30),
             Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Capture the input from the text fields
                      String lastMaintenanceDate =
                          _lastMaintenanceController.text;
                      String carMileage = _mileageController.text;

                      // Convert mileage to an integer
                      int? mileage = int.tryParse(carMileage);

                      if (mileage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please enter a valid mileage number.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Process the reminder setup logic here
                      // For demonstration, print the input values
                      print("Last Maintenance Date: $lastMaintenanceDate");
                      print("Car Mileage: $mileage");

                      // Show confirmation snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reminder Set Successfully!'),
                          backgroundColor: Colors.blue.shade800,
                        ),
                      );

                      // You can also update _nextReminderDate or perform any other logic here
                    }
                  },
                  icon: Icon(Icons.check_circle_outline, color: Colors.white),
                  label: Text(
                    'Set Maintenance Reminder',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8.0,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String validatorMessage,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.blue.shade800),
        hintStyle: TextStyle(color: Colors.blue.shade300),
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
        ),
        prefixIcon: label.contains("Date")
            ? Icon(Icons.date_range, color: Colors.blue.shade800)
            : Icon(Icons.speed, color: Colors.blue.shade800),
      ),
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerTile() {
    return ListTile(
      title: Text(
        _nextReminderDate == null
            ? "No Reminder Set"
            : "Next Reminder: ${DateFormat('yyyy-MM-dd').format(_nextReminderDate!)}",
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue.shade800,
        ),
      ),
      trailing: Icon(
        Icons.calendar_today,
        color: Colors.blue.shade800,
      ),
      onTap: () => _selectDate(context),
      tileColor: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildReminderSign() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100, // Light blue background for sign
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.blue.shade800, // Blue border for sign
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.blue.shade300.withOpacity(0.5), // Shadow for 3D effect
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.alarm, size: 28, color: Colors.blue.shade800),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Next Maintenance Reminder: ${DateFormat('yyyy-MM-dd').format(_nextReminderDate!)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor:
                Colors.blue.shade50, // Dialog background color
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade800, // Button text color
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              dayStyle: TextStyle(color: Colors.blue.shade800),
             
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _nextReminderDate) {
      setState(() {
        _nextReminderDate = picked;
      });
    }
  }
}


