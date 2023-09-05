import 'dart:io';
import 'package:flutter/material.dart';
import 'disease_symptoms_page.dart';

class DisplayImagePage extends StatelessWidget {
  final File image;
  final String prediction;
  final double confidenceLevel;

  const DisplayImagePage({
    required this.image,
    required this.prediction,
    required this.confidenceLevel,
  });

  void _showSymptoms(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseSymptomsPage(disease: prediction),
      ),
    );
  }

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
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _showSymptoms(context),
              child: Text('Show Symptoms'),
            ),
          ],
        ),
      ),
    );
  }
}
