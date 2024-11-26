
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomizeThemePage extends StatefulWidget {
  @override
  _CustomizeThemePageState createState() => _CustomizeThemePageState();
}

class _CustomizeThemePageState extends State<CustomizeThemePage> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Theme'),
        backgroundColor:
            blueAccent, // Use global variable for AppBar background
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            _buildSectionHeader('Theme Customization'),

            // Primary Color Picker
            _buildColorPicker(
              'Primary Color',
              blueAccent,
              (Color color) {
                setState(() {
                  blueAccent = color; // Update the global color variable
                });
              },
            ),

            // Accent Color Picker
            _buildColorPicker(
              'Accent Color',
              blue,
              (Color color) {
                setState(() {
                  blue = color; // Update the global color variable
                });
              },
            ),

            // Background Color Picker
            _buildColorPicker(
              'Background Color',
              white, // Using the global white color
              (Color color) {
                setState(() {
                  white = color; // Update the global background color
                });
              },
            ),

            // Text Color Picker
            _buildColorPicker(
              'Text Color',
              lightBlue, // Using the global lightBlue color for text
              (Color color) {
                setState(() {
                  lightBlue = color; // Update the global text color
                });
              },
            ),

            // Dark Mode Switch
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {
                  _darkMode = value;
                  // Optionally apply the theme changes here
                });
              },
              activeColor:
                  blueAccent, // Use global color for the switch active color
            ),

            SizedBox(height: 20),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic to save theme settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Theme settings updated!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full-width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple, // Custom background color
                  shadowColor:
                      Colors.black.withOpacity(0.5), // Custom shadow color
                  elevation: 8, // Custom elevation
                ).copyWith(
                  side: MaterialStateBorderSide.resolveWith((states) {
                    return BorderSide(
                        color: Colors.deepPurple.shade700,
                        width: 2); // Custom border
                  }),
                  overlayColor: MaterialStateProperty.all(Colors.deepPurple
                      .withOpacity(0.2)), // Custom overlay color
                ),
                child: Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Custom text color
                    fontWeight: FontWeight.bold, // Custom text weight
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable method for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: blueAccent, // Use global color for header
        ),
      ),
    );
  }

  // Reusable method for color picker
  Widget _buildColorPicker(
      String title, Color initialColor, ValueChanged<Color> onColorChanged) {
    return ListTile(
      title: Text(title),
      trailing: Container(
        width: 24,
        height: 24,
        color: initialColor,
      ),
      onTap: () {
        _pickColor(context, initialColor).then((color) {
          if (color != null) {
            onColorChanged(color);
          }
        });
      },
    );
  }

  Future<Color?> _pickColor(BuildContext context, Color initialColor) async {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color? selectedColor = initialColor;
        return AlertDialog(
          title: Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor!,
              onColorChanged: (color) {
                selectedColor = color;
              },
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
