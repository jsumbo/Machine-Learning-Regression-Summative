import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final TextEditingController _numLoansController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _isPrivateController = TextEditingController();
  final TextEditingController _isSubsidizedController = TextEditingController();
  String _result = "";

  Future<void> _makePrediction() async {
    final url = Uri.parse("http://<YOUR_API_URL>/predict"); // Replace <YOUR_API_URL>
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "num_loans_originated": int.parse(_numLoansController.text),
        "loan_amount_originated": double.parse(_loanAmountController.text),
        "is_private_school": int.parse(_isPrivateController.text),
        "is_subsidized_loan": int.parse(_isSubsidizedController.text),
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        _result = jsonDecode(response.body)["predicted_recipients"].toString();
      });
    } else {
      setState(() {
        _result = "Error: ${response.body}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Loan Prediction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _numLoansController, decoration: InputDecoration(labelText: "Number of Loans Originated")),
            TextField(controller: _loanAmountController, decoration: InputDecoration(labelText: "Loan Amount Originated")),
            TextField(controller: _isPrivateController, decoration: InputDecoration(labelText: "Is Private School (1 or 0)")),
            TextField(controller: _isSubsidizedController, decoration: InputDecoration(labelText: "Is Subsidized Loan (1 or 0)")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _makePrediction, child: Text("Predict")),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
