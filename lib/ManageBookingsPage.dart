import 'package:first/AddBookingPage.dart';
import 'package:first/EditBookingPage.dart';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class ManageBookingsPage extends StatefulWidget {
  @override
  _ManageBookingsPageState createState() => _ManageBookingsPageState();
}

class _ManageBookingsPageState extends State<ManageBookingsPage> {
  List<Booking> filteredBookings = [];
  String searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Filter bookings to only show those owned by the current user
  filteredBookings=bookings;
  }

  void _filterBookings(String query) {
    setState(() {
      searchQuery = query;
      filteredBookings = bookings
          .where((booking) =>
              booking.customerName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Bookings & Appointments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 8,
        shadowColor: Colors.black54,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.lightBlue.shade200,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _filterBookings,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    labelText: 'Search Bookings',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue.shade700,
                    ),
                    hintText: 'Enter customer name',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.blue.shade700,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.blue.shade300,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.blue.shade700,
                        width: 2,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey.shade600),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          searchQuery = '';
                          filteredBookings = bookings;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: filteredBookings.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredBookings.where((element) => (element.ownerid==global_user.id)&&(element.status=="Confirmed"),).length,
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];

                         return booking.status =="Confirmed" ? Card(
                              color: Colors.white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 10,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              shadowColor: Colors.blue.withOpacity(0.5),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: Icon(Icons.calendar_today,
                                      color: Colors.white),
                                ),
                                title: Text(
                                  booking.customerName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text(
                                      'Appointment Date: ${booking.getFormattedDate()}',
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                    Text(
                                      'Status: ${booking.status}',
                                      style: TextStyle(
                                        color: _getStatusColor(booking.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Wrap(
                                  spacing: 10,
                                  children: [
                                    _buildIconButton(
                                      Icons.notifications_active,
                                      Colors.blue.shade600,
                                      'Send Notification',
                                      () => _sendNotification(
                                          context, booking.customerName),
                                    ),
                                    _buildIconButton(
                                      Icons.edit,
                                      Colors.orange.shade700,
                                      'Edit Booking',
                                      () => _manageBooking(context, booking),
                                    ),
                                    if (booking.status == 'Confirmed')
                                      _buildIconButton(
                                        Icons.done,
                                        Colors.green.shade700,
                                        'Mark as Completed',
                                        () => _showCompleteDialog(
                                            context, booking),
                                      ),
                                  ],
                                ),
                              ),
                            ): SizedBox(height: 0,);
                          },
                        )
                      : Center(
                          child: Text(
                            'No bookings found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue.shade700,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Add Booking', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookingPage()),
          ).then((_) {
            setState(() {});
          });
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildIconButton(
      IconData icon, Color color, String tooltip, Function() onPressed) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: color, size: 28),
        onPressed: onPressed,
      ),
    );
  }

  void _sendNotification(BuildContext context, String customerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification sent to $customerName'),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  void _manageBooking(BuildContext context, Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookingPage(booking: booking),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _showCompleteDialog(BuildContext context, Booking booking) {
    TextEditingController _costController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent.shade100, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 50,
                  color: Colors.green.shade700,
                ),
                SizedBox(height: 10),
                Text(
                  'Complete Booking',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'How much did it cost?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _costController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter cost',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.blue.shade300, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.blue.shade600, width: 2),
                    ),
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.cancel, color: Colors.red.shade700),
                      label: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red.shade700, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        foregroundColor: Colors.red.shade700,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final cost =
                            double.tryParse(_costController.text.trim());
                        if (cost != null && cost >= 0) {
                          setState(() {
                            booking.status = 'Completed';
                        sales.add(Sale(ownerid: global_user.id, itemid: -1, quantity: 0, price: cost, date: DateTime(1,1,1)));
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Booking marked as Completed.'),
                              backgroundColor: Colors.green.shade700,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a valid cost.'),
                              backgroundColor: Colors.red.shade700,
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.done, color: Colors.white),
                      label: Text('Complete',style: TextStyle(color: white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
