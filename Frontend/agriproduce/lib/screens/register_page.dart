import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agriproduce/services/auth_service.dart'; // Import AuthService
import 'login_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? name, email, password, adminEmail;
  bool isAdmin = false; // Track if the user is registering as an admin

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService(); // Create an instance of AuthService

      // Call the appropriate registration method based on user type
      final response = isAdmin
          ? await authService.registerAdmin(name!, email!, password!)
          : await authService.registerStandardUser(
              name!, email!, password!, adminEmail!);

      // Check if registration was successful
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful! Please login.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView( // Allows scrolling
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Changed to start
            children: [
              // User Type Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAdmin = true;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          size: 50,
                          color: isAdmin ? Colors.deepPurple : Colors.grey,
                        ),
                        Text('Admin'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAdmin = false;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: 50,
                          color: !isAdmin ? Colors.deepPurple : Colors.grey,
                        ),
                        Text('Standard User'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => name = value,
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              SizedBox(height: 20),

              // Email Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
                validator: (value) => value!.isEmpty ? 'Enter a valid email' : null,
              ),
              SizedBox(height: 20),

              // Password Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) => value!.isEmpty ? 'Enter a password' : null,
              ),
              SizedBox(height: 20),

              // Admin Email Field (optional)
              if (!isAdmin)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Admin Email',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => adminEmail = value,
                ),
              SizedBox(height: 20),

              // Register Button
              ElevatedButton(
                onPressed: _register, // Call the _register method
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                      double.infinity, 50), // Full-width button with height
                ),
              ),
              SizedBox(height: 20),

              // Navigate to Login Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
