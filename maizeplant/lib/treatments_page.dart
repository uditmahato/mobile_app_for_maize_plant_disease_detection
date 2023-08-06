import 'package:flutter/material.dart';

class TreatmentsPage extends StatelessWidget {
  final String disease;

  const TreatmentsPage({required this.disease});

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
    return AlertDialog(
      title: Text('Treatments for $disease'),
      content: Text(_getTreatments(disease)),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
