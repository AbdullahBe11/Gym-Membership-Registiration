import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  String url = "http://abdullahberro.atwebpages.com";
  List data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var response = await http.get(Uri.parse("$url/get_members.php"));

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteMember(String id) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deleting..."), backgroundColor: Colors.amberAccent, duration: Duration(seconds: 1)),
      );

      var response = await http.post(
        Uri.parse("$url/delete_member.php"),
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        getData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User Deleted Successfully!!!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting member"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.black87,
        titleTextStyle: TextStyle(color: Colors.amberAccent, fontSize: 20),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.amberAccent),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            },
          )
        ],
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.amberAccent))
          : data.isEmpty
          ? Center(child: Text("No Members Found", style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var user = data[index];

          String id = user['id'].toString();
          String name = "${user['first_name']} ${user['last_name']}";
          String age = user['age'].toString();
          String plan = user['membership_type'];
          String price = user['total_price'].toString();
          String coach = "Without Coach";

          if (user['coach_option'] == "yes") {
            coach = "With Coach";
          }

          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ExpansionTile(
              iconColor: Colors.amberAccent,
              collapsedIconColor: Colors.amberAccent,
              title: Text(
                "$id - $name",
                style: TextStyle(color: Colors.amberAccent, fontSize: 18),
              ),
              trailing: Text(
                "\$$price",
                style: TextStyle(color: Colors.amberAccent, fontSize: 18),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ID", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            Text(id, style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Age", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            Text(age, style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Membership", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            Text(plan, style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Coach Status", style: TextStyle(color: Colors.white70, fontSize: 16)),
                            Text(coach, style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          deleteMember(id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Delete Member"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}