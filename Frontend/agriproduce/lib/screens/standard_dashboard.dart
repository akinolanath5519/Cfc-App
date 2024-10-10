import 'package:agriproduce/screens/calculator_screen.dart';
import 'package:agriproduce/screens/purchases_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agriproduce/services/auth_service.dart'; // Import AuthService
import 'login_page.dart'; // Import the Login Page
import 'supplier_screen.dart'; // Import SupplierScreen

class StandardDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Standard Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Call the logout method from AuthService
              await AuthService().logout(ref);

              // Navigate back to the Login page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Manage Suppliers'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupplierScreen()),
              );
            },
          ),
          ListTile(
            title: Text('calculator screen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalculatorScreen()),
              );
            },
          ),
           ListTile(
            title: Text('purchases screen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PurchasesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
