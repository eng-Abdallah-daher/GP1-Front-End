import 'dart:io';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportCarIssuePage extends StatefulWidget {
  @override
  _ReportCarIssuePageState createState() => _ReportCarIssuePageState();
}

class _ReportCarIssuePageState extends State<ReportCarIssuePage> {
  final _issueController = TextEditingController();
  String _selectedIssueType = "Engine Problem";
  bool _locationSharing = false;
  List<XFile>? _images = [];

  final List<String> _issueTypes = [
    'Engine Problem',
    'Flat Tire',
    'Battery Issue',
    'Brakes Issue',
    'Transmission Problem',
    'Other'
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedImages = await _picker.pickMultiImage();
    setState(() {
      if (pickedImages != null) {
        _images = pickedImages;
      }
    });
  }

  void _submitReport() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report Submitted", style: TextStyle(color: blueAccent)),
          content:
              Text("Your car issue report has been submitted successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK", style: TextStyle(color: blueAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Car Issue',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildIssueTypeDropdown(),
                  SizedBox(height: 20),
                  _buildIssueDescriptionField(),
                  SizedBox(height: 20),
                  _buildUploadPhotoSection(),
                  SizedBox(height: 20),
                  _buildLocationSharingSwitch(),
                  SizedBox(height: 30),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIssueTypeDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Select Issue Type',
        labelStyle: TextStyle(color: blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: blueAccent, width: 2),
        ),
        filled: true,
        fillColor: white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedIssueType,
          isExpanded: true,
          items: _issueTypes.map((String issue) {
            return DropdownMenuItem<String>(
              value: issue,
              child: Text(issue, style: TextStyle(fontSize: 16)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedIssueType = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildIssueDescriptionField() {
    return TextField(
      controller: _issueController,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Describe the issue',
        hintText: 'Provide more details about the problem...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: blueAccent, width: 2),
        ),
        filled: true,
        fillColor: white,
      ),
    );
  }

  Widget _buildUploadPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Photos (Optional)',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: blueAccent),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ElevatedButton.icon(
            onPressed: _pickImages,
            icon: Icon(
              Icons.camera_alt,
              color: white,
              size: 24,
            ),
            label: Text(
              'Upload Photos',
              style: TextStyle(
                color: white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 10,
              shadowColor: blueAccent.withOpacity(0.5),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        SizedBox(height: 10),
        _images != null && _images!.isNotEmpty
            ? Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images!.map((image) {
                  return Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: Colors.transparent,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          blueAccent.withOpacity(0.5),
                          Colors.lightBlueAccent.withOpacity(0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: blueAccent.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              )
            : Text('No images selected', style: TextStyle(color: blueAccent)),
      ],
    );
  }

  Widget _buildLocationSharingSwitch() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            blueAccent.withOpacity(0.9),
            Colors.lightBlueAccent.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: blueAccent.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          'Share Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        value: _locationSharing,
        onChanged: (bool value) {
          setState(() {
            _locationSharing = value;
          });
        },
        secondary: Icon(
          Icons.location_on,
          color: _locationSharing ? Colors.greenAccent : white,
          size: 32,
        ),
        activeColor: white,
        inactiveThumbColor: white,
        inactiveTrackColor: white.withOpacity(0.5),
        activeTrackColor: Colors.greenAccent,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            blueAccent,
            Colors.lightBlueAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: blueAccent.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _submitReport,
        icon: Icon(
          Icons.report_problem,
          color: white,
          size: 24,
        ),
        label: Text(
          'Submit Report',
          style: TextStyle(
            color: white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReportCarIssuePage(),
  ));
}
