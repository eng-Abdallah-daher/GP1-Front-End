import 'package:CarMate/EmailSender.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/ownermainpage.dart';
import 'package:flutter/material.dart';


class ManageRequestsPage extends StatefulWidget {

  
  @override
  _ManageRequestsPageState createState() => _ManageRequestsPageState();
}

class _ManageRequestsPageState extends State<ManageRequestsPage> {

    @override
  void initState() {
    super.initState();
m();
  }
  void m() async{
      await getusers();
       await getbookings();
    await getMaintenanceRequests();
    setState(() {
      
    });
  }
  DateTime addDaysAndHours(DateTime date, int days, int hours) {
    DateTime updatedDate = date.add(Duration(days: days));

    updatedDate = updatedDate.add(Duration(hours: hours));
    return updatedDate;
  }

  bool showRequestDialog(
      BuildContext context, String name, maintenancerequest m) {
    bool accp = false;
    final TextEditingController _daysController = TextEditingController();
    final TextEditingController _hoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Accept Request",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: blueAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Request for: $name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Date: ${m.time}".split(' ')[0],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Enter Time:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 15),
                Column(
                  children: [
                    TextField(
                      controller: _daysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Days",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.blue[50],
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _hoursController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Hours",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.blue[50],
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                int days = int.tryParse(_daysController.text) ?? 0;
                int hours = int.tryParse(_hoursController.text) ?? 0;

                if (days == 0 && hours == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Please enter valid days and/or hours")),
                  );
                  return;
                }

                accp = true;
                _acceptRequest(m, addDaysAndHours(m.time, days, hours));
                   User normal=users.where((element) => element.id== m.user_id,).toList()[0];
                            User owner=users.where((element) => element.id==m.owner_id,).toList()[0];
                              EmailSender.sendEmail(
                    normal.email,
                    "Accepting booking",
                    "The booking at " +
                        m.time.toString() +
                        " is accepted at the workshop of " +
                        owner.name);
                         
                           
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Request for $name accepted for $days days and $hours hours")),
                );

               
              
              },
              child: Text(
                "Accept Request",
                style: TextStyle(
                  fontSize: 18,
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    return accp;
  }

  void _acceptRequest(maintenancerequest request, DateTime after) {
  
      bookings.add(Booking(
        description: request.description,
        userid: request.user_id,
        bookingid: bookings.length,
        ownerid: request.owner_id,
        customerName: getnameofuser(request.user_id),
        appointmentDate: after,
        appointment: request.time,
        status: "Confirmed"));
     
if(bookings.isEmpty){
  addBooking(request.description,request.user_id, 0, request.owner_id, after,
          request.time, getnameofuser(request.user_id), "Confirmed");
}else{
  addBooking(
          request.description,request.user_id, bookings[bookings.length - 1].bookingid+1, request.owner_id, after,
          request.time, getnameofuser(request.user_id), "Confirmed");
}
    User normal = users
        .where(
          (element) => element.id == request.user_id,
        )
        .toList()[0];
    User owner = users
        .where(
          (element) => element.id == request.owner_id,
        )
        .toList()[0];
                           
    EmailSender.sendEmail(
        normal.email,
        "Accepting booking",
        "The booking at " +
            request.time.toString() +
            " is accepted at the workshop of " +
            owner.name);
                         
    _removeRequest(request);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ownermainpage()),
    );
index=1;   
  }

  void _removeRequest(maintenancerequest request) {
  try{
      setState(() {
       deleteMaintenanceRequest(request.requestid);
       
      maintenancerequests.remove(request);
     
    });
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request deleted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }catch(e){
       ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
          content: Text('Failed to delete request. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
  
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Requests & Maintenance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.lightBlue.shade800,
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
                  Colors.lightBlue.shade700,
                  Colors.cyan.shade600,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: maintenancerequests.length,
              itemBuilder: (context, index) {
                final request = maintenancerequests[index];
                if (maintenancerequests[index].owner_id != global_user.id) {
                  return null;
                }
                return Card(
                  color: white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shadowColor: Colors.lightBlue.withOpacity(0.5),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightBlue.shade600,
                      child: Icon(Icons.build, color: white),
                    ),
                    title: Text(
                      'Customer : ${getnameofuser(request.user_id)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                         Text(
                          'Description : ${request.description}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Request Date : ${request.time}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 3,
                      children: [
                        _buildIconButton(
                          Icons.check_circle,
                          Colors.green.shade700,
                          'Accept',
                          () {
                            print(request.time);
                            showRequestDialog(
                              context, getnameofuser(request.user_id), request);
                          },
                        ),
                        _buildIconButton(
                          Icons.delete,
                          Colors.red.shade700,
                          'Remove',
                          () {
                            User normal=users.where((element) => element.id==request.user_id,).toList()[0];
                            User owner=users.where((element) => element.id==request.owner_id,).toList()[0];
                            EmailSender.sendEmail(normal.email, "Accepting booking", "The booking at "+request.time.toString()+" is not accepted at the workshop of "+owner.name);
                            _removeRequest(request);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, Color color, String tooltip, Function() onPressed) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: color, size: 33),
        onPressed: onPressed,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ManageRequestsPage(),
  ));
}
