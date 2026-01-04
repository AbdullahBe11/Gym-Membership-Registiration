import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'gym.dart';
import 'admin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;


  final String baseUrl = "http://abdullahberro.atwebpages.com";

  Future<void> login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showMessage("Please enter username and password");
      return;
    }

    if (username == 'admin' && password == 'Admin') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Admin()));
      return;
    }

    if (username == 'user' && password == 'user1234') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Gym()));
      return;
    }

    setState(() => _isLoading = true);

    try {
      var response = await http.post(
        Uri.parse("$baseUrl/login_user.php"),
        body: jsonEncode({"username": username, "password": password}),
      );

      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Gym()));
      } else {
        showMessage("Login Failed: ${data['message']}");
      }
    } catch (e) {
      showMessage("Connection Error. Check Internet.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> register() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showMessage("Enter username and password to register");
      return;
    }

    setState(() => _isLoading = true);

    try {
      var response = await http.post(
        Uri.parse("$baseUrl/register_user.php"),
        body: jsonEncode({"username": username, "password": password}),
      );

      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        showMessage("Account Created! You can now Login.");
      } else {
        showMessage(data['message']);
      }
    } catch (e) {
      showMessage("Connection Error.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.amber),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(title: const Text('Cedars GYM'), backgroundColor: Colors.black87, centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Login", style: TextStyle(fontSize: 35, color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                TextField(controller: _usernameController, style: const TextStyle(color: Colors.white), decoration: _inputStyle("Username", Icons.person)),
                const SizedBox(height: 20),
                TextField(controller: _passwordController, obscureText: true, style: const TextStyle(color: Colors.white), decoration: _inputStyle("Password", Icons.lock)),
                const SizedBox(height: 30),
                _isLoading ? const CircularProgressIndicator(color: Colors.amberAccent) : Column(children: [
                  MaterialButton(onPressed: login, minWidth: 200, height: 50, color: Colors.amberAccent, child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 15),
                  TextButton(onPressed: register, child: const Text("Register as New User", style: TextStyle(color: Colors.white70)))
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.amberAccent),
      prefixIcon: Icon(icon, color: Colors.amberAccent),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
    );
  }
}