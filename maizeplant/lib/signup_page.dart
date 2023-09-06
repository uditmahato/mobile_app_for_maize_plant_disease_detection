import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Import the FirebaseDatabase package
import 'home_page.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _fullNameController =
      TextEditingController(); // Add this line
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _performSignup(BuildContext context) async {
    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        print('Passwords do not match');
      }

      // Create user account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Store full name in the database
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users').child(userId);
      userRef.set({
        'full_name': _fullNameController.text,
      });

      // Successfully signed up, show success dialog
      _showSignupSuccessDialog(context);
    } catch (e) {
      // Handle signup failure
      print('Signup failed: $e');
      // Show an error message or dialog
    }
  }

  void _showSignupSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Signup Success'),
          content: Text('Thank you for signing up!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Navigate back to the Login Page
                Navigator.pop(context); // Go back to the previous page
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup Page')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _performSignup(context);
                },
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
