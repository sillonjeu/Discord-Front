import 'package:discord_front/screen/server_page.dart';
import 'package:flutter/material.dart';
import 'package:discord_front/screen/signup_screen.dart';
import 'package:discord_front/auth/token_manager.dart';
import 'package:discord_front/auth/token_provider.dart';
import 'package:provider/provider.dart';
import 'package:discord_front/auth/custom_widets.dart';
import '../auth/backend_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Email 형식 체크
    if (email.isEmpty || !email.contains('@') || password.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('유효한 Email또는 Password를 입력해주세요')),
      );
      return;
    }

    // backend_auth 참조 -> login
    final result = await AuthService.login(email, password);

    if (result.containsKey('accessToken') && result.containsKey('refreshToken')) {
      await TokenManager.saveTokens(result['accessToken'], result['refreshToken']);
      Provider.of<AuthProvider>(context, listen: false).setTokens(result['accessToken'], result['refreshToken']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServerPage(useremail: email)),
      );
    } else {
      CustomWidgets.showCustomDialog(context, 'Login Error', 'Error: ${result['error']}');
    }
  }

  void _signup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Image.asset(
              'asset/img/discord_mobile_background.png',
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
                        flex: 2, // 이미지에 할당할 공간의 비율
                        child: Container(
                          width: double.infinity,
                          height: 100.0, // 이미지의 높이 설정
                          child: Image.asset(
                            'asset/img/default_server_image.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Flexible(
                        flex: 2, // Email 입력 필드에 할당할 공간의 비율
                        child: CustomTextFormField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Flexible(
                        flex: 2, // Password 입력 필드에 할당할 공간의 비율
                        child: CustomTextFormField(
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 30),
                      Flexible(
                        flex: 1, // Login 버튼에 할당할 공간의 비율
                        child: CustomElevatedButton(
                          label: 'Login',
                          onPressed: _login,
                        ),
                      ),
                      Flexible(
                        flex: 1, // Signup 버튼에 할당할 공간의 비율
                        child: CustomElevatedButton(
                          label: 'Signup',
                          onPressed: _signup,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}