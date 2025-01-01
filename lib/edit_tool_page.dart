import 'package:flutter/material.dart';
import 'glopalvars.dart';

class EditToolPage extends StatefulWidget {
  final int indexof; 


  EditToolPage({Key? key, required this.indexof}) : super(key: key);

  @override
  _EditToolPageState createState() => _EditToolPageState();
}

class _EditToolPageState extends State<EditToolPage> {
 
  @override
  void initState() {
    super.initState();
   m();
  }
  void m() async{
    await getItems();
setState(() {
  
});
  }
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    Item tool = items[widget.indexof];
    nameController.text = tool.name;
    priceController.text = tool.price.toString();
    quantityController.text = tool.availableQuantity.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Tool',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 30, 144, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: nameController,
                label: 'Tool Name',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: priceController,
                label: 'Price',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: quantityController,
                label: 'Quantity',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _buildElevatedButton(
                title: 'Save Changes',
                onPressed: () {
                  _editTool(context,tool);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editTool(BuildContext context,Item item) {
    String toolName = nameController.text.trim();
    String toolPriceText = priceController.text.trim();
    String toolQuantityText = quantityController.text.trim();

    if (toolName.isEmpty || toolPriceText.isEmpty || toolQuantityText.isEmpty) {
      _showMessage(context, 'Please fill in all fields.');
      return;
    }

    double? toolPrice = double.tryParse(toolPriceText);
    int? toolQuantity = int.tryParse(toolQuantityText);

    if (toolPrice == null || toolPrice <= 0) {
      _showMessage(context, 'Please enter a valid price.');
      return;
    }

    if (toolQuantity == null || toolQuantity <= 0) {
      _showMessage(context, 'Please enter a valid quantity.');
      return;
    }
    
try{
  updateItem(item.id,nameController.text, toolQuantity, toolPrice);
  item.name=nameController.text;
  item.availableQuantity=toolQuantity;
  item.price=toolPrice;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tool updated successfully!'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
}catch (e) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Failed to update tool. Please try again.'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ),
  );
}
    Navigator.of(context).pop();
  }

  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Notification',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      style: TextStyle(fontSize: 16, color: Colors.black87),
    );
  }

  Widget _buildElevatedButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
