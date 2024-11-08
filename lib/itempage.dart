import 'package:first/glopalvars.dart';
import 'package:first/updatedeleteitem.dart';
import 'package:flutter/material.dart';

const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 
const Color shadowColor = Colors.black45; 

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  List<Item> filteredItems = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    filteredItems = items; 
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = items.where((item) {
        final itemNameLower = item.name.toLowerCase();
        final itemDescriptionLower = item.description.toLowerCase();
        final searchLower = query.toLowerCase();
        return itemNameLower.contains(searchLower) ||
            itemDescriptionLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Items', style: TextStyle(color: whiteColor)),
        backgroundColor: deepBlueColor,
        iconTheme: IconThemeData(color: whiteColor),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _filterItems(value);
              },
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: whiteColor.withOpacity(0.5)),
                filled: true,
                fillColor: deepBlueColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: whiteColor),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return GestureDetector(
            onTap: () {
              
              print('Item Clicked:');
              print('Name: ${item.name}');
              print('Description: ${item.description}');
              print('Price: \$${item.price.toStringAsFixed(2)}');
              print('Image URL: ${item.imageUrl}');
              
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateDeleteItemPage(item)),
              );
              
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 8,
              shadowColor: shadowColor,
              color: deepBlueColor,
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      item.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      item.name,
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: whiteColor.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: brightCoralColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: brightCoralColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ItemsPage(),
    theme: ThemeData(
      primaryColor: deepBlueColor,
    ),
  ));
}
