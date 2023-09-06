import 'dart:typed_data';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:maizeplant/feedback_page.dart';

import 'display_image_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();
  User? _user;
  String? _fullName; // Declare a variable to store the full name

  @override
  void initState() {
    super.initState();
    userStream.listen((user) {
      setState(() {
        _user = user;
        _fetchFullName(); // Fetch the full name when user data is updated
      });
    });
  }

  Future<void> _fetchFullName() async {
    if (_user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(_user!.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.value != null) {
        Map<String, dynamic> userData = snapshot.value as Map<String, dynamic>;
        setState(() {
          _fullName = userData['full_name'];
        });
      }
    }
  }

  Uint8List? _imageData;
  String? _prediction;
  double? _confidenceLevel;
  bool _isModelReady = true;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return;
      final imageData = await pickedImage.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
      print('Image picked successfully.');
    } catch (e) {
      print('Failed to pick and process image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick and process image: $e')),
      );
    }
  }

  Future<void> _runModelOnImage() async {
    if (_isModelReady && _imageData != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:8000/predict'),
        );

        request.files.add(http.MultipartFile.fromBytes('file', _imageData!,
            filename: 'image.jpg'));

        var response = await request.send();
        var result = await response.stream.bytesToString();
        var jsonResult = json.decode(result);
        var prediction = jsonResult['prediction'] as String;
        var confidenceLevel = jsonResult['confidence_level'] as double;

        setState(() {
          _prediction = prediction;
          _confidenceLevel = confidenceLevel * 100;
          _isLoading = false;
        });

        print('Model inference successful.');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayImagePage(
              imageData: _imageData!,
              prediction: _prediction!,
              confidenceLevel: _confidenceLevel!,
            ),
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Failed to run model: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to run model: $e')),
        );
      }
    } else {
      print('Model is not ready or image is null.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Model is not ready or image is null.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maize Plant Disease Detection'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_fullName ?? 'Guest'),
              accountEmail: Text(_user?.email ?? 'No Email'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: _user?.photoURL != null
                    ? NetworkImage(_user!.photoURL!)
                    : NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/005/153/495/original/cartoon-builder-mascot-logo-a-builder-man-character-holding-a-hat-logo-templates-for-business-identity-architecture-property-real-estate-residential-solutions-home-staging-building-engineers-vector.jpg',
                      ),
              ),
            ),
            ListTile(
              title: Text('Feedback'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackPage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) CircularProgressIndicator(),
            if (_imageData != null) Image.memory(_imageData!),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick Image'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _runModelOnImage,
              child: Text('Predict Disease'),
            ),
          ],
        ),
      ),
    );
  }
}
