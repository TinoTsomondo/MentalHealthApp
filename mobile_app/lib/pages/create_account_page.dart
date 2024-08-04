import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // Add crypto package for hashing
import 'dart:convert'; // For utf8.encode
import '../services/account_service.dart';
import 'loading_screen.dart'; // Import the LoadingScreen
import 'error_page.dart'; // Import the ErrorPage
import 'terms_and_conditions_page.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool _agreedToTerms = false;
  DateTime? _selectedDate;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _selectedGender = 'Male'; // Default gender selection
  final AccountService accountService = AccountService();

  // Hash the password before sending it to the backend
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Select the date of birth
  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Validate the age
  bool _isValidAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return false;
    }
    final today = DateTime.now();
    final age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month || (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      return age - 1 >= 18;
    }
    return age >= 18;
  }

  // Create the account
  Future<void> _createAccount() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must agree to the terms and conditions')),
      );
      return;
    }

    if (!_isValidAge(_selectedDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be at least 18 years old')),
      );
      return;
    }

    try {
      final username = _usernameController.text;
      final passwordHash = _hashPassword(_passwordController.text); // Hash the password
      final email = _emailController.text;
      final fullName = _fullNameController.text;
      final dateOfBirth = _selectedDate?.toIso8601String().split('T')[0] ?? ''; // Format date as YYYY-MM-DD
      final gender = _selectedGender;

      await accountService.createAccount(username, passwordHash, email, fullName, dateOfBirth, gender, false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create account: $e')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ErrorPage(message: e.toString())), // Correct parameter
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create Account'),
        centerTitle: true,
        backgroundColor: Color(0xFFb2c2a1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full Name',
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: ['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gender',
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Date of Birth: ${_selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : 'Not selected'}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text('I agree to the terms and conditions'),
              value: _agreedToTerms,
              onChanged: (bool? value) {
                setState(() {
                  _agreedToTerms = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            SizedBox(height: 20),
             ElevatedButton(
  onPressed: _createAccount,
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFdcc9f3), // Replace 'primary' with 'backgroundColor'
    foregroundColor: Colors.black,     // Replace 'onSurface' with 'foregroundColor'
  ),
  child: Text('Create Account'),
),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
                );
              },
              child: Text('Read Terms and Conditions'),
            ),
          ],
        ),
      ),
    );
  }
}
