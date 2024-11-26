import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class ComplaintsListPage extends StatelessWidget {
  ComplaintsListPage();

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
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        complaints[index].rate.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blueAccent,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description: ${complaints[index].description}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Submitted By: ${complaints[index].userName}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
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
