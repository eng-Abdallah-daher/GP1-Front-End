import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class ComplaintsListPage extends StatefulWidget {
  @override
  _ComplaintsListPageState createState() => _ComplaintsListPageState();
}

class _ComplaintsListPageState extends State<ComplaintsListPage> {
  @override
  void initState() {
    
    super.initState();
  m();
  }
  void m() async{
     await getcomplaints();
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
        backgroundColor: Colors.blueAccent,
      ),
      body: complaints.isEmpty
          ? Center(
              child: Text(
                'No Complaints Available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                if (complaints[index].ownerid == global_user.id)
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
                        complaints[index].rate.toString(),
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
                            'Description: ${complaints[index].description}',
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

                else
                  return SizedBox(
                    height: 0,
                  );
              },
            ),
    );
  }
}
