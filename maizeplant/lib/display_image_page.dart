import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:maizeplant/home_page.dart';

class DisplayImagePage extends StatefulWidget {
  final Uint8List imageData;
  final String prediction;
  final double confidenceLevel;

  const DisplayImagePage({
    required this.imageData,
    required this.prediction,
    required this.confidenceLevel,
  });

  @override
  _DisplayImagePageState createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  bool _showSymptoms = false;
  bool _showTreatments = false;

  String _getSymptoms(String disease) {
    Map<String, String> diseaseSymptoms = {
      "Blight": "Symptoms of Blight: Yellow spots on leaves, wilting.",
      "Common_Rust": "Symptoms of Common Rust: Orange pustules on leaves.",
      "Gray_Leaf_Spot": "Symptoms of Gray Leaf Spot: Grayish spots on leaves.",
      "Healthy": "No symptoms. The plant is healthy.",
    };
    return diseaseSymptoms[disease] ?? "Symptoms not available.";
  }

  String _getTreatments(String disease) {
    Map<String, String> diseaseTreatments = {
      "Blight":
          "Treatments for Blight: Apply fungicides and proper irrigation.",
      "Common_Rust":
          "Treatments for Common Rust: Apply fungicides and remove affected leaves.",
      "Gray_Leaf_Spot":
          "Treatments for Gray Leaf Spot: Apply fungicides and manage plant debris.",
      "Healthy": "No treatments required. The plant is healthy.",
    };
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
            Image.memory(widget.imageData),
            SizedBox(height: 20.0),
            Text(
              'Predicted Class: ${widget.prediction}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Confidence Level: ${widget.confidenceLevel.toStringAsFixed(4)} %',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showSymptoms = !_showSymptoms;
                });
              },
              child: Text('Show Symptoms'),
            ),
            if (_showSymptoms)
              Text(
                _getSymptoms(widget.prediction),
                style: TextStyle(fontSize: 16.0),
              ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showTreatments = !_showTreatments;
                });
              },
              child: Text('Show Treatments'),
            ),
            if (_showTreatments)
              Text(
                _getTreatments(widget.prediction),
                style: TextStyle(fontSize: 16.0),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        },
        child: Icon(Icons.home),
        tooltip: 'Home',
      ),
    );
  }
}
