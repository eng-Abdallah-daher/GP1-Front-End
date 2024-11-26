import 'package:flutter/material.dart';
import 'package:first/glopalvars.dart';

class AddEmployeePage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Employee",
          style: TextStyle(fontWeight: FontWeight.bold, color: white),
        ),
        backgroundColor: blue,
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage("images/emps.png"),
                  fit: BoxFit.fitWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildTextField(
              controller: _nameController,
              label: "Employee Name",
              icon: Icons.person,
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _positionController,
              label: "Position",
              icon: Icons.work,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final position = _positionController.text.trim();

                if (name.isNotEmpty && position.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Employee $name added as $position!"),
                    ),
                  );
                  _nameController.clear();
                  _positionController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill in all fields.")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
              child: Text(
                "Add Employee",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }
}
