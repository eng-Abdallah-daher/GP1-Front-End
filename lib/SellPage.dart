import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';


class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {

     @override
  void initState() {
    super.initState();
  m();
  }
  void m() async{
      await getSales();
   await getSalesRequests();
   setState(() {
     
   });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Requests',
          style: TextStyle(
            fontSize:
                screenWidth < 350 ? screenWidth * 0.04 : screenWidth * 0.09,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: screenWidth * 0.07,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child:
            salesrequests
                .where((sale) => sale.ownerid == global_user.id).isEmpty
                ? Center(
                    child: Text(
                      'No sales recorded.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount =
                          (constraints.maxWidth ~/ 350).clamp(1, 4);
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: screenWidth * 0.03,
                          mainAxisSpacing: screenHeight * 0.02,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: salesrequests.length,
                        itemBuilder: (context, index) {
                          if (salesrequests[index].ownerid == global_user.id) {
                            return _buildSalesCard(context, salesrequests[index],
                                screenWidth, screenHeight);
                          } else {
                            return SizedBox(height: 0,);
                          }
                        },
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildSalesCard(BuildContext context, dynamic sale, double screenWidth,
      double screenHeight) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_bag,
                    color: Colors.white, size: screenWidth * 0.07),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Text(
                    getitemnamebyid(sale.itemid),
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Quantity: ${sale.quantity}',
              style: TextStyle(
                  fontSize: screenWidth * 0.04, color: Colors.white70),
            ),
            Text(
              'Price: \$${sale.price.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: screenWidth * 0.04, color: Colors.white70),
            ),
            Text(
              'Date: ${sale.formattedDate}',
              style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontStyle: FontStyle.italic,
                  color: Colors.white60),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _approveRequest(context, sale);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.012,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check, size: screenWidth * 0.045),
                      SizedBox(width: 5),
                      Text(
                        'Approve',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _rejectRequest(context, sale);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.012,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.close, size: screenWidth * 0.045),
                      SizedBox(width: 5),
                      Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _approveRequest(BuildContext context, SaleRequest sale) {
  try{
      setState(() {
deleteSalesRequest(sale.id);
      salesrequests.remove(sale);
      
      addSale(id: sales[sales.length - 1].id + 1,ownerId: sale.ownerid, itemId: sale.itemid, quantity: sale.quantity, price: sale.price, date: sale.date);
      sales.add(Sale(id: sales[sales.length - 1].id + 1,ownerid: sale.ownerid, itemid: sale.itemid, quantity: sale.quantity, price: sale.price, date: sale.date));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Request for ${getitemnamebyid(sale.itemid)} approved!',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Failed to approve request for ${getitemnamebyid(sale.itemid)}.',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
  }

  void _rejectRequest(BuildContext context, SaleRequest sale) {
    setState(() {
try{
        deleteSalesRequest(sale.id);
      salesrequests.remove(sale);
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Request for ${getitemnamebyid(sale.itemid)} rejected.',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
}catch(e){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Failed to reject request for ${getitemnamebyid(sale.itemid)}.',
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ),
  );
 
}
    });

  
  }
}
