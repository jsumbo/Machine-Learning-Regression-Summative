import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(LoanPredictorApp());
}

class LoanPredictorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Predictor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoanPredictorScreen(),
    );
  }
}

class LoanPredictorScreen extends StatefulWidget {
  @override
  _LoanPredictorScreenState createState() => _LoanPredictorScreenState();
}

class _LoanPredictorScreenState extends State<LoanPredictorScreen> {
  final TextEditingController earningsController = TextEditingController();
  String? prediction;

  Future<void> predictRecipients() async {
    final url = Uri.parse('https://ml-summative-9b0c4737c339.herokuapp.com/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"mean_earnings": double.parse(earningsController.text)}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        prediction = "Predicted Recipients: ${data['predicted_recipients']}";
      });
    } else {
      setState(() {
        prediction = "Error: Unable to get prediction";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loan Predictor')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: earningsController,
              decoration: InputDecoration(labelText: 'Mean Earnings After Graduation'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: predictRecipients,
              child: Text('Predict'),
            ),
            SizedBox(height: 20),
            if (prediction != null) Text(prediction!),
          ],
        ),
      ),
    );
  }
}
