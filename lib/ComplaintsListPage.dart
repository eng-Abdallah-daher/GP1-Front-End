import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class ComplaintsListPage extends StatefulWidget {
  @override
  _ComplaintsListPageState createState() => _ComplaintsListPageState();
}

class _ComplaintsListPageState extends State<ComplaintsListPage> {
  List<Complaint> filteredcomplaints = [];
  @override
  void initState() {
    
    super.initState();
  m();
  }
  void m() async{
     await getcomplaints();
   

     filteredcomplaints=complaints.where((element) => element.ownerid==global_user.id,).toList();
       for (int i = 0; i < filteredcomplaints.length; i++) {
      print(filteredcomplaints[i].ownerid);
    }
     setState(() {
       
     });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaints & Feedback List',
          style: TextStyle(color: white, fontSize: 18),
        ),
        backgroundColor: blueAccent,
      ),
      body: filteredcomplaints.isEmpty
          ? Center(
              child: Text(
                'No Complaints Available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: filteredcomplaints.length,
              itemBuilder: (context, index) {
               
                  return Card(
                    elevation: 12,
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    color: Colors.blue.shade100,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(24),
                      title: Text(
                        filteredcomplaints[index].rate.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          color: Colors.deepOrangeAccent,
                          letterSpacing: 1.5,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description: ${filteredcomplaints[index].description}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 10),
                         
                        ],
                      ),
                    ),
                  );

                
              },
            ),
    );
  }
}
