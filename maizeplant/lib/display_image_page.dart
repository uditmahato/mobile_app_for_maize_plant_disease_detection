import 'dart:io';
import 'package:flutter/material.dart';

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Symptoms of $prediction'),
          content: Text(_getSymptoms(prediction)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTreatments(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Treatments for $prediction'),
          content: Text(_getTreatments(prediction)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _getSymptoms(String disease) {
    // Define the symptoms for each disease here
    Map<String, String> diseaseSymptoms = {
      "Blight": "Symptoms of Blight: Yellow spots on leaves, wilting.",
      "Common_Rust": "Symptoms of Common Rust: Orange pustules on leaves.",
      "Gray_Leaf_Spot": "Symptoms of Gray Leaf Spot: Grayish spots on leaves.",
      "Healthy": "No symptoms. The plant is healthy.",
    };

    // Return the symptoms for the given disease, or a default message if not found.
    return diseaseSymptoms[disease] ?? "Symptoms not available.";
  }

  String _getTreatments(String disease) {
    // Define the treatments for each disease here
    Map<String, String> diseaseTreatments = {
      "Blight":
          "Treatments for Blight: Apply fungicides and proper irrigation.",
      "Common_Rust":
          "Treatments for Common Rust: Apply fungicides and remove affected leaves.",
      "Gray_Leaf_Spot":
          "Treatments for Gray Leaf Spot: Apply fungicides and manage plant debris.",
      "Healthy": "No treatments required. The plant is healthy.",
    };

    // Return the treatments for the given disease, or a default message if not found.
    return diseaseTreatments[disease] ?? "Treatments not available.";
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
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _showTreatments(context),
              child: Text('Treatments'),
            ),
          ],
        ),
      ),
    );
  }
}
