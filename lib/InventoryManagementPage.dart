import 'dart:io';

import 'package:first/SellPage.dart';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InventoryManagementPage extends StatefulWidget {
  @override
  _InventoryManagementPageState createState() =>
      _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController DescriptionController = TextEditingController();

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final List<File?> selectedImages = List.generate(3, (_) => null);

  final ImagePicker _picker = ImagePicker();

  void pickImage(int index) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImages[index] = File(pickedFile.path);
      });
    }
  }

  void addItem() {
    if (nameController.text.isNotEmpty &&
        quantityController.text.isNotEmpty &&
        DescriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectedImages.every((image) => image != null)) {
      setState(() {
        items.add(Item(
          ownerid: global_user.id,
          id: items.length,
          description: DescriptionController.text,
          imagePaths: selectedImages.map((file) => file!.path).toList(),
          publisherId: global_user.id,
          name: nameController.text,
          availableQuantity: int.parse(quantityController.text),
          price: double.parse(priceController.text),
        ));
      });

      nameController.clear();
      quantityController.clear();
      priceController.clear();
      for (int i = 0; i < selectedImages.length; i++) {
        selectedImages[i] = null;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Item added successfully!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill out all fields and select 3 images!'),
      ));
    }
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Item deleted successfully!'),
    ));
  }

  void showSellDialog(Item item) {
    final TextEditingController sellQuantityController =
        TextEditingController();
    double totalPrice = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.9),
                  Colors.lightBlueAccent.withOpacity(0.9)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sell Item: ${item.name}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Price: \$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: sellQuantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText:
                          'Quantity to Sell (Max: ${item.availableQuantity})',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      int quantityToSell = int.tryParse(value) ?? 0;

                      if (quantityToSell > item.availableQuantity) {
                        quantityToSell = item.availableQuantity;
                        sellQuantityController.text = quantityToSell.toString();
                        sellQuantityController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: sellQuantityController.text.length),
                        );
                      }

                      totalPrice = quantityToSell * item.price;

                      (context as Element).markNeedsBuild();
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          int quantityToSell =
                              int.tryParse(sellQuantityController.text) ?? 0;

                          if (quantityToSell > 0) {
                            if (quantityToSell >= item.availableQuantity) {
                              setState(() {
                                items.remove(item);
                                sales.add(Sale(
                                    ownerid: item.ownerid,
                                    itemid: item.id,
                                    price: item.price,
                                    quantity: item.availableQuantity,
                                    date: DateTime.now()));
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('Sold ${item.name}! Item removed.'),
                              ));
                            } else {
                              setState(() {
                                item.availableQuantity -= quantityToSell;
                                sales.add(Sale(
                                    ownerid: item.ownerid,
                                    itemid: item.id,
                                    price: item.price,
                                    quantity: quantityToSell,
                                    date: DateTime.now()));
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Sold $quantityToSell ${item.name}(s)!'),
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Invalid quantity to sell.'),
                            ));
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.lightBlue[200],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Sell',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 7,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: white,
                  ))),
          SizedBox(
            width: 10,
          ),
        ],
        title: Text(
          'Inventory Management',
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: const Color.fromARGB(255, 196, 213, 242),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Item',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle:
                        TextStyle(color: Colors.blueAccent, fontSize: 16),
                    hintText: 'Enter item name',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon:
                        Icon(Icons.shopping_cart, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: DescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Item Description',
                    labelStyle:
                        TextStyle(color: Colors.blueAccent, fontSize: 16),
                    hintText: 'Enter item Description',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon:
                        Icon(Icons.shopping_cart, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle:
                        TextStyle(color: Colors.blueAccent, fontSize: 16),
                    hintText: 'Enter quantity',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: Icon(Icons.format_list_numbered,
                        color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle:
                        TextStyle(color: Colors.blueAccent, fontSize: 16),
                    hintText: 'Enter price',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon:
                        Icon(Icons.attach_money, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                for (int i = 0; i < 3; i++)
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => pickImage(i),
                          icon: Icon(Icons.image, color: Colors.white),
                          label: Text(
                            'Choose Image ${i + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                      if (selectedImages[i] != null)
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.file(
                              selectedImages[i]!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'No Image Selected',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [blue, const Color.fromARGB(255, 186, 237, 249)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: addItem,
                      child: Text('Add Item', style: TextStyle(color: white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Inventory List',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    if (items[index].ownerid == global_user.id) {
                      return Card(
                        elevation: 8,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showSellDialog(items[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  white,
                                  const Color.fromARGB(255, 178, 202, 246)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                title: Text(
                                  items[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  'Quantity: ${items[index].availableQuantity}\nPrice: \$${items[index].price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteItem(index),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else
                      return SizedBox();
                  },
                ),
              ],
            ),
          )),
    );
  }
}
