import 'package:first/glopalvars.dart';
import 'package:first/user.dart';
import 'package:flutter/material.dart';
import 'package:first/cartpage.dart';
import 'dart:async';

class CarToolStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Tool Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Item> filteredToolData = [];
  TextEditingController searchController = TextEditingController();
  Map<String, int> currentImageIndex = {};
  Timer? timer;

  @override
  void initState() {
    super.initState();

    fetchDataFromDatabase();
    filteredToolData = List.from(items);
  }

  void fetchDataFromDatabase() {
    setState(() {
      for (var tool in items) {
        currentImageIndex[tool.name] = 0;
      }

      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        setState(() {
          for (var tool in items) {
            currentImageIndex[tool.name] =
                (currentImageIndex[tool.name]! + 1) % 3;
          }
        });
      });

      filteredToolData = List.from(items);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredToolData = List.from(items);
      });
    } else {
      setState(() {
        List<Item> o = [];
        for (var tool in items) {
          if (tool.name.toLowerCase().contains(query.toLowerCase())) {
            o.add(tool);
          }
        }

        filteredToolData = o;
      });
    }
  }

  void showQuantityDialog(Item tool) {
    int selectedQuantity = 1;
    TextEditingController quantityController = TextEditingController(text: '1');

    quantityController.addListener(() {
      int currentQuantity = int.tryParse(quantityController.text) ?? 1;
      if (currentQuantity > tool.availableQuantity) {
        quantityController.text = tool.availableQuantity.toString();
        quantityController.selection = TextSelection.fromPosition(
          TextPosition(offset: quantityController.text.length),
        );
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        int currentIndex = currentImageIndex[tool.name] ?? 0;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.lightBlue[200],
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: tool.imagePaths.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                        currentImageIndex[tool.name] = currentIndex;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          tool.imagePaths[index],
                          fit: BoxFit.fitWidth,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${tool.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: white,
                  ),
                ),
                Text(
                  '${tool.description}',
                  style: TextStyle(
                    fontSize: 14,
                    color: white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: white),
                      onPressed: () {
                        setState(() {
                          int currentQuantity =
                              int.tryParse(quantityController.text) ?? 1;
                          if (currentQuantity > 1) {
                            currentQuantity--;
                            quantityController.text =
                                currentQuantity.toString();
                          }
                        });
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: white, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: white.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      width: 50,
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        ),
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: white),
                      onPressed: () {
                        setState(() {
                          int currentQuantity =
                              int.tryParse(quantityController.text) ?? 1;
                          if (currentQuantity < tool.availableQuantity) {
                            currentQuantity++;
                            quantityController.text =
                                currentQuantity.toString();
                          }
                        });
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${tool.price.toStringAsFixed(2)}₪',
                      style: TextStyle(fontSize: 18, color: black),
                    ),
                    TextButton(
                      onPressed: () {
                        int finalQuantity =
                            int.tryParse(quantityController.text) ?? 1;
                        if (finalQuantity > 0 &&
                            finalQuantity <= tool.availableQuantity) {
                          cart.addItem(tool, finalQuantity);

                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${tool.name} added to cart! Quantity: $finalQuantity'),
                            ),
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Invalid quantity!'),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 82, 0, 197),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleAdd(int index) {
    setState(() {
      Item item = items[index];
      int p = 0;
      for (int i = 0; i < cart.localitems.length; i++) {
        if (cart.localitems[i].id == item.id) {
          p = i;
          break;
        }
      }

      if (item.availableQuantity > 0) {
        cart.localitems[p].availableQuantity += 1;
        items[index].availableQuantity -= 1;
        if (items[index].availableQuantity <= 0) {
          filteredToolData.removeAt(index);
          items.removeAt(index);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot exceed available stock!')),
        );
      }
    });
  }

  void handleRemove(int index) {
    setState(() {
      Item item = items[index];
      int p = 0;
      for (int i = 0; i < cart.localitems.length; i++) {
        if (cart.localitems[i].id == item.id) {
          p = i;
          break;
        }
      }
      if (items[index].availableQuantity > 1) {
        cart.localitems[p].availableQuantity -= 1;
        items[index].availableQuantity += 1;
        if (!filteredToolData.contains(item)) {
          filteredToolData.add(item);
        }
      } else {
        items[index].availableQuantity += item.availableQuantity + 1;
        ;
        cart.localitems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var itemCount = cart.localitems.length;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => usermainpage(),
              ),
            );
            index = 1;
          },
        ),
        title: Text(
          'CarMate Store',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 30, 144, 255),
        elevation: 4,
      ),
      backgroundColor: Colors.blue[300],
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade300, Colors.blue.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Search Tools',
                          labelStyle: TextStyle(
                            color: white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Type tool name...',
                          hintStyle: TextStyle(
                            color: white,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: white,
                            size: 28,
                          ),
                          filled: true,
                          fillColor: white.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: white,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: white,
                              width: 3,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                        ),
                        style: TextStyle(color: white, fontSize: 16),
                        onChanged: (query) => filterSearchResults(query),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        iconSize: 40,
                        color: white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartPage(),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                      ),
                      if (itemCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                '$itemCount',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredToolData.isEmpty
                  ? Center(
                      child: Text(
                        'No tools available!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredToolData.length,
                      itemBuilder: (context, index) {
                        if (filteredToolData[index].availableQuantity != 0) {
                          return buildToolCard(filteredToolData[index]);
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildToolCard(Item tool) {
    return Card(
      elevation: 12,
      shadowColor: black.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: white.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(
                      tool.imagePaths[currentImageIndex[tool.name]!]),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '₪${tool.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    tool.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Available: ${tool.availableQuantity} in stock',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.lightBlue[300],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showQuantityDialog(tool);
                      },
                      icon: Icon(
                        Icons.add_shopping_cart,
                        size: 26,
                        color: white,
                      ),
                      label: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        elevation: 12,
                        shadowColor: black,
                        backgroundColor: Colors.lightBlue[300],
                        side: BorderSide(
                          color: Colors.lightBlueAccent,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
