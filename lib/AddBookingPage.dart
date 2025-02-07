import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class AddBookingPage extends StatefulWidget {
  @override
  _AddBookingPageState createState() => _AddBookingPageState();
}

class _AddBookingPageState extends State<AddBookingPage> {

  @override
  void initState() {
   
    super.initState();
    m();
  }
  void m() async {
    await getbookings();
    setState(() {});
  }
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  DateTime? _selectedDate;
  String _status = 'Pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Booking',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 8,
        shadowColor: Colors.black54,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              white,
              Colors.lightBlue.shade100,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(),
              SizedBox(height: 20),
              _buildDateSelector(),
           

              SizedBox(height: 30),
              _buildAddBookingButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField() {
    return TextFormField(
      controller: _customerNameController,
      decoration: InputDecoration(
        labelText: 'Customer Name',
        labelStyle: TextStyle(
          color: Colors.blue.shade700,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the customer\'s name';
        }
        return null;
      },
    );
  }

  ListTile _buildDateSelector() {
    return ListTile(
      title: Text(
        _selectedDate == null
            ? 'Select Appointment Date'
            : 'Selected Date: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year} ${_selectedDate!.hour}:${_selectedDate!.minute}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade700,
        ),
      ),
      trailing: Icon(Icons.calendar_today, color: Colors.blue.shade700),
      onTap: _pickDateTime,
    );
  }

  DropdownButtonFormField<String> _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _status,
      items: ['Pending', 'Confirmed', 'Completed'].map((status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _status = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Status',
        labelStyle: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
        ),
        filled: true,
        fillColor: Colors.lightBlue.shade50,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      dropdownColor: white,
      style: TextStyle(color: Colors.blue.shade700, fontSize: 16),
      icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
    );
  }

  ElevatedButton _buildAddBookingButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate() && _selectedDate != null) {
          setState(() {
           try{
             if(bookings.isEmpty){
                bookings.add(Booking(
                  description: "",
                  appointment: DateTime.now(),
                  userid: -1,
                  bookingid: bookings.length,
                  ownerid: global_user.id,
                  customerName: _customerNameController.text,
                  appointmentDate: _selectedDate!,
                  status: "Confirmed",
                ));

                addBooking(
                    "",
                    -1,
                    bookings.length,
                    global_user.id,
                    _selectedDate!,
                    DateTime.now(),
                    _customerNameController.text,
                    "Confirmed");
             }else{
                bookings.add(Booking(
                  description: "",
                  appointment: DateTime.now(),
                  userid: -1,
                  bookingid: bookings[bookings.length - 1].bookingid + 1,
                  ownerid: global_user.id,
                  customerName: _customerNameController.text,
                  appointmentDate: _selectedDate!,
                  status: "Confirmed",
                ));

                addBooking(
                    "",
                    -1,
                    bookings[bookings.length-1].bookingid+1,
                    global_user.id,
                    _selectedDate!,
                    DateTime.now(),
                    _customerNameController.text,
                    "Confirmed");
             }
         

            _customerNameController.clear();
            _selectedDate = null;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Booking added successfully.'),
              backgroundColor: Colors.green,
            ));
           }catch(e){
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to add booking. Please try again.'),
                backgroundColor: Colors.redAccent,
              ));
 
           }
          });
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (_selectedDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please select a date.'),
            backgroundColor: Colors.redAccent,
          ));
        }
      },
      child: Text(
        'Add Booking',
        style: TextStyle(color: white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 9, minute: 0),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }
}
