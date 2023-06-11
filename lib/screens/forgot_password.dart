// ignore_for_file: avoid_print
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> _sendResetLink(BuildContext context) async {
    // Implement your password reset logic here
    final phoneNumber = _phoneNumberController.text;
    // Send a password reset link to the provided phone number
    // Example: You can use an API or send an SMS with a reset code

    // Show a success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Code Sent'),
          content: Text('A reset code has been sent to $phoneNumber.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntlPhoneField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
              initialCountryCode: 'IN', // Optionally provide an initial country code
              onChanged: (phone) {
                print(phone.completeNumber); // Print the complete phone number
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _sendResetLink(context);
              },
              child: Text('Send Reset Code'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Remembered your password?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text('Login'),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
