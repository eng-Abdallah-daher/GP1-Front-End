import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaintenanceReminderPage extends StatefulWidget {
  @override
  _MaintenanceReminderPageState createState() =>
      _MaintenanceReminderPageState();
}

class _MaintenanceReminderPageState extends State<MaintenanceReminderPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _lastMaintenanceController = TextEditingController();
  TextEditingController _mileageController = TextEditingController();

  DateTime? _lastMaintenanceDate;
  DateTime? _nextReminderDate;

  @override
  void dispose() {
    _lastMaintenanceController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  m();
  }
  void m()async{
     await  getMaintenanceRecords();
    MaintenanceRecord m = findMostRecentRecord(maintenanceRecords);
    _lastMaintenanceController.text = m.getFormattedDate();
    setState(() {
      
    });
  }

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
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              _buildDateInputField(
                label: "Last Maintenance Date",
                hint: "Select date",
                controller: _lastMaintenanceController,
                validatorMessage: "Please enter the last maintenance date",
                onTap: () => _selectLastMaintenanceDate(context),
              ),
              SizedBox(height: 20),
              _buildInputField(
                label: "Maintenance Miledesciption",
                hint: "e.g., i want to fix ...",
                controller: _mileageController,
                inputType: TextInputType.text,
                validatorMessage: "Please enter the current description",
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
                      String lastMaintenanceDate =
                          _lastMaintenanceController.text;
                      String carMileage = _mileageController.text;

                      String mileage = carMileage;

                      if (mileage == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please enter a valid mileage number.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      DateTime? parseStringToDate(String dateString) {
                        try {
                          return DateTime.parse(dateString);
                        } catch (e) {
                          try {
                            List<String> parts = dateString.split('-');
                            if (parts.length == 3) {
                              int day = int.parse(parts[0]);
                              int month = int.parse(parts[1]);
                              int year = int.parse(parts[2]);
                              return DateTime(year, month, day);
                            }
                          } catch (e) {
                            return null;
                          }
                        }
                        return null;
                      }
try{
addMaintenanceRecord(id: maintenanceRecords.length,userId: global_user.id, date: _nextReminderDate!, description: mileage);
                      maintenanceRecords.add(MaintenanceRecord(
                        id: maintenanceRecords.length,
                          date: _nextReminderDate!,
                          description: mileage,
                          userid: global_user.id));


                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reminder Set Successfully!'),
                          backgroundColor: Colors.blue.shade800,
                        ),
                      );}catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to set reminder. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.check_circle_outline, color: white),
                  label: Text(
                    'Set Maintenance Reminder',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: white,
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

  Widget _buildDateInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String validatorMessage,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      enabled: controller == _lastMaintenanceController ? false : true,
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
        prefixIcon: Icon(Icons.date_range, color: Colors.blue.shade800),
      ),
      readOnly: true,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
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
        prefixIcon: Icon(Icons.speed, color: Colors.blue.shade800),
      ),
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        if (inputType == TextInputType.number &&
            double.tryParse(value) == null) {
          return 'Please enter a valid number';
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
      onTap: () => _selectNextReminderDate(context),
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
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.blue.shade800,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
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

  Future<void> _selectLastMaintenanceDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastMaintenanceDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: _buildDatePickerTheme,
    );
    if (picked != null && picked != _lastMaintenanceDate) {
      setState(() {
        _lastMaintenanceDate = picked;

        _lastMaintenanceController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectNextReminderDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _nextReminderDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: _buildDatePickerTheme,
    );
    if (picked != null && picked != _nextReminderDate) {
      setState(() {
        _nextReminderDate = picked;
      });
    }
  }

  Widget Function(BuildContext, Widget?) get _buildDatePickerTheme =>
      (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.blue.shade50,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade800,
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
      };
}
