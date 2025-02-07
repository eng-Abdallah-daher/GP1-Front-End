import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class GetEstimatePage extends StatefulWidget {
  @override
  _GetEstimatePageState createState() => _GetEstimatePageState();
}

class _GetEstimatePageState extends State<GetEstimatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _issueDescriptionController =
      TextEditingController();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Get Estimate",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: blueAccent,
        centerTitle: true,
      ),
      body: 
      
      Container(
height: double.infinity,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [white, Color(0xFF87B6D7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:  Align(
              alignment: Alignment.topCenter,
              child: Container(
                width:  MediaQuery.of(context).size.width > 600 ? 500 : null,
                child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              _buildHeaderImage(),
              SizedBox(height: 20),
              Text(
                "Describe Your Car Issue",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_issueDescriptionController,
                        "Issue Description", Icons.description,
                        maxLines: 5),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await calculateEstimate(
                              _issueDescriptionController.text);
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Get Estimate',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (estimate > 0) _buildEstimateBox(),
            ],
          ),
        ),
              ),
      ),)
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        image: DecorationImage(
          image: AssetImage("images/carmate.png"), 
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

 Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        cursorColor: blueAccent,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: blueAccent, size: 24),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: blueAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red),
          ),
          labelStyle: TextStyle(color: blueAccent, fontWeight: FontWeight.w500),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEstimateBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        "Estimated Cost: $estimate ILS",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
