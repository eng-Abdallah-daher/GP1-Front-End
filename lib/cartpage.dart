import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double total = 0;

  @override
  void initState() {
    super.initState();
    calculateTotal();
  }

  void calculateTotal() {
    total = 0;
    for (int i = 0; i < cart.localitems.length; i++) {
      total += cart.localitems[i].price * cart.localitems[i].availableQuantity;
    }
  }

  void updateTotal() {
    setState(() {
      calculateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Shopping Bag',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Buy 35.00€ more to enjoy FREE SHIPPING!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: white,
                ),
              ),
            ),
          ),
          Expanded(
            child: cart.localitems.isEmpty
                ? Center(
                    child: Text(
                      'Your cart is empty!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.localitems.length,
                    itemBuilder: (context, index) {
                      Item item = cart.localitems[index];
                      return buildCartItem(item, index);
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.grey.shade200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [blueAccent, Colors.cyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                      Text(
                        '${total.toStringAsFixed(2)}₪',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: white.withOpacity(0.6),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (cart.localitems.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Checkout successful!')),
                        );
                      try{
                          for (int i = 0; i < cart.localitems.length; i++) {
                        addSaleRequest(SaleRequest(
                            id: salesrequests[salesrequests.length-1].id+1,
                              ownerid: cart.localitems[i].ownerid,
                              itemid: cart.localitems[i].id,
                              quantity: cart.localitems[i].availableQuantity,
                              price: cart.localitems[i].price,
                              date: DateTime.now()));
                          salesrequests.add(SaleRequest(
                            id: salesrequests[salesrequests.length - 1].id +1,
                              ownerid: cart.localitems[i].ownerid,
                              itemid: cart.localitems[i].id,
                              quantity: cart.localitems[i].availableQuantity,
                              price: cart.localitems[i].price,
                              date: DateTime.now()));
                        }


                        for (int i = 0; i < cart.localitems.length; i++) {
                            removeItemFromCart(
                                cartId: cart.cartId,
                                itemId: cart.localitems[i].id);
                          }

                          cart.localitems = [];
                          updateTotal();

                          Navigator.of(context).pop();
                      }catch(e){
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to checkout cart!'),
                                backgroundColor: Colors.red),
                         
                        );
                        return;
                      }


                        
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Your cart is empty!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [blueAccent, Colors.cyan],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        'CHECKOUT (${cart.localitems.length})',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Apply first order coupon (10% OFF) in the next step',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCartItem(Item item, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      elevation: 8,
      shadowColor: black.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: black,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    item.imagePaths[0],
                    height: 150,
                    width: 150,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        '${item.price.toStringAsFixed(2)}₪',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.redAccent),
                              onPressed: () {
                               try{
                                 for (int i = 0; i < items.length; i++) {
                                  if (items[i].id == item.id) {
                                       updateItemQuantity(items[i].id,
                                        items[i].availableQuantity + 1);
                                    items[i].availableQuantity++;
                                 
                                    break;
                                  }
                                }
                                item.availableQuantity--;
                                if (item.availableQuantity == 0) {
                                  for (int i = 0;
                                      i < cart.localitems.length;
                                      i++) {
                                    if (cart.localitems[i].id == item.id) {
                                      removeItemFromCart(cartId: cart.cartId, itemId: item.id);
                                      cart.localitems.removeAt(i);
                                      break;
                                    }
                                  }
                                }
                                updateTotal();
                               }catch(e){
                                 ScaffoldMessenger.of(context)
                                   .showSnackBar(
                                     SnackBar(
                                       content: Text(
                                           'Failed to update stock!'),
                                       backgroundColor: Colors.red,
                                     ),
                                  );
                                  return;
 
                               }
                              },
                            ),
                            Text(
                              '${item.availableQuantity}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: black,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: blueAccent),
                              onPressed: () {
                                for (int i = 0; i < items.length; i++) {
                                  if (items[i].id == item.id) {
                                    if (items[i].availableQuantity <= 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Cannot exceed available stock!')),
                                      );
                                    } else {
                                     try{
                                        updateItemQuantity(items[i].id,
                                          items[i].availableQuantity - 1);
                                      items[i].availableQuantity--;
                                     
                                      item.availableQuantity++;
                                     }catch(e){
                                       ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                              content: Text(
                                                  'Failed to update stock!'),
                                                  backgroundColor: Colors.red,
                                              ),
                                       );
                                     }
                                    }
                                    break;
                                  }
                                }

                                updateTotal();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    for (int i = 0; i < items.length; i++) {
                      if (items[i].id == item.id) {
                        updateItemQuantity(items[i].id, items[i].availableQuantity+item.availableQuantity);
                        items[i].availableQuantity += item.availableQuantity;
                        break;
                      }
                    }
                    for (int i = 0; i < cart.localitems.length; i++) {
                      if (cart.localitems[i].id == item.id) {
                        cart.localitems.removeAt(i);
                        break;
                      }
                    }
                    updateTotal();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
