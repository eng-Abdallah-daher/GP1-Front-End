import 'package:first/ComplaintsListPage.dart';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class ComplaintsManagementPage extends StatefulWidget {
  int ownerid;
  ComplaintsManagementPage({required this.ownerid});

  @override
  _ComplaintsManagementPageState createState() =>
      _ComplaintsManagementPageState();
}

class _ComplaintsManagementPageState extends State<ComplaintsManagementPage> {

  @override
  void initState() {
    
    super.initState();
   m();
  }
  void m() async{
    await  getcomplaints();
    setState(() {
      
    });
  }
  final TextEditingController descriptionController = TextEditingController();

  int rating = 0;

  void _rateComplaint(int rate) {
    setState(() {
      rating = rate;
    });
  }

  void addComplaint() {
    setState(() {
try{
addRating(descriptionController.text,global_user.name,widget.ownerid,rating);
addRate(global_user.id, widget.ownerid);
      complaints.add(Complaint(
        description: descriptionController.text,
        userName: global_user.name,
        ownerid: widget.ownerid,
        rate: rating,
      ));
      global_user.rates.add(widget.ownerid);
      for (int i = 1; i < users.length; i++) {
        if (users[i].id == widget.ownerid) {
          addRate(
              widget.ownerid, rating);
          users[i].rates.add(rating);

          break;
        }
      }
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complaint submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);

      descriptionController.clear();

      rating = 0;}catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit complaint, please try again later'),
          backgroundColor: Colors.red,
        ),);
      }
    
    });

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Complaints & Feedback'),
        backgroundColor: Colors.blueAccent,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit a New Complaint',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            _buildDescriptionInput(),
            SizedBox(height: 20),
            _buildRatingSection(),
            SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: descriptionController,
          maxLines: 4,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
            hintText: 'Describe the issue in detail...',
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            fillColor: Colors.blue[50],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.blueAccent.withOpacity(0.5),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.blueAccent,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate the Complaint (1 - 5 stars)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => _rateComplaint(index + 1),
              child: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.yellow[700],
                size: 35,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: addComplaint,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        elevation: 5,
      ),
      child: Text(
        'Submit Complaint',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
