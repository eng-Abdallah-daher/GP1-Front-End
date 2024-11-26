import 'package:flutter/material.dart';

class GetEstimatePage extends StatefulWidget {
  @override
  _GetEstimatePageState createState() => _GetEstimatePageState();
}

class _GetEstimatePageState extends State<GetEstimatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _issueDescriptionController =
      TextEditingController();
  String _estimate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Estimate"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Get Your Repair Estimate",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildTextField(
                    _makeController, "Car Make", Icons.directions_car),
                SizedBox(height: 20),
                _buildTextField(_modelController, "Car Model", Icons.drive_eta),
                SizedBox(height: 20),
                _buildTextField(
                    _yearController, "Car Year", Icons.calendar_today,
                    keyboardType: TextInputType.number),
                SizedBox(height: 20),
                _buildTextField(_issueDescriptionController,
                    "Describe the Issue", Icons.description,
                    maxLines: 3),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _estimate = _calculateEstimate(
                              _issueDescriptionController.text);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Get Estimate',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_estimate.isNotEmpty)
                  Center(
                    child: Text(
                      "Estimated Cost: $_estimate",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      cursorColor: Colors.blueAccent,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  String _calculateEstimate(String description) {
    int estimate = 100; // Base estimate

    // English keyword-based estimate adjustments
    if (description.toLowerCase().contains("front lights") ||
        description.toLowerCase().contains("أضواء أمامية")) {
      estimate += 50; // Cost for front lights repair
    }
    if (description.toLowerCase().contains("brakes") ||
        description.toLowerCase().contains("فرامل")) {
      estimate += 70; // Cost for brake repair
    }
    if (description.toLowerCase().contains("engine") ||
        description.toLowerCase().contains("محرك")) {
      estimate += 150; // Cost for engine repair
    }
    if (description.toLowerCase().contains("tire") ||
        description.toLowerCase().contains("إطار")) {
      estimate += 40; // Cost for tire replacement
    }
    if (description.toLowerCase().contains("oil change") ||
        description.toLowerCase().contains("تغيير زيت")) {
      estimate += 30; // Cost for oil change
    }
    if (description.toLowerCase().contains("battery") ||
        description.toLowerCase().contains("بطارية")) {
      estimate += 100; // Cost for battery replacement
    }
    // Add other keywords following the same pattern...

    return "\$${estimate}"; // Return formatted estimate
  }
}
