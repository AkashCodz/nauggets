// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';

import 'login_page.dart';
import 'authentication_service.dart';

class HomePage extends StatelessWidget {
  final String token;

  const HomePage({required this.token});

  Future<void> _logout(BuildContext context) async {
    // Perform any necessary logout actions here
    // For example, clear user data, invalidate tokens, etc.
    await AuthenticationService.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Page!'),
            SizedBox(height: 16.0),
            Text('Token: $token'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _logout(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
