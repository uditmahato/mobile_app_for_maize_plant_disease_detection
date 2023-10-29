import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isHovering = ValueNotifier<bool>(false);

  void _performLogin(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Successfully logged in, navigate to the home page
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      // Handle login failure
      print('Login failed: $e');
      // Show a SnackBar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: Check your email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page',
            style: TextStyle(
                fontSize: 26.0,
                color: const Color.fromARGB(255, 255, 255, 255))),
        backgroundColor:
            Color.fromARGB(255, 7, 107, 35), // Made app bar transparent
        elevation: 0, // Removed shadow from app bar
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/cover.png'), // Add your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/login.png', height: 180.0),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 255, 246, 246)),
                      fillColor: Colors.white.withOpacity(
                          0.5), // Added background color to the text field
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.white),
                      fillColor: Colors.white.withOpacity(
                          0.5), // Added background color to the text field
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _performLogin(context);
                  },
                  child: Text('Login', style: TextStyle(fontSize: 20.0)),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 7, 107, 35),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Don't have an account?",
                    style: TextStyle(fontSize: 18.0, color: Colors.white)),
                SizedBox(height: 10),
                MouseRegion(
                  onEnter: (_) {
                    _isHovering.value = true;
                  },
                  onExit: (_) {
                    _isHovering.value = false;
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _isHovering,
                    builder: (context, isHovering, child) {
                      return TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        },
                        child: Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: isHovering
                                ? const Color.fromARGB(
                                    255, 0, 128, 0) // Green text when hovered
                                : const Color.fromARGB(255, 0, 0,
                                    0), // Black text when not hovered
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: isHovering
                              ? Colors.white // White background when hovered
                              : null, // Transparent background when not hovered
                        ),
                      );
                    },
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
