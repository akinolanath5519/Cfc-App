import 'package:flutter/material.dart';
import 'package:agriproduce/services/auth_service.dart'; // Import AuthService
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'login_page.dart'; // Import your LoginPage

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () async {
                // Call the logout method from AuthService with ref
                await AuthService().logout(ref);

                // Navigate back to the Login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple // Text color
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
