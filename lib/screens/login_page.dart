// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'signup_page.dart';
import 'home_page.dart';
import 'authentication_service.dart';
import 'forgot_password.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String?> _login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('https://reqres.in/api/login'),
      body: {
        'phone': _phoneNumberController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];
      return token;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text('Invalid phone number or password.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthenticationService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while authentication status is being fetched
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Handle error state
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.data == true) {
          // Redirect to home page if the user is already authenticated
          return HomePage(token: '');
        } else {
          // Show the login page if the user is not authenticated
          return Scaffold(
            appBar: AppBar(title: Text('Login')),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  IntlPhoneField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    initialCountryCode: 'IN', // Set initial country code
                    onChanged: (phone) {
                      print(phone.completeNumber); // Print complete phone number
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final token = await _login(context);
                      if (token != null) {
                        // Save the authentication status and token
                        await AuthenticationService.setAuthenticated(true);
                        await AuthenticationService.setToken(token);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(token: ''),
                          ),
                        );
                      }
                    },
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
