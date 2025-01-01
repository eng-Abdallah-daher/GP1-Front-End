import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(RequestApp());
}

class RequestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlacesPage(),
    );
  }
}

class PlacesPage extends StatefulWidget {
  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {

    @override
  void initState() {
    super.initState();
   
m();
  }
  void m() async {
       await getMaintenanceRequests();
       setState(() {
         
       });
  }
  TextEditingController _searchController = TextEditingController();

  List<User> filteredUsers = users.sublist(1, users.length);

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = users.sublist(1, users.length).where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Places"),
        backgroundColor: blue,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => usermainpage(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Search for a place...",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                if (user.role == "normal") {
                  return Container();
                }
                return Card(
                  elevation: 6,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectTimePage(user: user),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              user.profileImage!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: blue,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  user.description!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
}

class SelectTimePage extends StatefulWidget {
  final User user;
  SelectTimePage({required this.user});

  @override
  _SelectTimePageState createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  DateTime _selectedDateTime = DateTime.now();

  void _selectDateAndTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != _selectedDateTime) {
      setState(() {
        _selectedDateTime = pickedDate;
      });

      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            _selectedDateTime.year,
            _selectedDateTime.month,
            _selectedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Date & Time"),
        backgroundColor: blue,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.user.description!,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Select Date & Time:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            ElevatedButton(
              onPressed: _selectDateAndTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Choose Date & Time",
                style: TextStyle(fontSize: 16, color: white),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Selected Date: ${_selectedDateTime.toLocal()}".split(' ')[0],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Selected Time: ${TimeOfDay.fromDateTime(_selectedDateTime).format(context)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedDateTime != null) {
                   try{
                     addMaintenanceRequest(ownerId:widget.user.id,userId: global_user.id,time: _selectedDateTime,requestId: maintenancerequests.length );
                    maintenancerequests.add(maintenancerequest(
                        requestid: maintenancerequests.length,
                        owner_id: widget.user.id,
                        user_id: global_user.id,
                        time: _selectedDateTime));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Request submitted for ${widget.user.name} on ${_selectedDateTime.toLocal()} at ${TimeOfDay.fromDateTime(_selectedDateTime).format(context)}.",
                        ),
                      ),
                    );
                   }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error submitting request: ${e.toString()}"),backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                   }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select a date and time!"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Submit Request",
                  style: TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
