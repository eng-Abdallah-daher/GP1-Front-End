import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';



class TowingServicePage extends StatefulWidget {
  @override
  _TowingServicePageState createState() => _TowingServicePageState();
}

class _TowingServicePageState extends State<TowingServicePage> {
  List<TowingService> filteredServices = towingServices;
@override
  void initState() {
    
    super.initState();
    m();
  }
  void m() async {

    await getTowingServices();
    filteredServices = towingServices;
    setState(() {
      
    });
    }
  void deleteService(TowingService service) {
    setState(() {
      deletetowservice(service.id);
      towingServices.remove(service);
      filteredServices = towingServices;
    });
  }

  void updateService(TowingService service) {
    TextEditingController nameController =
        TextEditingController(text: service.name);
    TextEditingController addressController =
        TextEditingController(text: service.address);
    TextEditingController phoneController =
        TextEditingController(text: service.phone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Update Service',
            style: TextStyle(
              color: blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: blueAccent),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: blueAccent),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: TextStyle(color: blueAccent),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.only(bottom: 12, right: 12, left: 12),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        updatetowservice(service.id, nameController.text, addressController.text, phoneController.text);
                        service.name = nameController.text;
                        service.address = addressController.text;
                        service.phone = phoneController.text;
                        filteredServices = towingServices;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Update',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: white),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

  }

  void filterServices(String query) {
    setState(() {
      filteredServices = towingServices
          .where((service) =>
              service.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: blue,
        title:Text("carMate",style: TextStyle(color: white),),),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: TextField(
              onChanged: filterServices,
              style: TextStyle(color: white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search Towing Services',
                hintStyle: TextStyle(color: white),
                prefixIcon: Icon(Icons.search, color: white),
                filled: true,
                fillColor:Colors.blue[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final service = filteredServices[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [blueAccent, lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                service.name,
                                style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.local_taxi,
                              color: white,
                              size: 24,
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                service.address,
                                style: TextStyle(
                                  color: white,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                service.phone,
                                style: TextStyle(
                                  color: white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => updateService(service),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: white,
                                foregroundColor: blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                              ),
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => deleteService(service),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TowingServicePage(),
  ));
}
