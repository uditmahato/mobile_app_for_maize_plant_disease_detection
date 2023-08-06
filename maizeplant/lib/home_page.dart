import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'display_image_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  bool _isModelReady = false;

  @override
  void initState() {
    super.initState();
    // Code to initialize the model, if required.
    _isModelReady =
        true; // For demonstration purposes, setting it to true immediately.
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return;
      setState(() {
        _image = File(pickedImage.path);
      });
      print('Image picked successfully.');
    } catch (e) {
      print('Failed to pick and process image: $e');
    }
  }

  void _navigateToDisplayImagePage(String prediction, double confidenceLevel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayImagePage(
          image: _image!,
          prediction: prediction,
          confidenceLevel: confidenceLevel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maize Plant Disease Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null) Image.file(_image!),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick Image'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                if (_isModelReady && _image != null) {
                  // Call your model inference function here
                  String prediction =
                      "Blight"; // Replace with actual prediction
                  double confidenceLevel =
                      0.85; // Replace with actual confidence level
                  _navigateToDisplayImagePage(prediction, confidenceLevel);
                } else {
                  print('Cannot predict. Model or image is not ready.');
                }
              },
              child: Text('Predict Disease'),
            ),
          ],
        ),
      ),
    );
  }
}
