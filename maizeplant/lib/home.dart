import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String? _prediction;
  double? _confidenceLevel;
  bool _isModelReady = false;

  @override
  void initState() {
    super.initState();
    loadModel().then((_) {
      setState(() {
        _isModelReady = true;
        print('Model is ready.');
      });
    });
  }

  Future<void> loadModel() async {
    // No need to load the model in the Flutter code as it's now handled by the FastAPI server.
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

  Future<void> runModelOnImage() async {
    if (_isModelReady && _image != null) {
      try {
        var request = http.MultipartRequest(
            'POST', Uri.parse('http://localhost:8000/predict'));

        request.files
            .add(await http.MultipartFile.fromPath('file', _image!.path));

        var response = await request.send();
        var result = await response.stream.bytesToString();
        var jsonResult = json.decode(result);
        var prediction = jsonResult['prediction'] as String;
        var confidenceLevel = jsonResult['confidence_level'] as double;

        setState(() {
          _prediction = prediction;
          _confidenceLevel = confidenceLevel * 100;
        });

        print('Model inference successful.');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayImagePage(
              image: File(_image!.path),
              prediction: _prediction!,
              confidenceLevel: _confidenceLevel!,
            ),
          ),
        );
      } catch (e) {
        print('Failed to run model: $e');
      }
    } else {
      print('Model is not ready or image is null.');
    }
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
                  runModelOnImage();
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

class DisplayImagePage extends StatelessWidget {
  final File image;
  final String prediction;
  final double confidenceLevel;

  const DisplayImagePage({
    required this.image,
    required this.prediction,
    required this.confidenceLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(image),
            SizedBox(height: 20.0),
            Text(
              'Predicted Class: $prediction',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Confidence Level: ${confidenceLevel.toStringAsFixed(4)} %',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
