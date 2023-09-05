import 'package:flutter/material.dart';
import 'treatments_page.dart';

class DiseaseSymptomsPage extends StatelessWidget {
  final String disease;

  const DiseaseSymptomsPage({required this.disease});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms of $disease'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getSymptoms(disease),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TreatmentsPage(disease: disease);
                  },
                );
              },
              child: Text('Treatments'),
            ),
          ],
        ),
      ),
    );
  }
}
