import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';  // Ensure correct import
import '../models/transactions.dart';
import '../widgets/custom_text_field.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();
  String _message = '';

  void _withdraw() {
    final user = mockAuthService.currentUser;
    if (user == null) {
      setState(() => _message = 'No user logged in');
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      setState(() => _message = 'Enter valid amount');
      return;
    }

    if (user.balance < amount) {
      setState(() => _message = 'Insufficient funds');
      return;
    }

    setState(() {
      user.balance -= amount;
      user.transactions.add(Transaction(
        title: 'Withdrawal',
        amount: -amount,
        date: DateTime.now(),
      ));
      _message = 'Withdrew ৳${amount.toStringAsFixed(2)}';
      _amountController.clear();
    });

    // ✅ Return to dashboard and trigger refresh
    Navigator.pop(context, true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw Money')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Current Balance: ৳${mockAuthService.currentUser?.balance.toStringAsFixed(2) ?? "0.00"}',  // Use renamed instance
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _withdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Withdraw'),
            ),
            const SizedBox(height: 20),
            Text(_message, style: TextStyle(
              color: _message.contains('Withdrew') ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
      ),
    );
  }
}