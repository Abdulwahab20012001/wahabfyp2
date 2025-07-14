import 'package:admin_panel/CustomColors.dart';
import 'package:admin_panel/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider
import 'admin_dashboard.dart'; // Import the admin dashboard

class AdminLoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Admin Panel'),
          backgroundColor: AppColors.lightBlue),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Adjusted "Admin Login" text
            const Padding(
              padding: EdgeInsets.only(
                  bottom:
                      20.0), // Adjust this value to move the text up or down
              child: Text(
                'Admin Login',
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
            ),
            // Email TextField
            SizedBox(
              width: 300,
              height: 50, // Set the width of the TextField
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Password TextField
            SizedBox(
              width: 300,
              height: 50, // Set the width of the TextField
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Login Button
            SizedBox(
              width: 150, // Set the width of the Button
              child: ElevatedButton(
                onPressed: () async {
                  bool isAuthenticated =
                      await Provider.of<AuthProvider>(context, listen: false)
                          .loginAdmin(
                              emailController.text, passwordController.text);

                  if (isAuthenticated) {
                    // Navigate to the DashboardScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDashboard()),
                    );
                  } else {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid credentials')),
                    );
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: AppColors.black),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.lightBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
