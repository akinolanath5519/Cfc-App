import 'package:agriproduce/screens/commodity_screen.dart';
import 'package:agriproduce/screens/supplier_screen.dart';
import 'package:flutter/material.dart';

import 'sack_management_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy user data
    const String userName = 'Nathaniel';
    const String userImage =
        'https://th.bing.com/th/id/OIP.LtLk-vQkLJGggWTN032pPwHaLH?rs=1&pid=ImgDetMain';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to Notifications screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to Settings screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfile(userName: userName, userImage: userImage),
            const SizedBox(height: 20.0),
            BalanceCard(),
            const SizedBox(height: 20.0),
            QuickActionsRow(),
            const SizedBox(height: 20.0),
            FinancialSummary(),
            const SizedBox(height: 20.0),
            RecentTransactions(),
            const SizedBox(height: 20.0),
            _buildManagementOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Management Options',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildOptionCard(
              context,
              'Add Supplier',
              Icons.person_add,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>SupplierScreen()),
                );
              },
            ),
            _buildOptionCard(
              context,
              'Add Commodity',
              Icons.category,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommodityScreen()),
                );
              },
            ),
            _buildOptionCard(
              context,
              'Sack Management',
              Icons.archive,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SackManagementScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.28, // Card width
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36.0, color: Theme.of(context).primaryColor),
                const SizedBox(height: 10.0),
                Text(title, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  final String userName;
  final String userImage;

  const UserProfile({
    Key? key,
    required this.userName,
    required this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(userImage),
        ),
        const SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Balance',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '\$12,345.67', // Example balance, this should be dynamic
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Balance',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Text(
                  '\$12,345.67', // Example available balance, this should be dynamic
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          QuickActionCard(
            icon: Icons.add_circle,
            label: 'Add Money',
            onTap: () {
              // Navigate to Add Money screen
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
          QuickActionCard(
            icon: Icons.send,
            label: 'Send Money',
            onTap: () {
              // Navigate to Send Money screen
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
          QuickActionCard(
            icon: Icons.history,
            label: 'Transactions',
            onTap: () {
              // Navigate to Transaction History screen
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;

  const QuickActionCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Material(
            elevation: 6.0,
            shape: const CircleBorder(),
            child: CircleAvatar(
              radius: 22.0,
              backgroundColor: backgroundColor,
              child: Icon(icon, size: 22.0, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(label, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}

class FinancialSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1, // Adjust the opacity value to make the card more faint
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Financial Summary',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Income', style: TextStyle(fontSize: 16.0)),
                  Text(
                    '\$5,000.00', // Example income, this should be dynamic
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Expenses', style: TextStyle(fontSize: 16.0)),
                  Text(
                    '\$2,000.00', // Example expenses, this should be dynamic
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            // Placeholder for recent transactions
            const Text('No recent transactions available.'),
          ],
        ),
      ),
    );
  }
}
