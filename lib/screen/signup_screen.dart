import 'package:flutter/material.dart';
import '../config/palette.dart';
import '../config/baseurl.dart';
import 'package:discord_front/auth/custom_widets.dart';
import 'package:discord_front/auth/backend_auth.dart';
import 'emailverify_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedYear = '2024';
  String _selectedMonth = '01';
  String _selectedDay = '01';

  List<String> _yearsList = List.generate(125, (int index) => (1900 + index).toString());
  List<String> _monthsList = List.generate(12, (int index) => (index + 1).toString().padLeft(2, '0'));
  List<String> _daysList = List.generate(31, (int index) => (index + 1).toString().padLeft(2, '0'));

  Future<void> _registerAccount() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;
    final String birthDate = '$_selectedYear-$_selectedMonth-$_selectedDay' + 'T12:22:46.161Z';

    if (email.isEmpty || !email.contains('@') || password.isEmpty || password.length < 6 || username.length < 3) {
      CustomWidgets.showSnackbar(context, 'Please fill out the form correctly');
      return;
    }
    final result = await AuthService.register(
      username: username,
      password: password,
      email: email,
      birthDate: birthDate,
    );
    if (result['statusCode'] == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmailVerificationScreen(email: email, username: username, password: password, date: birthDate)),
      );
    } else {
      CustomWidgets.showCustomDialog(context, 'Signup Error', 'Error: ${result['error']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Image.asset(
              'asset/img/discord_signup_background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            SingleChildScrollView(
              child: Center(
                child: CustomContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomTextFormField(controller: _usernameController, label: 'Username'),
                      CustomTextFormField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
                      CustomTextFormField(controller: _passwordController, label: 'Password', obscureText: true),
                      CustomDatePickerDropdown(yearsList: _yearsList, selectedYear: _selectedYear, selectedMonth: _selectedMonth, selectedDay: _selectedDay, onYearChanged: (value) => setState(() => _selectedYear = value!), onMonthChanged: (value) => setState(() => _selectedMonth = value!), onDayChanged: (value) => setState(() => _selectedDay = value!)),
                      CustomElevatedButton(label: 'Register', onPressed: _registerAccount),
                      CustomElevatedButton(label: 'You already have an account?', onPressed: () => Navigator.pop(context), backgroundColor: Colors.white, textColor: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}