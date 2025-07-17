import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart'; // Ensure correct import
import '../models/transactions.dart';
import '../app_colors.dart';
import '../widgets/custom_text_field.dart'; // Import custom text field

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _message;

  void _deposit() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() {
        _message = 'Please enter a valid amount.';
      });
      return;
    }

    final user = mockAuthService.currentUser; // Use renamed instance
    if (user == null) {
      setState(() {
        _message = 'No user is currently logged in.';
      });
      return;
    }

    setState(() {
      user.balance += amount;
      user.transactions.add(Transaction(
        title: 'Deposit',
        amount: amount,
        date: DateTime.now(),
      ));
      _message = 'Successfully deposited ৳$amount!';
      _amountController.clear();
    });
    Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {
    final user = mockAuthService.currentUser; // Use renamed instance

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deposit Money'),
          backgroundColor: AppColors.primaryColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Balance: ৳${user?.balance.toStringAsFixed(2) ?? "0.00"}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomTextField( // Using custom text field
                label: 'Amount to deposit',
                controller: _amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _deposit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Deposit'),
                ),
              ),
              const SizedBox(height: 16),
              if (_message != null)
                Text(
                  _message!,
                  style: TextStyle(
                    color: _message!.contains('Successfully') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}