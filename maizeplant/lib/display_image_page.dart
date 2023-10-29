import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:maizeplant/generate_pdf.dart';
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
      "Blight":
          "1. Yellow spots on leaves\n2. Wilting\n3. Brown lesions on stems\n4. Premature leaf drop\n5. Fruit with dark spots\n6. Reduced yield.",
      "Common_Rust":
          "1. Orange pustules on leaves\n2. Yellowing of leaves\n3. Stunted growth\n4. Twisted and distorted leaves\n5. Powdery orange spores on stems\n6. Reduced fruit quality.",
      "Gray_Leaf_Spot":
          "1. Grayish spots on leaves\n2. Older leaves turning yellow\n3. Lesions along the veins of the leaves\n4. Spots becoming necrotic over time\n5. Premature leaf drop\n6. Reduced plant vigor.",
      "Healthy": "No symptoms. The plant is healthy.",
    };

    return diseaseSymptoms[disease] ?? "Symptoms not available.";
  }

  String _getTreatments(String disease) {
    Map<String, String> diseaseTreatments = {
      "Blight":
          "1. Apply fungicides\n2. Ensure proper irrigation\n3. Remove infected plants to prevent spread\n4. Use resistant varieties of plants\n5. Implement crop rotation\n6. Maintain proper plant spacing to reduce humidity.",
      "Common_Rust":
          "1. Apply fungicides\n2. Remove affected leaves\n3. Use rust-resistant varieties of plants\n4. Apply appropriate fertilizers to enhance plant resistance\n5. Implement crop rotation to reduce infection\n6. Manage weeds which can harbor rust pathogens.",
      "Gray_Leaf_Spot":
          "1. Apply fungicides\n2. Manage plant debris to reduce infection sources\n3. Use resistant varieties of plants\n4. Implement crop rotation to break disease cycle\n5. Maintain proper plant spacing to improve air circulation\n6. Apply foliar fungicides at the first sign of infection.",
      "Healthy": "No treatments required. The plant is healthy.",
    };

    return diseaseTreatments[disease] ?? "Treatments not available.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Display', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.memory(widget.imageData),
              SizedBox(height: 20.0),
              Text(
                'Predicted Class: ${widget.prediction}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                'Confidence Level: ${widget.confidenceLevel.toStringAsFixed(2)} %',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showSymptoms = !_showSymptoms;
                  });
                },
                child: Text('Show Symptoms'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              SizedBox(height: 10.0),
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              if (_showTreatments)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _getTreatments(widget.prediction),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await GeneratePdfPage.generatePdf(
                    imageData: widget.imageData,
                    prediction: widget.prediction,
                    confidenceLevel: widget.confidenceLevel,
                    symptoms: _getSymptoms(widget.prediction),
                    treatments: _getTreatments(widget.prediction),
                  );
                },
                child: Text('Generate PDF'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
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
        child: Icon(Icons.home, color: Colors.white),
        backgroundColor: Colors.green[700],
        tooltip: 'Home',
      ),
    );
  }
}
