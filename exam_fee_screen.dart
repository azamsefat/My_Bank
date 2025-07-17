import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../models/transactions.dart';
import '../app_colors.dart';
import '../widgets/custom_text_field.dart';

class ExamFeeScreen extends StatefulWidget {
  const ExamFeeScreen({super.key});

  @override
  State<ExamFeeScreen> createState() => _ExamFeeScreenState();
}

class _ExamFeeScreenState extends State<ExamFeeScreen> {
  final _regularController = TextEditingController();
  final _sessionalController = TextEditingController();
  final _regularCourseController = TextEditingController();
  final _sessionalCourseController = TextEditingController();
  List<String> regularCourses = [];
  List<String> sessionalCourses = [];
  int totalFee = 0;
  String? _error;

  void _calculateFee() {
    final regularCount = int.tryParse(_regularController.text) ?? 0;
    final sessionalCount = int.tryParse(_sessionalController.text) ?? 0;

    if (regularCount < 0 || sessionalCount < 0) {
      setState(() => _error = 'Enter valid numbers');
      return;
    }

    setState(() {
      totalFee = (regularCount * 30) + (sessionalCount * 50);
      _error = null;
    });
  }

  void _payExamFee() {
    final user = mockAuthService.currentUser;
    if (user == null) {
      setState(() => _error = 'No user logged in');
      return;
    }

    if (totalFee <= 0) {
      setState(() => _error = 'Calculate fee first');
      return;
    }

    if (user.balance < totalFee) {
      setState(() => _error = 'Insufficient balance');
      return;
    }

    setState(() {
      user.balance -= totalFee;
      user.transactions.add(Transaction(
        title: 'Exam Fee (${regularCourses.length}R ${sessionalCourses.length}S)',
        amount: -totalFee.toDouble(),
        date: DateTime.now(),
      ));
      _error = null;
    });

    Navigator.pop(context);
  }

  void _addRegularCourse() {
    if (_regularCourseController.text.isNotEmpty) {
      setState(() {
        regularCourses.add(_regularCourseController.text);
        _regularCourseController.clear();
      });
    }
  }

  void _addSessionalCourse() {
    if (_sessionalCourseController.text.isNotEmpty) {
      setState(() {
        sessionalCourses.add(_sessionalCourseController.text);
        _sessionalCourseController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Fee Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Regular Courses Section
            const Text('Regular Courses', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomTextField(
              label: 'Add Regular Course Name',
              controller: _regularCourseController,
            ),
            ElevatedButton(
              onPressed: _addRegularCourse,
              child: const Text('Add Course'),
            ),
            if (regularCourses.isNotEmpty)
              Column(
                children: [
                  const Text('Your Regular Courses:'),
                  ...regularCourses.map((course) => ListTile(
                    title: Text(course),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _regularCourseController.text = course;
                        setState(() => regularCourses.remove(course));
                      },
                    ),
                  )).toList(),
                ],
              ),

            // Sessional Courses Section
            const SizedBox(height: 20),
            const Text('Sessional Courses', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomTextField(
              label: 'Add Sessional Course Name',
              controller: _sessionalCourseController,
            ),
            ElevatedButton(
              onPressed: _addSessionalCourse,
              child: const Text('Add Course'),
            ),
            if (sessionalCourses.isNotEmpty)
              Column(
                children: [
                  const Text('Your Sessional Courses:'),
                  ...sessionalCourses.map((course) => ListTile(
                    title: Text(course),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _sessionalCourseController.text = course;
                        setState(() => sessionalCourses.remove(course));
                      },
                    ),
                  )).toList(),
                ],
              ),

            // Fee Calculation Section
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Regular Courses Count',
                    controller: _regularController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    label: 'Sessional Courses Count',
                    controller: _sessionalController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculateFee,
              child: const Text('Calculate Fee'),
            ),
            if (totalFee > 0) Text(
              'Total Exam Fee: ৳$totalFee',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (totalFee > 0)
              ElevatedButton(
                onPressed: _payExamFee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Pay Exam Fee'),
              ),
          ],
        ),
      ),
    );
  }
}