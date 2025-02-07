import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';


class OffersListPage extends StatefulWidget {
  @override
  _OffersListPageState createState() => _OffersListPageState();
}

class _OffersListPageState extends State<OffersListPage> {
  List<Offer> fillteredoffers = [];
  @override
  void initState() {
  
    super.initState();
   m();
  }
  void m() async{
      await getusers();
  await getOffers();
  fillteredoffers=offers.where((element) => element.posterid==global_user.id,).toList();
  setState(() {
    
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offers List',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: blueAccent,
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.black54,
      ),
      body: offers.isEmpty
          ? Center(
              child: Text(
                'No Offers Available',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: fillteredoffers.length,
              itemBuilder: (context, index) {
                
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [blueAccent, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        '${fillteredoffers[index].title}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discount: ${fillteredoffers[index].discount}% off',
                            style: TextStyle(
                              fontSize: 18,
                              color: white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Description: ${fillteredoffers[index].description}',
                            style: TextStyle(fontSize: 16, color: white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Valid Until: ${fillteredoffers[index].validUntil.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: white),
                          ),
                          Text(
                            'Posted By: ${getusernaembyid(fillteredoffers[index].posterid)}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[300]),
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

  String getusernaembyid(int id) {
    for (int i = 1; i < users.length; i++) {
      if (users[i].id == id) {
        return users[i].name;
      }
    }

    return "";
  }
}
