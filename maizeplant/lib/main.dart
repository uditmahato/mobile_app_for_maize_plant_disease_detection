import 'package:flutter/material.dart';
import 'package:maizeplant/login_page.dart';
import 'home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    print("Firebase initialized successfully");
  }).catchError((error) {
    print("Failed to initialize Firebase: $error");
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maize Plant Disease Detector',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        hintColor: Color(0xFF8BC34A),
        errorColor: Color(0xFFF44336),
        backgroundColor: Color(0xFFA5D6A7),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFF8BC34A),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 30.0,
          ),
          bodyText1: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 24.0,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(), // Use WelcomePage as the initial page
        '/home': (context) => HomePage(),
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255), // Greenery color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Maize.png', // Your logo asset
              height: 200, // Height of the logo
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Maize Plant Disease Detector',
              style: const TextStyle(
                color: Color.fromARGB(255, 12, 84, 36), // Text color
                fontSize: 24.0, // Text font size
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 7, 107, 35), // Green background
                padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20), // Adjust the padding to increase button size
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Developed by Udit',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
