import 'package:CarMate/glopalvars.dart';
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
        backgroundColor: blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Theme Customization'),
            _buildColorPicker(
              'Primary Color 1',
              blueAccent,
              (Color color) {
                setState(() {
                  blueAccent = color;
                  index = 1;
                });
              },
            ),
            _buildColorPicker(
              'Primary Color 2',
              white,
              (Color color) {
                setState(() {
                  white = color;
                  index = 1;
                });
              },
            ),
            _buildColorPicker(
              'Primary Color 3',
              black,
              (Color color) {
                setState(() {
                  black = color;
                  index = 1;
                });
              },
            ),
            _buildColorPicker(
              'Accent Color 1',
              blue,
              (Color color) {
                setState(() {
                  blue = color;
                  index = 1;
                });
              },
            ),
            _buildColorPicker(
              'Accent Color 2',
              lightBlue,
              (Color color) {
                setState(() {
                  lightBlue = color;
                  index = 1;
                });
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {
                  _darkMode = value;
                });
              },
              activeColor: blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: blueAccent,
        ),
      ),
    );
  }

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
