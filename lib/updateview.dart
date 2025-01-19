import 'package:CarMate/ComplaintsListPage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class ComplaintsupdatePage extends StatefulWidget {
Complaint c;
  ComplaintsupdatePage({required this.c});

  @override
  _ComplaintsupdatePageState createState() =>
      _ComplaintsupdatePageState();
}

class _ComplaintsupdatePageState extends State<ComplaintsupdatePage> {
  @override
  void initState() {
    descriptionController.text=widget.c.description;
    rating=widget.c.rate;
    super.initState();
    m();
  }

  void m() async {
    await getcomplaints();
    setState(() {});
  }

  final TextEditingController descriptionController = TextEditingController();

  int rating = 0;

  void _rateComplaint(int rate) {
    setState(() {
      rating = rate;
    });
  }

  void updateComplaint() {
    setState(() {
      try {
      updatecomplaint(widget.c.id, rating, descriptionController.text);
      
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Complaint updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        descriptionController.clear();

        rating = 0;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update complaint, please try again later'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('update Complaints & Feedback'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'update a Complaint',
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
      onPressed: updateComplaint,
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
