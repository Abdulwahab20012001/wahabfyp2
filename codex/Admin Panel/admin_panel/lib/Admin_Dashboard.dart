import 'package:admin_panel/CustomColors.dart';
import 'package:admin_panel/Dashboard_screen.dart';
import 'package:admin_panel/Profile_Screen.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // Pages for Dashboard and Admin Profile
  final List<Widget> _pages = [
    DashboardScreen(),
    AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.grey[200],
      ),
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.grey[200],
            child: Column(
              children: [
                Divider(
                  color: AppColors.black,
                  thickness: 1,
                  height: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Admin Profile'),
                  selected: _selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex], // Display the selected page
          ),
        ],
      ),
    );
  }
}
