import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class Gym extends StatefulWidget{
  @override
  State<Gym> createState() => _GymState();
}

class _GymState extends State<Gym> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final  _ageController = TextEditingController();
  final String baseUrl = "http://abdullahberro.atwebpages.com";

  String coach = "no";
  String membership = "daily";
  String result = "";
  String value="yes";

  String get fname => _firstNameController.text;
  String get lname => _lastNameController.text;
  String get age => _ageController.text;


  Future<void> calculate() async {
    int total = 0;

    // --- YOUR EXISTING LOGIC ---
    if (membership == "daily") {
      if (coach == "yes") {
        total = 10;
      } else {
        total = 5;
      }
    }

    if (membership == "month") {
      if (coach == "yes") {
        total = 60;
      } else {
        total = 30;
      }
    }

    if (membership == "5months") {
      if (coach == "yes") {
        total = 170;
      } else {
        total = 110;
      }
    }


    setState(() {
      result = "Welcome $fname $lname\n"
          "Membership: $membership\n"
          "Coach: $coach\n"
          "Total Price: \$$total";
    });


    if (fname.isNotEmpty && lname.isNotEmpty && age.isNotEmpty) {
      try {
        var response = await http.post(
          Uri.parse("$baseUrl/add_member.php"),
          body: jsonEncode({
            "first_name": fname,
            "last_name": lname,
            "age": int.tryParse(age) ?? 0,
            "membership_type": membership,
            "coach_option": coach,
            "total_price": total
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Member Registered Successfully"), backgroundColor: Colors.amberAccent),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connection Error: Could not Register"), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields to Register"), backgroundColor: Colors.amber),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.amberAccent),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
            },
          )
        ],
        backgroundColor: Colors.black87,
        title: Text("Cedars GYM"),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.amberAccent ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black87,
      body:
      Center(
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _firstNameController,
                  style: TextStyle(color: Colors.white),
                  decoration:  InputDecoration(
                    hintText:"Enter Your First Name" ,
                    hintStyle: TextStyle(color: Colors.amberAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amberAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amberAccent),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _lastNameController,
                  style: TextStyle(color: Colors.white),
                  decoration:  InputDecoration(
                    hintText:"Enter Your Last Name" ,
                    hintStyle: TextStyle(color: Colors.amberAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amberAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amberAccent),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  style: TextStyle(color: Colors.white),
                  decoration:  InputDecoration(
                    hintText:"Enter Your Age" ,
                    hintStyle: TextStyle(color: Colors.amberAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amberAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amberAccent),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                const Text("Coach Option",style: TextStyle(fontSize: 18,color: Colors.amberAccent)),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RadioGroup(child: Radio(
                      value: "yes",
                      groupValue: coach,
                      onChanged: (value) {
                        setState(() {
                          coach = value.toString();
                        });
                      },
                      activeColor: Colors.amberAccent,
                    ),
                      groupValue: coach,
                      onChanged: (value) {
                        setState(() {
                          coach = value.toString();
                        });
                      },
                    ),
                    const Text("With Coach",style: TextStyle(fontSize: 18,color: Colors.amberAccent)),
                    RadioGroup(child: Radio(
                      value: "no",
                      groupValue: coach,
                      onChanged: (value) {
                        setState(() {
                          coach = value.toString();
                        });
                      },
                      activeColor: Colors.amberAccent,
                    ),
                      groupValue: coach,
                      onChanged: (value) {
                        setState(() {
                          coach = value.toString();
                        });
                      },
                    ),
                    const Text("Without Coach",style: TextStyle(fontSize: 18,color: Colors.amberAccent,)),
                  ],
                ),
                SizedBox(height: 30),
                const Text("Membership Option",style: TextStyle(fontSize: 18,color: Colors.amberAccent)),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RadioGroup(
                      child: Radio(
                        value: "daily",
                        groupValue: membership,
                        onChanged: (value) {
                          setState(() {
                            membership = value.toString();
                          });
                        },
                        activeColor: Colors.amberAccent,
                      ),
                      groupValue: membership,
                      onChanged: (value) {
                        setState(() {
                          membership = value.toString();
                        });
                      },
                    ),
                    const Text("Daily",style: TextStyle(fontSize: 18,color: Colors.amberAccent,)),
                    RadioGroup(
                      child: Radio(
                        value: "month",
                        groupValue: membership,
                        onChanged: (value) {
                          setState(() {
                            membership = value.toString();
                          });
                        },
                        activeColor: Colors.amberAccent,
                      ),
                      groupValue: membership,
                      onChanged: (value) {
                        setState(() {
                          membership = value.toString();
                        });
                      },
                    ),
                    const Text("Monthly",style: TextStyle(fontSize: 18,color: Colors.amberAccent)),
                    RadioGroup(
                      child: Radio(
                        value:"5months",
                        groupValue: membership,
                        onChanged: (value) {
                          setState(() {
                            membership=value.toString();
                          });
                        },
                        activeColor: Colors.amberAccent,
                      ),
                      groupValue: membership,
                      onChanged: (value) {
                        setState(() {
                          membership=value.toString();
                        });
                      },
                    ),
                    const Text("5 Months",style: TextStyle(fontSize: 18,color: Colors.amberAccent)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        calculate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Calculate",style: TextStyle(fontSize: 18),),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  color: Colors.amberAccent,
                  child:ListTile(
                    title: Text(result,style: TextStyle(fontSize: 18,color: Colors.black87)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          result = "";
                          _firstNameController.clear();
                          _lastNameController.clear();
                          _ageController.clear();
                          coach = "no";
                          membership = "daily";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.amberAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Clear",style: TextStyle(fontSize: 18),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class RadioGroup extends StatelessWidget {
  final Widget child;
  final String groupValue;
  final ValueChanged<Object?> onChanged;

  const RadioGroup({
    Key? key,
    required this.child,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.amberAccent,
      ),
      child: child is Radio
          ? Radio<Object>(
        value: (child as Radio).value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: Colors.amberAccent,
      )
          : child,
    );
  }
}