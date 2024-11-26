import 'package:first/glopalvars.dart';
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
        backgroundColor: blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [white, Colors.blue.shade50],
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
                      backgroundColor: blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Get Estimate',
                      style: TextStyle(color: white, fontSize: 18),
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
      cursorColor: blueAccent,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: blueAccent, width: 2),
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
    int estimate = 100;

    if (description.toLowerCase().contains("أضواء أمامية")) {
      estimate += 50;
    }
    if (description.toLowerCase().contains("فرامل")) {
      estimate += 70;
    }
    if (description.toLowerCase().contains("محرك")) {
      estimate += 150;
    }
    if (description.toLowerCase().contains("إطار")) {
      estimate += 40;
    }
    if (description.toLowerCase().contains("تغيير زيت")) {
      estimate += 30;
    }
    if (description.toLowerCase().contains("بطارية")) {
      estimate += 100;
    }
    if (description.toLowerCase().contains("نقل الحركة")) {
      estimate += 200;
    }
    if (description.toLowerCase().contains("تعليق")) {
      estimate += 120;
    }
    if (description.toLowerCase().contains("مبرد")) {
      estimate += 90;
    }
    if (description.toLowerCase().contains("وسائد الفرامل")) {
      estimate += 80;
    }
    if (description.toLowerCase().contains("محاذاة")) {
      estimate += 60;
    }
    if (description.toLowerCase().contains("دبرياج")) {
      estimate += 150;
    }
    if (description.toLowerCase().contains("مضخة الوقود")) {
      estimate += 120;
    }
    if (description.toLowerCase().contains("شمعات الإشعال")) {
      estimate += 40;
    }
    if (description.toLowerCase().contains("نظام العادم")) {
      estimate += 100;
    }
    if (description.toLowerCase().contains("مولد كهربائي")) {
      estimate += 130;
    }
    if (description.toLowerCase().contains("مرشح المقصورة")) {
      estimate += 25;
    }
    if (description.toLowerCase().contains("مرشح الهواء")) {
      estimate += 20;
    }
    if (description.toLowerCase().contains("مبرد")) {
      estimate += 50;
    }
    if (description.toLowerCase().contains("مصابيح أمامية")) {
      estimate += 40;
    }
    if (description.toLowerCase().contains("مصابيح خلفية")) {
      estimate += 40;
    }
    if (description.toLowerCase().contains("نافذة")) {
      estimate += 100;
    }
    if (description.toLowerCase().contains("مقعد")) {
      estimate += 70;
    }
    if (description.toLowerCase().contains("شفاطات المساحات")) {
      estimate += 30;
    }
    if (description.toLowerCase().contains("تعديلات")) {
      estimate += 60;
    }
    if (description.toLowerCase().contains("front lights")) {
      estimate += 50;
    }
    if (description.toLowerCase().contains("brakes")) {
      estimate += 70;
    }
    if (description.toLowerCase().contains("engine")) {
      estimate += 150;
    }
    if (description.toLowerCase().contains("tire")) {
      estimate += 40;
    }
    if (description.toLowerCase().contains("oil change")) {
      estimate += 30;
    }
    if (description.toLowerCase().contains("battery")) {
      estimate += 100;
    }
    if (description.toLowerCase().contains("transmission")) {
      estimate += 200;
    }
    if (description.toLowerCase().contains("suspension")) {
      estimate += 120;
    }
    if (description.toLowerCase().contains("radiator")) {
      estimate += 90;
    }
    if (description.toLowerCase().contains("brake pads")) {
      estimate += 80;
    }
    if (description.toLowerCase().contains("alignment")) {
      estimate += 60;
    }
    if (description.toLowerCase().contains("clutch")) {
      estimate += 150;
    }
    if (description.toLowerCase().contains("fuel pump")) {
      estimate += 120;
    }
    if (description.toLowerCase().contains("spark plugs")) {
      estimate += 40;
    }
    if (description.toLowerCase().contains("exhaust")) {
      estimate += 100;
    }
    if (description.toLowerCase().contains("alternator")) {
      estimate += 130;
    }
    if (description.toLowerCase().contains("cabin filter")) {
      estimate += 25;
    }
    if (description.toLowerCase().contains("air filter")) {
      estimate += 20;
    }
    if (description.toLowerCase().contains("coolant")) {
      estimate += 50;
    }
    if (description.toLowerCase().contains("headlights")) {
      estimate += 40;
    }
    if (description.toLowerCase().contains("taillights")) {
      estimate += 40;
    }
    if (description.toLowerCase().contains("window")) {
      estimate += 100;
    }
    if (description.toLowerCase().contains("seat")) {
      estimate += 70;
    }
    if (description.toLowerCase().contains("wiper blades")) {
      estimate += 30;
    }
    if (description.toLowerCase().contains("tune-up")) {
      estimate += 60;
    }
    return "\$${estimate}";
  }
}
