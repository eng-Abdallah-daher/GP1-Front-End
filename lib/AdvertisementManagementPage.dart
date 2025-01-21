import 'package:CarMate/OffersListPage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class OfferManagementPage extends StatefulWidget {
  OfferManagementPage();

  @override
  _OfferManagementPageState createState() => _OfferManagementPageState();
}

class _OfferManagementPageState extends State<OfferManagementPage> {
    @override
  void initState() {
    super.initState();
   m();
  }
  void m() async {
    await getOffers();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  DateTime? validUntil;

  void addOffer2() {
    setState(() {

     try{
       addOffer(
          global_user.id,
          double.parse(discountController.text),
          titleController.text,
          descriptionController.text,
          validUntil ?? DateTime.now().add(Duration(days: 30)));
      offers.add(Offer(
        id: offers[offers.length-1].id+1,
        title: titleController.text,
        description: descriptionController.text,
        discount: double.parse(discountController.text),
        validUntil: validUntil ?? DateTime.now().add(Duration(days: 30)),
        posterid: global_user.id,
      ));

      titleController.clear();
      descriptionController.clear();
      discountController.clear();

      validUntil = null;
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Offer added successfully!"),
          backgroundColor: Colors.green,
        ));
      

     }catch(e){

       
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to add Offer!"),
          backgroundColor: Colors.red,
        ));
     }
    });
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
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: white),
        ),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OffersListPage(),
                ),
              );
              setState(() {});
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
                  color: lightBlue,
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
            buildDiscountField(),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [blue, Colors.lightBlue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () => pickValidUntilDate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Select Valid Until Date',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [blue, Colors.lightBlue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: addOffer2,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
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

  Widget buildTextField(
      TextEditingController controller, String labelText, String hintText,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      cursorColor: blue,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue[50],
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
    );
  }

  Widget buildDiscountField() {
    return TextField(
      controller: discountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Discount (%)',
        hintText: 'Enter discount (max 99%)',
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue[50],
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          double discount = double.tryParse(value) ?? 0;
          if (discount > 99) {
            discountController.text = '99';
          }
          if (discount < 0) {
            discountController.text = '0';
          }
        }
      },
    );
  }
}
