import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../models/user.dart'; // ✅ Import the correct User model


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    mockAuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = mockAuthService.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('No user logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Account Number: ${user.accountNumber}', style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _logout(context),
                child: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
