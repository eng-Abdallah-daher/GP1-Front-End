import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class DeliveryRequestsPage extends StatefulWidget {
  @override
  _DeliveryRequestsPageState createState() => _DeliveryRequestsPageState();
}

class _DeliveryRequestsPageState extends State<DeliveryRequestsPage> {


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Requests',
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: blue,
        elevation: 5,
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: deliveryRequests.isEmpty
            ? Center(
                child: Text(
                  'No delivery requests available.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: deliveryRequests.length,
                itemBuilder: (context, index) {
                  final request = deliveryRequests[index];
                  return _buildDeliveryCard(request, index);
                },
              ),
      ),
    );
  }

  Widget _buildDeliveryCard(DeliveryRequest request, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: blueAccent, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping, color: blue, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Delivery Request for User ID: ${request.userid}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildDetailRow(
                Icons.person, 'Store', getnameofuser(request.ownerid)),
            _buildDetailRow(Icons.phone, 'Phone', request.phone),
            _buildDetailRow(Icons.location_on, 'Address', request.address),
            if (request.instructions.isNotEmpty)
              _buildDetailRow(
                  Icons.info_outline, 'Instructions', request.instructions),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusBackgroundColor(request.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (request.status != 'Completed') ...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _deleteRequest(index),
                    icon: Icon(Icons.delete, color: white),
                    label: Text('Delete',style: TextStyle(color: white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (request.status == 'Pending' ||
                      request.status == 'Confirmed')
                    ElevatedButton.icon(
                      onPressed: () => _updateRequest(index),
                      icon: Icon(Icons.edit, color: white),
                      label: Text('Update',
                        style: TextStyle(color: white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: blue, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.blue[900]),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return blue;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _deleteRequest(int index) {
    try{
      setState(() {
      deleteDeliveryRequest(deliveryRequests[index].requestid);
      deliveryRequests.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request deleted successfully'),
        backgroundColor: blue,
      ),
    );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateRequest(int index) {
    final request = deliveryRequests[index];
    showDialog(
      context: context,
      builder: (context) {
        String newPhone = request.phone;
        String newAddress = request.address;
        String newInstructions = request.instructions;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              'Update Request',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.blue[800],
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blueAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blue, width: 2),
                    ),
                    prefixIcon: Icon(Icons.phone, color: blue),
                  ),
                  controller: TextEditingController(text: request.phone),
                  onChanged: (value) => newPhone = value,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blueAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blue, width: 2),
                    ),
                    prefixIcon: Icon(Icons.location_on, color: blue),
                  ),
                  controller: TextEditingController(text: request.address),
                  onChanged: (value) => newAddress = value,
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Instructions',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blueAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blue, width: 2),
                    ),
                    prefixIcon: Icon(Icons.info, color: blue),
                  ),
                  controller: TextEditingController(text: request.instructions),
                  onChanged: (value) => newInstructions = value,
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {


try{
  updateDeliveryRequest(request.requestid,newPhone,newAddress,newInstructions);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Request updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
}catch(e){
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error updating request: $e'),
      backgroundColor: Colors.red,
    ),);
  
}
});
                 setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Update',
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DeliveryRequestsPage(),
    debugShowCheckedModeBanner: false,
  ));
}
