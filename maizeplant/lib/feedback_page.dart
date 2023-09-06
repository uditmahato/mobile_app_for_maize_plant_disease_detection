import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Import the Firebase Realtime Database package

final DatabaseReference _feedbackRef =
    FirebaseDatabase.instance.ref().child('feedback');

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _feedbackController = TextEditingController();
  List<String> _feedbackList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Page'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _feedbackController,
            decoration: InputDecoration(
              labelText: 'Add Feedback',
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _addFeedbackToDatabase(
                      _feedbackController.text); // Add feedback to the database
                  setState(() {
                    _feedbackController.clear();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _feedbackList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_feedbackList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to add feedback to the Realtime Database
  Future<void> _addFeedbackToDatabase(String feedback) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final newFeedbackRef = _feedbackRef.child(user.uid).push();
        await newFeedbackRef.set(feedback);
        setState(() {
          _feedbackList.add(feedback);
        });
        print('Feedback added to the database.');
      } else {
        print('User is not authenticated.');
      }
    } catch (e) {
      print('Failed to add feedback to the database: $e');
    }
  }
}
