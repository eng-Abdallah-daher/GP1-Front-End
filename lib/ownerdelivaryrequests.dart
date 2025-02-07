import 'package:CarMate/EmailSender.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';


class OwnerDeliveryRequestsPage extends StatefulWidget {
  @override
  _OwnerDeliveryRequestsPageState createState() =>
      _OwnerDeliveryRequestsPageState();
}

class _OwnerDeliveryRequestsPageState extends State<OwnerDeliveryRequestsPage> {
 
  @override
  void initState() {
    super.initState();
    m();
  }
  void m()async{
    await getDeliveryRequests();
    setState(() {
      
    });
  }

  String _selectedStatusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    List<DeliveryRequest> filteredRequests = deliveryRequests
        .where((request) =>
            (_selectedStatusFilter == 'All' ||
                request.status == _selectedStatusFilter) &&
            request.ownerid == global_user.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Requests',
          style: TextStyle(fontSize: 24, color: white),
        ),
        backgroundColor: Colors.blue[900],
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedStatusFilter = value;
              });
            },
            icon: Icon(Icons.filter_alt, size: 28, color: white),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'All', child: Text('All')),
              PopupMenuItem(value: 'Pending', child: Text('Pending')),
              PopupMenuItem(value: 'Completed', child: Text('Completed')),
              PopupMenuItem(value: 'Cancelled', child: Text('Cancelled')),
            ],
          )
        ],
      ),
      body: filteredRequests.isEmpty
          ? Center(
              child: Text(
                'No requests available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredRequests.length,
              itemBuilder: (context, index) {
                final request = filteredRequests[index];
                return _buildRequestCard(request);
              },
            ),
    );
  }

  Widget _buildRequestCard(DeliveryRequest request) {
    return Card(
      elevation: 8,
      color: Colors.blue[100],
      shadowColor: Colors.blue[900],
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue[900], size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    getnameofuser(request.userid),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    request.status,
                    style: TextStyle(
                        color: white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: _getStatusColor(request.status),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildDetailRow(Icons.phone, blue, request.phone),
            SizedBox(height: 10),
            _buildDetailRow(
                Icons.location_on, Colors.deepPurple, request.address),
            SizedBox(height: 10),
            _buildDetailRow(Icons.info, Colors.teal, request.instructions),
            SizedBox(height: 16),
            Divider(color: Colors.grey[400], thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (request.status != 'Completed')
                  ElevatedButton.icon(
                    onPressed: () {
                     try{
                       setState(() {
                        if (request.status == 'Pending') {
                          updateDeliveryRequestStatus(request.requestid,'Confirmed');
                          request.status = 'Confirmed';
                        } else if (request.status == 'Confirmed') {
                              updateDeliveryRequestStatus(
                              request.requestid, 'Completed');
                          request.status = 'Completed';
                        }
                      });
                      EmailSender.sendEmail(users.where((element) => element.id==request.userid,).toList()[0].email, "Delivery Request", "You new delivery request status is " + request.status);
                     }catch(e){

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update delivery request'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                     }
                    },
                    icon: Icon(
                      request.status == 'Pending'
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: white,
                    ),
                    label: Text(
                      request.status == 'Pending'
                          ? 'Mark as Confirmed'
                          : 'Mark as Completed',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orangeAccent;
      case 'Completed':
        return Colors.green;
      case 'Confirmed':
        return blue;
      default:
        return Colors.grey;
    }
  }
}
