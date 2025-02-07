import 'package:CarMate/ComplaintsListPage.dart';
import 'package:CarMate/ComplaintsManagementPage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/updateview.dart';
import 'package:CarMate/usermainpage.dart';
import 'package:flutter/material.dart';
class ViewWorkshopRatingsPage extends StatefulWidget {
  @override
  _ViewWorkshopRatingsPageState createState() =>
      _ViewWorkshopRatingsPageState();
}
class _ViewWorkshopRatingsPageState extends State<ViewWorkshopRatingsPage> {
    @override
  void initState()  {
  m();
    super.initState();
   
  }
  void m() async {
    await getusers();
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            index=1;
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => usermainpage(),
              ),
            );
          },
        ),
          actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComplaintsListPage(),
                ),
              );
            },
            tooltip: 'View Complaints',
          ),
        ],
        title: Text(
          "Workshop Ratings",
          
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: blueAccent,
        elevation: 10.0,
        centerTitle: true,
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            if ((users[index].role == "owner")&&(users[index].isServiceActive)) {
              return Center(child: Container(
                  width: MediaQuery.of(context).size.width > 600
                      ? 500
                      : double.infinity,
                  child: _buildWorkshopRatingCard(context, users[index]),),);
            } else {
              return SizedBox(height: 0);
            }
          },
        ),
      ),
    );
  }

  Widget _buildWorkshopRatingCard(BuildContext context, User rating) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {
            _onArrowTap(context, rating);
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              rating.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      rating.getaveragerate().toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  rating.description!,
                  style: TextStyle(
                    fontSize: 16,
                    color: black,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue.shade600,
            ),
          ),
        ),
      ),
    );
  }

  void _onArrowTap(BuildContext context, User rating) async{
    
   await getusers();
   await getcomplaints();
    if (global_user.israted(rating.id)) { 
    
        Complaint p = complaints
          .where((element) =>
              (element.ownerid == rating.id) &&
              (element.userid == global_user.id))
          .toList()[0];
        
 showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.blue.shade50,
            title: Center(
              child: Text(
                "Already Rated",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                "You have already rated this workshop. What would you like to do?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.blue.shade600,
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.8,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    await getcomplaints();
                    Navigator.of(context).pop();
                  setState(() {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComplaintsupdatePage(c: p),
                      ),
                    );
                  });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Edit Review",
                    style: TextStyle(
                      color: white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: ()  {
                     removeComplaint(p.id);
                      
                 
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewWorkshopRatingsPage()
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Review removed successfully."),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Remove Review",
                    style: TextStyle(
                      color: white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );


    } else {
      
      setState(() {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComplaintsManagementPage(
              ownerid: rating.id,
            ),
          ),
        );
        
      });
      await getcomplaints();
      setState(() {
        
      });
    
    }
  }
}
