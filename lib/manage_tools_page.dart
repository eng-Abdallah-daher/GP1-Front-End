import 'package:first/edit_tool_page.dart';
import 'package:flutter/material.dart';
import 'glopalvars.dart';

class ManageToolsPage extends StatefulWidget {
  @override
  _ManageToolsPageState createState() => _ManageToolsPageState();
}

class _ManageToolsPageState extends State<ManageToolsPage> {
  List<Item> filteredTools = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredTools =
        items.where((sale) => sale.ownerid == global_user.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Tools',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 30, 144, 255),
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTools.length,
                itemBuilder: (context, index) {
                  return _buildToolCard(context, filteredTools[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search Tool',
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        suffixIcon: Icon(Icons.search, color: Colors.blueAccent),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
          filteredTools = items
              .where((tool) =>
                  tool.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
        });
      },
    );
  }

  Widget _buildToolCard(BuildContext context, Item tool, int index) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          child: ListTile(
            title: Text(
              tool.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Price: \$${tool.price.toStringAsFixed(2)}\nQuantity: ${tool.availableQuantity}',
              style: TextStyle(color: Colors.black54),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _navigateToEditTool(context, items.indexOf(tool));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _confirmDelete(context, items.indexOf(tool));
                  },
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 195, 233, 251).withOpacity(0.8),
                Colors.blue.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ));
  }

  void _navigateToEditTool(BuildContext context, int index) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => EditToolPage(index: index),
      ),
    )
        .then((value) {
      setState(() {
        filteredTools = items
            .where((tool) =>
                tool.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      });
    });
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          title: Text(
            'Confirm Delete',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this tool?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.cancel, color: Colors.white),
              label: Text('Cancel', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _deleteTool(index);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.delete, color: Colors.white),
              label: Text('Delete', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteTool(int index) {
    setState(() {
      items.removeAt(index);
      filteredTools.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tool deleted successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
