import 'package:CarMate/SalesManagementPage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/manage_tools_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> topSellingTools = [];
  @override
  void initState() {
   
 
  
   
    super.initState();
    m();
  }
  void m () async{
      
await getItems();
    await getSales();
    topSellingTools = getTopSellingTools();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1E90FF),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.white),
            tooltip: 'Update Tools',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageToolsPage(),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Tools',
                          items.where((element) => element.ownerid==global_user.id).where((sale) => sale.ownerid == global_user.id)
                              .length
                              .toString(),
                            
                          Icons.build,
                          Colors.blue,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Sales',
                          '\$${sales.where((sale) => sale.ownerid == global_user.id).length.toString()}',
                          Icons.attach_money,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Top Selling Tools'),
              SizedBox(height: 10),
              _buildTopSellingToolsList(),
              SizedBox(height: 10),
              _buildActionButton(
                title: 'Manage Sales',
                icon: Icons.monetization_on,
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesManagementPage(),
                    ),
                  );
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.5),
                  color.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        icon,
                        size: 40,
                        color: color,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTopSellingToolsList() {
    return Column(
      children: topSellingTools.map((tool) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              _showToolDetailsDialog(context, tool);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.build,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tool['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sales: ${tool['quantity']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showToolDetailsDialog(BuildContext context, Map<String, dynamic> tool) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            tool['name'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.blueAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                if (tool['imageUrl'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        tool['imageUrl'],
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Sales: ${tool['quantity']}',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Description: ${tool['description'] ?? 'No description available.'}',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
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

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required Function onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28, color: Colors.white),
      label: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        shadowColor: Colors.black54,
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        onPressed();
      },
    );
  }
}
