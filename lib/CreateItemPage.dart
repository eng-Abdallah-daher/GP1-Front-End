import 'dart:io';
import 'dart:typed_data';
import 'package:first/glopalvars.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class CreateCarItemPage extends StatefulWidget {
  @override
  _CreateCarItemPageState createState() => _CreateCarItemPageState();
}

class _CreateCarItemPageState extends State<CreateCarItemPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController carNameController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController rentPriceController = TextEditingController();

  File? _image; 
  Uint8List? _webImageData; 
  final ImagePicker _picker = ImagePicker(); 

  
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        if (!kIsWeb) {
          
          final Directory directory = await getApplicationDocumentsDirectory();
          final String newPath = '${directory.path}/images';

         
          await Directory(newPath).create(recursive: true);

          
          final String fileName = path.basename(image.path);
          final File newImage =
              await File(image.path).copy('$newPath/$fileName');

          setState(() {
            _image = newImage; 
            _webImageData = null; 
          });

          print('Image copied to: ${newImage.path}');
        } else {
          
          final response = await http.get(Uri.parse(image.path));
          setState(() {
            _webImageData = response.bodyBytes; 
            _image = null; 
          });
          print('Image picked on web: ${image.path}');
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Car Item'),
        backgroundColor: Color(0xFF0F3460), 
        elevation: 5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, 
              children: [
                SizedBox(height: 20),
                _buildTextField(carNameController, 'Car Name'),
                SizedBox(height: 12),
                _buildTextField(carModelController, 'Car Model'),
                SizedBox(height: 12),
                _buildTextField(rentPriceController, 'Rent Price',
                    isNumber: true),
                SizedBox(height: 20),
                _buildImagePicker(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onCreateCarItem,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Color(0xFFE94560), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text('Create Car Item',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFF1A1A2E), 
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: Color(0xFF0F3460)), 
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Color(0xFFE94560)), 
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Color(0xFFB0B0B0)), 
        ),
        fillColor: Color(0xFFEFEFEF), 
        filled: true, 
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
      style: TextStyle(color: Color(0xFF0F3460)), 
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF2A2A3D), 
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Color(0xFFB0B0B0)), 
          boxShadow: [
            
            BoxShadow(
              color: Color(0x1F000000), 
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: _image == null && _webImageData == null
            ? Center(
                child: Text(
                  'Tap to pick an image',
                  style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 16), 
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: _image != null
                    ? Image.file(
                        _image!, 
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200, 
                      )
                    : Image.memory(
                        _webImageData!, 
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200, 
                      ),
              ),
      ),
    );
  }



  void _onCreateCarItem() {
    if (_formKey.currentState!.validate()) {
      String imagePath = _image?.path ??
          'Web image data available but not saved as path'; 
      createCar(
        carNameController.text,
        carModelController.text,
       rentPriceController.text,
        imagePath,
      );
      print('Car Name: ${carNameController.text}');
      print('Car Model: ${carModelController.text}');
      print('Rent Price: ${double.parse(rentPriceController.text)}');
      if (_image != null) {
        print('Image Path: ${_image!.path}');
      } else if (_webImageData != null) {
        print('Image is selected but on the web.');
      } else {
        print('No image selected.');
      }
    }
  }
}
