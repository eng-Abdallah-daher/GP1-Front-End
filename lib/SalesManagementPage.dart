import 'package:first/glopalvars.dart';
import 'package:first/ownermainpage.dart';
import 'package:flutter/material.dart';

class SalesManagementPage extends StatefulWidget {
  @override
  _SalesManagementPageState createState() => _SalesManagementPageState();
}

class _SalesManagementPageState extends State<SalesManagementPage> {

    @override
  void initState()  {
    super.initState();
   m();
  }
  void m() async {
    await  getItems();
  await  getSales();
  setState(() {
    
  });
  }

  String? selectedTool;
  int quantity = 1;
  String? errorMessage;

  void _addSale() {
    errorMessage = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              title: Text(
                'Add New Sale',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueAccent,
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                        value: selectedTool,
                        hint: Text(
                          'Select Tool',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        items: items
                            .where((sale) => sale.ownerid == global_user.id)
                            .map((tool) {
                          return DropdownMenuItem<String>(
                            value: tool.name,
                            child: Text(
                              '${tool.name} (Available: ${tool.availableQuantity})',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTool = newValue;
                            quantity = 1;
                          });
                        },
                        dropdownColor: Colors.white,
                        icon: Icon(Icons.arrow_drop_down,
                            color: Colors.blueAccent),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          labelStyle: TextStyle(
                            color: Colors.blueAccent,
                          ),
                          errorText: errorMessage,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final inputQuantity = int.tryParse(value) ?? 0;
                          setState(() {
                            if (selectedTool != null) {
                              final tool = items.firstWhere(
                                  (tool) => tool.name == selectedTool);
                              if (inputQuantity > tool.availableQuantity) {
                                errorMessage =
                                    'Quantity cannot exceed available stock (${tool.availableQuantity})';
                                quantity = tool.availableQuantity;
                              } else if (inputQuantity < 1) {
                                errorMessage = 'Quantity must be at least 1';
                                quantity = 1;
                              } else {
                                errorMessage = null;
                                quantity = inputQuantity;
                              }
                            }
                          });
                        },
                        maxLength: 3,
                      ),
                      SizedBox(height: 16),
                      if (selectedTool != null) ...[
                        Text(
                          'Selected Tool: ${items.firstWhere((tool) => tool.name == selectedTool).name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Price: \$${items.firstWhere((tool) => tool.name == selectedTool).price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Total Price: \$${(items.firstWhere((tool) => tool.name == selectedTool).price * quantity).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  child: Text(
                    'Add Sale',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    if (selectedTool != null &&
                        quantity > 0 &&
                        errorMessage == null) {
                   try{
                       final tool =
                          items.firstWhere((tool) => tool.name == selectedTool);
                      setState(() {
                        addSale(id: sales[sales.length - 1].id + 1,ownerId: global_user.id, itemId: tool.id, quantity: quantity, price: quantity * tool.price, date: DateTime.now());
                        sales.add(Sale(
                          id: sales[sales.length - 1].id + 1,
                            ownerid: global_user.id,
                            itemid: tool.id,
                            quantity: quantity,
                            price: quantity * tool.price,
                            date: DateTime.now()));

                        tool.availableQuantity -= quantity;
updateItemQuantity(tool.id, tool.availableQuantity);
                        if (tool.availableQuantity == 0) {
                          deleteAnItem(tool.id);
                          items.remove(tool);
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ownermainpage(),
                          ),
                        );
                        index = 2;
                      });
                   }catch(e) {
               
                    
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                         content: Text('Failed to add sale. Please try again.'),
                         backgroundColor: Colors.red,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0),)));
                   }
                    } else {
                      setState(() {
                        errorMessage = 'Please correct the errors above.';
                      });
                    }
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
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
      },
    );
  }

  void _showSaleDetailsDialog(BuildContext context, Sale sale) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'Sale Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blueAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                SizedBox(height: 8),
                Text(
                  'Product Name: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  getitemnamebyid(sale.itemid),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Quantity: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${sale.quantity}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Total Price: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '\$${sale.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              child: Text(
                'Close',
                style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Management'),
        backgroundColor: Color.fromARGB(255, 30, 144, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => {
              if (items
                  .where((sale) => sale.ownerid == global_user.id)
                  .toList()
                  .isEmpty)
                {
                  SnackBar(
                    content: Text('You don\'t have items in your Store'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                }
              else
                {_addSale()}
            },
          ),
        ],
      ),
      body: sales.isEmpty
          ? Center(child: Text('No sales recorded yet!'))
          : ListView.builder(
              itemCount: sales.length,
              itemBuilder: (context, index) {
                if (sales[index].ownerid == global_user.id)
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.blueAccent, width: 1),
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
                    child: InkWell(
                      onTap: () =>
                          _showSaleDetailsDialog(context, sales[index]),
                      borderRadius: BorderRadius.circular(15.0),
                      splashColor: Colors.blue.withOpacity(0.3),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getitemnamebyid(sales[index].itemid),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Quantity: ${sales[index].quantity}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${sales[index].price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                else
                  return SizedBox();
              },
            ),
    );
  }
}
