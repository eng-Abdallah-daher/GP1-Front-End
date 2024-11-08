import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 



class UpdateDeleteItemPage extends StatefulWidget {
   Item? selectedItem;
   UpdateDeleteItemPage(this.selectedItem);
  @override
  _UpdateDeleteItemPageState createState() => _UpdateDeleteItemPageState();
}

class _UpdateDeleteItemPageState extends State<UpdateDeleteItemPage> {
  


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _updateItem() {
    if (widget.selectedItem != null) {
      setState(() {
        updatecar(widget.selectedItem!.id, _nameController.text,_descriptionController.text, _priceController.text);

      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Item updated successfully!')));
    }
  }

  void _deleteItem() {
    if (widget.selectedItem != null) {
      setState(() {
      deletecar(widget.selectedItem!.id);

        widget.selectedItem = null;
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Item deleted successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Update/Delete Item',
            style: TextStyle(
                color: whiteColor, fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: deepBlueColor,
        iconTheme: IconThemeData(color: whiteColor),
        elevation: 4.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<Item>(
              hint: Text('Select an item',
                  style: TextStyle(
                      color: brightCoralColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              value: widget.selectedItem,
              dropdownColor: deepBlueColor,
              iconEnabledColor: brightCoralColor,
              isExpanded: true,
              onChanged: (Item? newValue) {
                setState(() {
                  widget.selectedItem = newValue;
                  if (newValue != null) {
                    _nameController.text = newValue.name;
                    _descriptionController.text = newValue.description;
                    _priceController.text = newValue.price.toString();
                  } else {
                    _nameController.clear();
                    _descriptionController.clear();
                    _priceController.clear();
                  }
                });
              },
              items: items.map((Item item) {
                return DropdownMenuItem<Item>(
                  value: item,
                  child: Text(item.name,
                      style: TextStyle(color: whiteColor, fontSize: 16)),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            _buildTextField('Name', _nameController),
            SizedBox(height: 20),
            _buildTextField('Description', _descriptionController),
            SizedBox(height: 20),
            _buildTextField('Price', _priceController, isNumber: true),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton('Update', _updateItem),
                _buildActionButton('Delete', _deleteItem),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: whiteColor, fontSize: 18),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: brightCoralColor, fontSize: 16, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: deepBlueColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Function onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: brightCoralColor,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
      ),
      child: Text(label,
          style: TextStyle(
              color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}


