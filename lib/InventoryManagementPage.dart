// here is my code :
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class InventoryManagementPage extends StatefulWidget {
  @override
  _InventoryManagementPageState createState() =>
      _InventoryManagementPageState();
}

class Item {
  String name;
  int quantity;
  double price;

  Item({required this.name, required this.quantity, required this.price});
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  final List<Item> items = []; // List to store inventory items
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  void addItem() {
    if (nameController.text.isNotEmpty &&
        quantityController.text.isNotEmpty &&
        priceController.text.isNotEmpty) {
      setState(() {
        items.add(Item(
          name: nameController.text,
          quantity: int.parse(quantityController.text),
          price: double.parse(priceController.text),
        ));
      });

      // Clear the input fields
      nameController.clear();
      quantityController.clear();
      priceController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Item added successfully!'),
      ));
    }
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });

    // Show success message
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
            borderRadius:
                BorderRadius.circular(20), // Set the border radius here
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
              borderRadius: BorderRadius.circular(
                  20), // Apply the same border radius to the container
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
                      labelText: 'Quantity to Sell (Max: ${item.quantity})',
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

                      // Limit the quantity to sell to the item's available quantity
                      if (quantityToSell > item.quantity) {
                        quantityToSell = item.quantity;
                        sellQuantityController.text = quantityToSell.toString();
                        sellQuantityController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: sellQuantityController.text.length),
                        );
                      }

                      // Calculate total price
                      totalPrice = quantityToSell * item.price;

                      // Update the UI by calling setState (ensure the dialog has access to this context)
                      (context as Element)
                          .markNeedsBuild(); // Force rebuild of the dialog
                    },
                  ),
                  SizedBox(height: 10),
                  // Display total price
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
                            // Remove the item if selling the entire quantity
                            if (quantityToSell >= item.quantity) {
                              setState(() {
                                // Remove the item from the items list
                                items.remove(
                                    item); // Update this according to your data structure
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('Sold ${item.name}! Item removed.'),
                              ));
                            } else {
                              setState(() {
                                item.quantity -=
                                    quantityToSell; // Decrease the quantity of the item
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
                          Navigator.of(context).pop(); // Close the dialog
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
        title: Text('Inventory Management'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 16),
                hintText: 'Enter item name',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Icon(Icons.shopping_cart, color: Colors.blueAccent),
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
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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
                labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 16),
                hintText: 'Enter quantity',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon:
                    Icon(Icons.format_list_numbered, color: Colors.blueAccent),
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
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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
                labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 16),
                hintText: 'Enter price',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Icon(Icons.attach_money, color: Colors.blueAccent),
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
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
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
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showSellDialog(items[index]); // Show dialog on tap
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
                              'Quantity: ${items[index].quantity}\nPrice: \$${items[index].price.toStringAsFixed(2)}',
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// add a button toopen a page and showing all sels