import 'package:flutter/material.dart';
import 'package:discord_front/config/palette.dart';
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
                      Flexible(
                        flex: 1,
                        child: Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // 하 이 방법 쓰는거 싫은데 이거 말고 없냐 추천좀
                      SizedBox(height: 20),
                      Flexible(
                        flex: 2,
                        child: CustomTextFormField(controller: _usernameController, label: 'Username'),
                      ),
                      Flexible(
                        flex: 2,
                        child: CustomTextFormField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
                      ),
                      Flexible(
                        flex: 2,
                        child: CustomTextFormField(controller: _passwordController, label: 'Password', obscureText: true),
                      ),
                      Flexible(
                        flex: 2,
                        child: CustomDatePickerDropdown(
                          yearsList: _yearsList,
                          selectedYear: _selectedYear,
                          selectedMonth: _selectedMonth,
                          selectedDay: _selectedDay,
                          onYearChanged: (value) => setState(() => _selectedYear = value!),
                          onMonthChanged: (value) => setState(() => _selectedMonth = value!),
                          onDayChanged: (value) => setState(() => _selectedDay = value!),
                        ),
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        flex: 1,
                        child: CustomElevatedButton(label: 'Register', onPressed: _registerAccount),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
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