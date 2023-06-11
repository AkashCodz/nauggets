// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'login_page.dart';
import 'authentication_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _showPassword = false;

  Future<String?> _signup(BuildContext context) async {
    final response = await http.post(
      Uri.parse('https://reqres.in/api/register'),
      body: {
        'email': _phoneNumberController.text,
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
            title: Text('Signup Error'),
            content: Text('Failed to sign up.'),
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

  Future<void> _authenticateUser(String token) async {
    await AuthenticationService.setAuthenticated(true);
    await AuthenticationService.setToken(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              IntlPhoneField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: !_showPassword,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: !_showPassword,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Show Password'),
                  Checkbox(
                    value: _showPassword,
                    onChanged: (value) {
                      setState(() {
                        _showPassword = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  final token = await _signup(context);
                  if (token != null) {
                    await _authenticateUser(token);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: const Text('Log In'),
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
