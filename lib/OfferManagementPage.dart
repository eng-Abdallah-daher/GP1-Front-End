// import 'package:first/OffersListPage.dart';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class OfferManagementPage extends StatefulWidget {
  OfferManagementPage();

  @override
  _OfferManagementPageState createState() => _OfferManagementPageState();
}

class _OfferManagementPageState extends State<OfferManagementPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController posterNameController = TextEditingController();
  DateTime? validUntil;

  void addOffer() {
    setState(() {
      offers.add(Offer(
        title: titleController.text,
        description: descriptionController.text,
        discount: double.parse(discountController.text),
        validUntil: validUntil ?? DateTime.now().add(Duration(days: 30)),
        posterid: 2
      ));

      // Clear fields after adding
      titleController.clear();
      descriptionController.clear();
      discountController.clear();
      posterNameController.clear();
      validUntil = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Offer added successfully!'),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> pickValidUntilDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        validUntil = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offer Management',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // Navigate to the Offers List Page
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => OffersListPage(),
              //   ),
              // );
            },
            tooltip: 'View Offers',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Create New Offer',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 24),
            buildTextField(titleController, 'Offer Title',
                'Enter the title for your offer'),
            SizedBox(height: 16),
            buildTextField(
              descriptionController,
              'Offer Description',
              'Describe your offer',
              maxLines: 3,
            ),
            SizedBox(height: 16),
            buildDiscountField(), // Discount field with max limit of 99
            SizedBox(height: 16),
            buildTextField(
                posterNameController, 'Posted By', 'Your name or business'),
            SizedBox(height: 16),
            // Gradient TextButton for Select Valid Until Date
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: TextButton(
                onPressed: () => pickValidUntilDate(context),
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: Text(
                  validUntil == null
                      ? 'Select Valid Until Date'
                      : 'Valid Until: ${validUntil!.toLocal()}'.split(' ')[0],
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white), // Text is masked with the gradient
                ),
              ),
            ),
            SizedBox(height: 24),
            // Gradient ElevatedButton for Add Offer
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: addOffer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .transparent, // Make background transparent to show gradient
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Add Offer',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable method for TextFields with consistent styling
  Widget buildTextField(
      TextEditingController controller, String labelText, String hintText,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue[50],
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
    );
  }

  // Discount Field with validation (max 99)
  Widget buildDiscountField() {
    return TextField(
      controller: discountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Discount (%)',
        hintText: 'Enter discount (max 99%)',
        labelStyle: TextStyle(color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue[50],
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          double discount = double.tryParse(value) ?? 0;
          if (discount > 99) {
            // Set the discount back to 99 if it exceeds the max value
            discountController.text = '99';
          }
        }
      },
    );
  }
}
